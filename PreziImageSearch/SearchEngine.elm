module PreziImageSearch.SearchEngine where

type SearchQuery = String

type SearchResult = [SearchResultEntry]

type SearchEngine = Signal SearchResult

type SearchResultEntry = {
        url : String,
        width : Int,
        height : Int,
        thumbnailUrl : String,
        thumbnailWidth : Int,
        thumbnailHeight : Int
    }


emptySearchResult = {
        url = "",
        width = 0,
        height = 0,
        thumbnailUrl = "",
        thumbnailWidth = 0,
        thumbnailHeight = 0
    }

