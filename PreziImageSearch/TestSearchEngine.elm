module PreziImageSearch.TestSearchEngine where

import Dict
import Http
import Json
import PreziImageSearch.SearchEngine (..)

results : Signal SearchQuery -> Signal SearchResult
results queries = httpResponseToResult <~ Http.sendGet (queryToTestFileName <~ queries)

queryToTestFileName : SearchQuery -> String
queryToTestFileName query = if String.isEmpty query then "" else ("test_data/" ++ query ++ ".json")

httpResponseToResult : Http.Response String -> SearchResult
httpResponseToResult httpResponse =
    case httpResponse of
        Http.Success body -> httpBodyToResult body
        Http.Waiting      -> []
        Http.Failure _ _  -> []

httpBodyToResult : String -> SearchResult
httpBodyToResult body =
    case Json.fromString body of
        Just value -> jsonToResult value
        Nothing    -> []

jsonToResult : Json.Value -> SearchResult
jsonToResult value =
    case value of
        Json.Object dict ->
            case Dict.get "images" dict of
                Just (Json.Array images) -> map jsonToEntry images
                Nothing -> []
        otherwise -> []

jsonToEntry : Json.Value -> SearchResultEntry
jsonToEntry imageJson =
    newSearchResultEntry
        (getStringPropOrElse "" "url" imageJson)
        (getStringPropOrElse "" "thumbnailUrl" imageJson)

getStringPropOrElse : String -> String -> Json.Value -> String
getStringPropOrElse def key obj =
    case obj of
        Json.Object dict ->
            case Dict.get key dict of
                Just (Json.String str) -> str
                Nothing                -> def
        otherwise        ->
            def