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
    parseJSON = withObject "contact" $ \obj -> do
        homepage  <- obj .:? "homepage"
        sources   <- obj .:? "sources"
        issues    <- obj .:? "issues"
        irc       <- obj .:? "irc"
        email     <- obj .:? "email"
        return (FabricContact {homepage=homepage, sources=sources, issues=issues, irc=irc, email=email}) 

data FabricPerson = FabricPerson
    {   _name :: String
    ,   _contact :: Maybe FabricContact
    }
