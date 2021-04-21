{-# LANGUAGE OverloadedStrings #-}

module JavaArchive (
        getModType 
    ,   readArchive
    ,   ModType(..)
    ) 
    where

import Codec.Archive.Zip
import System.FilePath
import qualified Data.Map as M
import Utils (filterByList)

data ModType = Fabric | ForgeTOML | ForgeInfo
            deriving (Show)


getModType :: FilePath -> IO [ModType]
getModType mod = do
    result <- sequence [isFabricMod mod,isForgeTomlMod mod,isForgeInfoMod mod] 
    pure $ filterByList result [Fabric, ForgeTOML, ForgeInfo]
    

isFabricMod :: FilePath -> IO Bool 
isFabricMod mod = do
    selector <- mkEntrySelector "fabric.mod.json"
    withArchive mod (doesEntryExist selector)

isForgeTomlMod :: FilePath -> IO Bool 
isForgeTomlMod mod = do
    selector <- mkEntrySelector "META-INF/mods.toml"
    withArchive mod (doesEntryExist selector)

isForgeInfoMod :: FilePath -> IO Bool 
isForgeInfoMod mod = do
    selector <- mkEntrySelector "mcmod.info"
    withArchive mod (doesEntryExist selector)


readArchive :: FilePath -> IO [EntrySelector]
readArchive mod = withArchive mod (M.keys <$> getEntries) 
