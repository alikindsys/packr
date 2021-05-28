{-# LANGUAGE OverloadedStrings #-}

{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE TupleSections #-}

module ModMetadata (

    )
     where

import Data.Aeson.Types
    ( (.:), (.:?), FromJSON(parseJSON), Value(Object, String), Parser )
import Data.Aeson
import Data.Maybe
import qualified Data.ByteString.Lazy as BL
import Control.Applicative (Alternative((<|>)))
import qualified Data.Text as T
import qualified Data.Vector as V
import qualified Data.Map as M
import qualified Data.HashMap.Strict as HM
import Data.Map (Map, keys)
import Control.Monad (forM_, forM)
import Data.List (partition)
import Data.Maybe (catMaybes)
import Salve


data FabricJson = FabricJson
    {   schemaVersion :: Int 
    ,   id :: String
    ,   _version :: Version
    ,   __description :: String
    ,   authors :: Maybe [FabricPerson]
    ,   contact :: Maybe FabricContact 
    }

instance FromJSON Version where
    parseJSON (String s) = do
        maybe (fail "Invalid version number") return attempt
        where
            attempt = parseVersion $ T.unpack s

instance ToJSON Version where
    toJSON a = String <$> T.pack $ renderVersion a

instance FromJSON Constraint where
    parseJSON (String "*") = do
      maybe (fail "Invalid version constraint") pure attempt
      where
        attempt = parseConstraint "x.x.x"
    parseJSON (String s) = do
        maybe (fail "Invalid version constraint") return attempt
        where
            attempt = parseConstraint $ T.unpack s

instance ToJSON Constraint where
    toJSON a = String <$> T.pack $ renderConstraint a


instance FromJSON FabricJson where
    parseJSON (Object v) = FabricJson
        <$> v .: "schemaVersion"
        <*> v .: "id"
        <*> v .: "version"
        <*> v .: "description"
        <*> v .:? "authors"
        <*> v .:? "contact"


data FabricEnvironment = All | Client | Server

instance FromJSON FabricEnvironment where
    parseJSON = withText "environment" $ \case
            "*" -> return All
            "client" -> return Client
            "server" -> return Server
            _ -> fail "Unsupported Environment Type"


data FabricEntrypoint = FabricEntrypoint
    {   adapter :: Maybe String
    ,   value :: String
    }


data FabricVersionRange = Singleton Constraint | Range [Constraint]
    deriving (Show)

instance FromJSON FabricVersionRange where
    parseJSON (String s) = Singleton <$> parseJSON (String s)
    
    parseJSON (Array arr) = Range <$> parseJSON (Array arr)

instance ToJSON FabricVersionRange where
    toJSON (Singleton s) = toJSON s
    
    toJSON (Range arr) = toJSON arr

data FabricDependency = FabricDependency
    {   _id :: String
    ,   constraints :: FabricVersionRange
    }
    deriving (Show)

data FabricDependencyBlock = FabricDependencyBlock
  {  dependencies :: [FabricDependency]
  }
  deriving (Show)


dependencyParser :: T.Text -> Value -> Parser FabricDependency
dependencyParser k v = do
    x <- parseJSON v
    pure FabricDependency { _id = T.unpack  k, constraints = x }

dependencyBlockParser :: [T.Text] -> [Value] -> Parser [FabricDependency]
dependencyBlockParser [] _ = pure []

dependencyBlockParser (k:ks) (v:vs) = do
  single <- dependencyParser k v
  rest <- dependencyBlockParser ks vs
  pure (single : rest)

data FabricContact = FabricContact
    {   homepage :: Maybe String
    ,   sources :: Maybe String
    ,   issues :: Maybe String
    ,   irc :: Maybe String
    ,   email :: Maybe String
    ,   custom :: Map String String
    }
    deriving (Show)

instance FromJSON FabricContact where
    parseJSON (Object v) = do
        mhp    <- v .:? "homepage"
        msrc   <- v .:? "sources"
        miss   <- v .:? "issues"
        mirc   <- v .:? "irc"
        memail <- v .:? "email"
        rest <- mapM (\(k,o) -> (T.unpack k,) <$> parseJSON o)
              (HM.toList theRest)
        return $ FabricContact mhp msrc miss mirc memail (M.fromList rest)
        where
            theRest = foldr HM.delete v ["homepage", "sources", "issues", "irc", "email"]


data FabricPerson = FabricPerson
    {   _name :: String
    ,   _contact :: Maybe FabricContact
    }

instance FromJSON FabricPerson where
    parseJSON (Object v) = FabricPerson
        <$> v .: "name"
        <*> v .:? "contact"

    parseJSON (String s) =
        pure FabricPerson {_name=T.unpack s, _contact=Nothing}
