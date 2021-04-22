{-# LANGUAGE OverloadedStrings #-}

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
