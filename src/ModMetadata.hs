{-# LANGUAGE OverloadedStrings #-}

module ModMetadata (

    )
     where

import Data.Aeson.Types
import Data.Aeson

data FabricJson = FabricJson
    {   schemaVersion :: Int 
    ,   id :: String
    ,   _version :: String
    ,   __description :: String
    ,   authors :: Maybe [Either String FabricPerson]
    ,   contact :: Maybe FabricContact 
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
