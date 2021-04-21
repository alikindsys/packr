module Platforms (
        getMinecraftInstallFolder
    ) 
    where 

import System.Info (os)
import System.Environment (getEnv)

getMinecraftInstallFolder :: IO String 
getMinecraftInstallFolder 
    | os == "linux" = do
        x <- getEnv "HOME" 
        pure $ x ++ "/.minecraft"
    | os == "darwin" = do
        x <- getEnv "HOME"
        pure $ x ++ "/Library/Application Support/minecraft"
    | os == "mingw32" = do
        x <- getEnv "appdata"
        pure $ x ++ "/.minecraft"
    | otherwise = do
        error ""