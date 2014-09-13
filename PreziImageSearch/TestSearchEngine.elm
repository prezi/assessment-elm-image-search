module PreziImageSearch.TestSearchEngine where

import Dict
import Http
import Json
import Maybe
import String

import PreziImageSearch.JsonUtil (..)
import PreziImageSearch.SearchEngine (..)


results : Signal SearchQuery -> Signal SearchResult
results queries =
    httpResponseToResult <~ Http.sendGet (queryToTestFileName <~ queries)


queryToTestFileName : SearchQuery -> String
queryToTestFileName query =
    if String.isEmpty query
        then ""
        else ("/test_data/" ++ query ++ ".json")


httpResponseToResult : Http.Response String -> SearchResult
httpResponseToResult httpResponse =
    case httpResponse of
        Http.Success body -> httpBodyToResult body
        Http.Waiting -> []
        Http.Failure _ _ -> []


httpBodyToResult : String -> SearchResult
httpBodyToResult body =
    Maybe.maybe [] (\v -> jsonToResult v) (Json.fromString body)


jsonToResult : Json.Value -> SearchResult
jsonToResult value =
    case value of
        Json.Object dict ->
            case Dict.get "images" dict of
                Just (Json.Array images) -> map jsonToEntry images
                Nothing -> []
        otherwise -> []


jsonToEntry : Json.Value -> SearchResultEntry
jsonToEntry imageJson = {
        url = getStringPropOrElse "" "url" imageJson,
        width = getIntPropOrElse 0 "width" imageJson,
        height = getIntPropOrElse 0 "height" imageJson,
        thumbnailUrl = getStringPropOrElse "" "thumbnailUrl" imageJson,
        thumbnailWidth = getIntPropOrElse 0 "thumbnailWidth" imageJson,
        thumbnailHeight = getIntPropOrElse 0 "thumbnailHeight" imageJson
    }
