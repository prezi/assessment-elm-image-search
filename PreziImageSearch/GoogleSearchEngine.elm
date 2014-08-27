module  PreziImageSearch.GoogleSearchEngine where

import Dict
import Http
import Json

import PreziImageSearch.Config (Config)
import PreziImageSearch.SearchEngine (..)
import PreziImageSearch.JsonUtil (..)

results : Signal Config -> Signal SearchQuery -> Signal SearchResult
results config queries = jsonStringToResults config queries

jsonStringToResults : Signal Config -> Signal SearchQuery -> Signal SearchResult
jsonStringToResults config queries = (jsonToResult . stringToJson)  <~ (stringResults config queries)

stringResults : Signal Config -> Signal SearchQuery -> Signal String
stringResults config queries = httpResponseToString <~ Http.send (queryToGet <~ config ~ queries)

jsonToResult : Json.Value -> SearchResult
jsonToResult value =
    case value of
        Json.Object dict ->
            case Dict.get "items" dict of
                Just (Json.Array items) -> justs (map itemJsonToEntry items)
                Nothing -> []
        otherwise -> []

itemJsonToEntry : Json.Value -> Maybe SearchResultEntry
itemJsonToEntry item =
    case item of
        Json.Object dict ->
            case Dict.get "link" dict of
                Just (Json.String url) ->
                    case Dict.get "image" dict of
                        Just imageJson -> Just (imageJsonToEntry url imageJson)
                        otherwise -> Nothing
                otherwise -> Nothing
        otherwise -> Nothing

imageJsonToEntry : String -> Json.Value -> SearchResultEntry
imageJsonToEntry url imageJson =
        { url             = url
        , width           = getIntPropOrElse    0  "width"           imageJson
        , height          = getIntPropOrElse    0  "height"          imageJson
        , thumbnailUrl    = getStringPropOrElse "" "thumbnailLink"   imageJson
        , thumbnailWidth  = getIntPropOrElse    0  "thumbnailWidth"  imageJson
        , thumbnailHeight = getIntPropOrElse    0  "thumbnailHeight" imageJson
        }

stringToJson : String -> Json.Value
stringToJson str = 
    case Json.fromString str of
        Just value -> value
        Nothing    -> Json.String ""

queryToGet : Config -> SearchQuery -> (Http.Request String)
queryToGet config query =
    if  | String.isEmpty query -> Http.request "" "" "" []
        | config.googleTestResponse -> Http.request "GET" "/test_data/google_test.json" "" []
        | otherwise ->
            Http.request "GET"
                ( addGetParamters baseUrl 
                  [ ("cx", config.googleCustomSearchId)
                  , ("key", config.googleApiKey)
                  , ("searchType", "image")
                  , ("q", query)
                  ]
                )
                "" []

baseUrl = "https://www.googleapis.com/customsearch/v1"

addGetParamters : String -> [(String, String)] -> String
addGetParamters baseUrl parameters =
    baseUrl ++ "?" ++ (join "&" <| map (\(k, v) -> encode(k) ++ "=" ++ encode(v)) parameters)

-- TODO:
encode : String -> String
encode s = s

httpResponseToString : Http.Response String -> String
httpResponseToString httpResponse =
    case httpResponse of
        Http.Success body -> body
        Http.Waiting      -> "waiting"
        Http.Failure _ _  -> show httpResponse
