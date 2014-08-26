module  PreziImageSearch.GoogleSearchEngine where

import Debug (log)
import Http
import PreziImageSearch.SearchEngine (..)

results : String -> String -> Signal SearchQuery -> Signal SearchResult
results customSearchId apiKey queries = httpResponseToResult <~ Http.send ((queryToGet customSearchId apiKey) <~ queries)

queryToGet : String -> String -> SearchQuery -> (Http.Request String)
queryToGet customSearchId apiKey query = if String.isEmpty query
                                            then (Http.request "" "" "" [])
                                            else (Http.request "GET"
                                                    ( addGetParamters baseUrl 
                                                      [ ("cx", customSearchId)
                                                      , ("key", apiKey)
                                                      , ("q", query)
                                                      ]
                                                    )
                                                    "" [])

baseUrl = "https://www.googleapis.com/customsearch/v1"

addGetParamters : String -> [(String, String)] -> String
addGetParamters baseUrl parameters =
    baseUrl ++ "?" ++ (join "&" <| map (\(k, v) -> encode(k) ++ "=" ++ encode(v)) parameters)

encode : String -> String
encode s = s

httpResponseToResult : Http.Response String -> SearchResult
httpResponseToResult httpResponse = show httpResponse