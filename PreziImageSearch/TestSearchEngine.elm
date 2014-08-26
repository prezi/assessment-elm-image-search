module PreziImageSearch.TestSearchEngine where

import Http
import PreziImageSearch.SearchEngine (..)

results : Signal SearchQuery -> Signal SearchResult
results queries = httpResponseToResult <~ Http.sendGet (queryToTestFileName <~ queries)

queryToTestFileName : SearchQuery -> String
queryToTestFileName query = if String.isEmpty query then "" else ("test_data/" ++ query ++ ".json")

httpResponseToResult : Http.Response String -> SearchResult
httpResponseToResult httpResponse = show httpResponse