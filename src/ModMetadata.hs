module ModMetadata (

    )
     where


data FabricJson = FabricJson
    {   schemaVersion :: Int 
    ,   id :: String
    ,   _version :: String
    ,   __description :: String
    ,   authors :: ![Either String FabricPerson]
    ,   contact :: !FabricContact 
    }

data FabricContact = FabricContact
    {   homepage :: !String
    ,   sources :: !String
    ,   issues :: !String
    ,   irc :: !String
    ,   email :: !String
    }

data FabricPerson = FabricPerson
    {   _name :: String
    ,   _contact :: !FabricContact
    }
