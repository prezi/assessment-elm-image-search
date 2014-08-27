module PreziImageSearch.SearchEngine where

type SearchQuery  = String
type SearchResult = [SearchResultEntry]
type SearchResultEntry =
    { url : String
    , thumbnailUrl : String
    }
type SearchEngine = Signal SearchResult

newSearchResultEntry : String -> String -> SearchResultEntry
newSearchResultEntry url thumbnailUrl =
    { url          = url
    , thumbnailUrl = thumbnailUrl
    }
