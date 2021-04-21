module Modpack (
        Mod(..)
    ,   Modloader(..)
    ,   Target(..)
    ,   Modpack(..)
    ) 
    where

data Mod = Mod 
    {   name :: String
    ,   version :: String 
    ,   dependecies :: [Mod]
    }

data Modloader = Forge | Fabric

data Target = Target 
    {   mcVersion :: String
    ,   modloader :: Modloader
    }

data Modpack = Modpack 
    {   _name :: String
    ,   target :: Target
    ,   mods :: [Mod]
    }