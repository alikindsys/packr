module Modpack (
        Mod(..)
    ,   Modloader(..)
    ,   Target(..)
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
