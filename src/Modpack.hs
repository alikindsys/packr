module Modpack (
        Mod(..)
    ,   Modloader(..)
    ) 
    where

data Mod = Mod 
    {   name :: String
    ,   version :: String 
    ,   dependecies :: [Mod]
    }

data Modloader = Forge | Fabric
