module PreziImageSearch.JsonUtil where

import Dict
import Json

getStringPropOrElse : String -> String -> Json.Value -> String
getStringPropOrElse def key obj =
    case obj of
        Json.Object dict ->
            case Dict.get key dict of
                Just (Json.String str) -> str
                _                      -> def
        otherwise        ->
            def

getIntPropOrElse : Int -> String -> Json.Value -> Int
getIntPropOrElse def key obj =
    case obj of
        Json.Object dict ->
            case Dict.get key dict of
                Just (Json.Number num) -> round num
                otherwise              -> def
        otherwise        ->
            def