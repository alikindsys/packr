module Modpack (
        Mod(..)
    ) 
    where

data Mod = Mod 
    {   name :: String
    ,   version :: String 
    ,   dependecies :: [Mod]
    }