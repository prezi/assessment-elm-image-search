module PreziImageSearchEmbed where

import Dict
import Json
import String

import PreziImageSearch
import PreziImageSearch.Config as Config
import PreziImageSearch.Config (..)
import PreziImageSearch.SearchEngine (SearchResultEntry)

{- Input ports -}

port configIn : Signal
    { width                : Int
    , imagePadding         : Int
    , googleCustomSearchId : String
    , googleApiKey         : String
    , googleTestResponse   : Bool
    , language             : String
    }

{- Output ports -}

port selectedImageOut : Signal (Maybe Json.Value)
port selectedImageOut = convertResult <~ PreziImageSearch.selectedImages

{- SearchResultEntry conversion -}

convertResult : SearchResultEntry -> Maybe Json.Value
convertResult entry =
    let
        strProp name value = (name, Json.String value)
        intProp name value = (name, Json.Number (toFloat value))
    in
        if not (String.isEmpty entry.url)
            then Just
                    (Json.Object
                        (Dict.fromList
                            [ strProp "url"             entry.url
                            , intProp "width"           entry.width
                            , intProp "height"          entry.height
                            , strProp "thumbnailUrl"    entry.thumbnailUrl
                            , intProp "thumbnailWidth"  entry.thumbnailWidth
                            , intProp "thumbnailHeight" entry.thumbnailHeight
                            ]))
            else Nothing

{- Config conversion -}

convertedConfigSignal = convertConfig <~ configIn

convertConfig jsConf =
    { jsConf | language <-
                case jsConf.language of
                    "Hun" -> Config.Hun
                    "Eng" -> Config.Eng
    }

{- Main -}

main : Signal Element
main = PreziImageSearch.widget convertedConfigSignal
