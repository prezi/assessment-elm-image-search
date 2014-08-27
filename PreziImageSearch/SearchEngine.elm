module PreziImageSearch.SearchEngine where

type SearchQuery  = String
type SearchResult = [SearchResultEntry]
type SearchResultEntry =
    { url             : String
    , width           : Int
    , height          : Int
    , thumbnailUrl    : String
    , thumbnailWidth  : Int
    , thumbnailHeight : Int
    }
type SearchEngine = Signal SearchResult

