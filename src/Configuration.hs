
{-# OPTIONS -Wno-unused-top-binds #-}

{-# LANGUAGE LambdaCase        #-}
{-# LANGUAGE OverloadedStrings #-}


module Configuration (
        Instance(..),
        Config(..),
        configCodec,
        instanceCodec
    )
    where


import Data.Text (Text)
import Data.Time (Day)
import Toml (TomlCodec, (.=))

import qualified Data.Text.IO as TIO
import qualified Toml


data Instance = Instance 
    {   path :: String
    ,   name :: String
    ,   excludeFolders :: ![String]
    ,   folders :: ![String]
    }

data Config = Config
    {   directory :: String
    ,   defaultInstance :: !String
    ,   instances :: ![Instance]
    }


instanceCodec :: TomlCodec Instance
instanceCodec = Instance
    <$> Toml.diwrap (Toml.string  "path")           .= path
    <*> Toml.string               "name"            .= name
    <*> Toml.arrayOf Toml._String "exclude-folders" .= excludeFolders
    <*> Toml.arrayOf Toml._String "folders"         .= folders

configCodec :: TomlCodec Config
configCodec = Config
    <$> Toml.diwrap (Toml.string "directory")       .= directory
    <*> Toml.string              "default-instance" .= defaultInstance
    <*> Toml.list instanceCodec  "instance"         .= instances