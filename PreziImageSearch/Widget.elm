module PreziImageSearch.Widget where

import Array
import Graphics.Input (Input)
import Graphics.Input as Input
import Html
import Html (eventNode, node, px, text, toElement, (:=), Attribute, Html)
import Html.Events (getValue, getKeyboardEvent, on, onclick, ondblclick, onkeydown, onkeyup, when)
import Http
import Maybe
import String
import Window

import PreziImageSearch.Css as Css
import PreziImageSearch.Config (Config)
import PreziImageSearch.Labels as Labels
import PreziImageSearch.SearchEngine (..)
import PreziImageSearch.TestSearchEngine as TestSearchEngine
import PreziImageSearch.GoogleSearchEngine as GoogleSearchEngine

{- API -}

widget : Signal Config -> Signal String -> Signal Element
widget config queries =
    scene
        <~ config
        ~ state
        ~ (searchResults config queries)
        ~ Window.dimensions

selectedImages : Signal SearchResultEntry
selectedImages =
    imageSelections.signal

{- Model -}

type State = {
        charCount : Int,
        searchText : String
    }

emptyState : State
emptyState = {
        charCount = 0,
        searchText = ""
    }


{- Actions -}

data Action
    = NoOp
    | UpdateSearchText String

step : Action -> State -> State
step action state =
    case action of
        NoOp -> state

        UpdateSearchText value ->
            { state |
                charCount <- String.length value,
                searchText <- value
            }

{- To be lifted -}

scene : Config -> State -> [SearchResult] -> (Int, Int) -> Element
scene config state results (w, h) =
    toElement
        config.width
        h
        (searchWidgetElement
            config
            (Labels.labels config.language)
            state
            results)

queryActions : Signal String -> Signal Action
queryActions queries = lift UpdateSearchText queries

searchQuery : State -> String
searchQuery state =
    state.searchText

{- Signals and inputs -}

actions : Input Action
actions =
    Input.input NoOp


submitButtonClicks : Input ()
submitButtonClicks =
    Input.input ()


inputEnterKeyDowns : Input ()
inputEnterKeyDowns =
    Input.input ()


imageSelections : Input SearchResultEntry
imageSelections =
    Input.input emptySearchResult


state : Signal State
state =
    foldp step emptyState actions.signal


searchSubmits : Signal State
searchSubmits =
    sampleOn
        (merge
            submitButtonClicks.signal
            inputEnterKeyDowns.signal)
        state


searchQueries : Signal SearchQuery
searchQueries = searchQuery <~ searchSubmits


searchResults : Signal Config -> Signal SearchQuery -> Signal [SearchResult]
searchResults config queries =
    combine [
            (GoogleSearchEngine.results config (merge searchQueries queries)),
            (TestSearchEngine.results (merge searchQueries queries))
        ]

{- UI -}

searchWidgetElement : Config -> Labels.Labels -> State -> [SearchResult] -> Html
searchWidgetElement config labels state results =
    if | config.controls -> node
           "div"
           [ Css.widget ]
           []
           [
               headerElement labels.searchTitle,
               searchInputElement,
               submitButtonElement labels.submit,
               searchResultsElement config results
           ]
       | otherwise -> node
           "div"
           [ Css.widget ]
           []
           [
               searchResultsElement config results
           ]


submitButtonElement : String -> Html
submitButtonElement label =
    eventNode
        "input"
        [
            Css.submit,
            "type" := "button",
            "value" := label
        ]
        []
        [ onclick submitButtonClicks.handle (always ()) ]
        []


headerElement : String -> Html
headerElement label =
    node
        "div"
        [ Css.header ]
        []
        [ text label ]


searchInputElement : Html
searchInputElement =
    eventNode
        "input"
        [ Css.input ]
        []
        [
            on
                "keydown"
                (when (\e -> e.keyCode == 13) getKeyboardEvent)
                inputEnterKeyDowns.handle
                (always ()),
            on
                "keyup"
                getValue
                actions.handle
                UpdateSearchText
        ]
        []


searchResultsElement : Config -> [SearchResult] -> Html
searchResultsElement config results =
    let flatResults = concat results
        flatResultsWithIdx = zip [1 .. length flatResults] flatResults
        (col1WithIdx, col2WithIdx) = partition (\(idx, e) -> idx % 2 == 1) flatResultsWithIdx
        colElems colWithIdx = map (\(idx, e) -> searchResultEntryElement config e) colWithIdx
        col colWithIdx = node "div" [ Css.resultCol ] [] (colElems colWithIdx)
    in
        node
            "div"
            [ Css.results ]
            []
            [
                col col1WithIdx,
                col col2WithIdx
            ]


searchResultEntryElement : Config -> SearchResultEntry -> Html
searchResultEntryElement config entry =
    let w = (toFloat (config.width - 4 * config.imagePadding)) / 2.0
        imgScale = w / (toFloat entry.thumbnailWidth)
    in
        node
            "div"
            [ Css.resultEntry ]
            []
            [
                eventNode "img"
                    [ "src" := entry.thumbnailUrl ]
                    [
                        "width" := px w,
                        "height" := px ((toFloat entry.thumbnailHeight) * imgScale)
                    ]
                    [ ondblclick imageSelections.handle (always entry) ]
                    []
            ]
