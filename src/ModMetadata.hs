{-# LANGUAGE OverloadedStrings #-}

{-# LANGUAGE LambdaCase #-}
module ModMetadata (

    )
     where

import Data.Aeson.Types
    ( (.:), (.:?), FromJSON(parseJSON), Value(Object, String), Parser )
import Data.Aeson
import qualified Data.ByteString.Lazy as BL
import Control.Applicative (Alternative((<|>)))
import qualified Data.Text as T
import qualified Data.Vector as V

data FabricJson = FabricJson
    {   schemaVersion :: Int 
    ,   id :: String
    ,   _version :: String
    ,   __description :: String
    ,   authors :: Maybe [String]
    ,   contact :: Maybe FabricContact 
    }
    deriving (Show)

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

data FabricContact = FabricContact
    {   homepage :: Maybe String
    ,   sources :: Maybe String
    ,   issues :: Maybe String
    ,   irc :: Maybe String
    ,   email :: Maybe String
    }
    deriving (Show)

instance FromJSON FabricContact where
    parseJSON (Object v) = FabricContact 
        <$> v .:? "homepage"
        <*> v .:? "sources"
        <*> v .:? "issues"
        <*> v .:? "irc"
        <*> v .:? "email"


data FabricPerson = FabricPerson
    {   _name :: String
    ,   _contact :: Maybe FabricContact
    }

instance FromJSON FabricPerson where
    parseJSON (Object v) = FabricPerson
        <$> v .: "name"
        <*> v .:? "contact"
