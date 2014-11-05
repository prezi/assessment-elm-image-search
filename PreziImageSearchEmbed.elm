module PreziImageSearchEmbed where

import Dict
import Json
import String

import PreziImageSearch
import PreziImageSearch.Config as Config
import PreziImageSearch.Config (..)
import PreziImageSearch.SearchEngine (SearchQuery, SearchResultEntry)

{- Input ports -}

port configIn : Signal PreConfig

port queries : Signal SearchQuery

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
            then Just (
                    Json.Object (
                        Dict.fromList [
                            strProp "url" entry.url,
                            intProp "width" entry.width,
                            intProp "height" entry.height,
                            strProp "thumbnailUrl" entry.thumbnailUrl,
                            intProp "thumbnailWidth"  entry.thumbnailWidth,
                            intProp "thumbnailHeight" entry.thumbnailHeight
                        ]
                    )
                )
            else Nothing

{- Config conversion -}

convertedConfigSignal = completePreconfig <~ configIn

{- Main -}

main : Signal Element
main = PreziImageSearch.widget convertedConfigSignal queries
