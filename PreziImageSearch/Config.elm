module PreziImageSearch.Config where


data Language
    = Hun
    | Eng


type Config = {
        width : Int,
        imagePadding : Int,
        googleCustomSearchId : String,
        googleApiKey : String,
        googleTestResponse : Bool,
        language : Language,
    }

-- A PreConfig is a config where language is given as a string.
type PreConfig = {
        width : Int,
        imagePadding : Int,
        googleCustomSearchId : String,
        googleApiKey : String,
        googleTestResponse : Bool,
        language : String,
    }

-- Complete PreConfig to a Config by transforming its language property to the
-- Language ADT, falling back to Eng.
completePreconfig : PreConfig -> Config
completePreconfig config = {
        config |
            language <-
                case config.language of
                    "Hun" -> Hun
                    "Eng" -> Eng
                    _     -> Eng
    }

