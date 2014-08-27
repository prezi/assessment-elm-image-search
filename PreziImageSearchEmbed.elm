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
    { jsConf | language <-
                case jsConf.language of
                    "Hun" -> Config.Hun
                    "Eng" -> Config.Eng
    }

main : Signal Element
main = PreziImageSearch.widget convertedConfigSignal

