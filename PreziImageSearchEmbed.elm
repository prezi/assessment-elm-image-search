module PreziImageSearchEmbed where

import PreziImageSearch
import PreziImageSearch.Config as Config
import PreziImageSearch.Config (..)

port configIn : Signal
    { width                : Int
    , imagePadding         : Int
    , googleCustomSearchId : String
    , googleApiKey         : String
    , googleTestResponse   : Bool
    , language             : String
    }

convertedConfigSignal = convertConfig <~ configIn

convertConfig jsConf =
    { jsConf | googleTestResponse <- False
             , language <-
                case jsConf.language of
                    "Hun" -> Config.Hun
                    "Eng" -> Config.Eng
    }


config : Config.Config
config =
    { width                = 300
    , imagePadding         = 8
    , googleCustomSearchId = ""
    , googleApiKey         = ""
    , googleTestResponse   = False
    , language             = Config.Hun
    }

main : Signal Element
main = PreziImageSearch.widget convertedConfigSignal

