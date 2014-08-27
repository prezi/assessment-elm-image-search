module PreziImageSearch.Config where

data Language = Hun | Eng

type Config =
    { width : Int
    , imagePadding : Int
    , googleCustomSearchId : String
    , googleApiKey : String
    , googleTestResponse : Bool
    , language : Language
    }