module ModMetadata (

    )
     where


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

data FabricPerson = FabricPerson
    {   _name :: String
    ,   _contact :: Maybe FabricContact
    }
