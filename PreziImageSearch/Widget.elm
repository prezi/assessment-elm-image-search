module PreziImageSearch.Widget where

import Graphics.Input (Input)
import Graphics.Input as Input
import Html
import Html (eventNode, node, px, text, toElement, (:=), Attribute, Html)
import Html.Events (getValue, getKeyboardEvent, on, onclick, onkeydown, onkeyup, when)
import Http
import Maybe
import Window

import PreziImageSearch.Css as Css
import PreziImageSearch.Config (Config)
import PreziImageSearch.Labels as Labels
import PreziImageSearch.SearchEngine (..)
import PreziImageSearch.TestSearchEngine as TestSearchEnigne
-- import PreziImageSearch.GoogleSearchEngine as GoogleSearchEnigne

{- API -}

widget : Config -> Signal Element
widget config = scene config <~ state ~ searchResults config ~ Window.dimensions

{- "Const" -}

enterKeyCode = 13

{- Model -}

type State =
    { charCount  : Int
    , searchText : String
    }

emptyState : State
emptyState = 
    { charCount  = 0
    , searchText = ""
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
            { state | charCount <- String.length value
                    , searchText <- value
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

searchQuery : State -> String
searchQuery state =  state.searchText

{- Signals and inputs -}

actions : Input Action
actions = Input.input NoOp

submitButtonClicks : Input ()
submitButtonClicks = Input.input ()

inputEnterKeyDowns : Input ()
inputEnterKeyDowns = Input.input ()


state : Signal State
state = foldp step emptyState actions.signal

searchSubmits : Signal State 
searchSubmits = 
    sampleOn
        (merge
            submitButtonClicks.signal
            inputEnterKeyDowns.signal)
        state

searchQueries : Signal SearchQuery
searchQueries = searchQuery <~ searchSubmits

searchResults : Config -> Signal [SearchResult]
searchResults config = 
    combine
        [ (TestSearchEnigne.results searchQueries)
        , (TestSearchEnigne.results searchQueries)
        ]
-- searchResults config = GoogleSearchEnigne.results config searchQueries


{- UI -}

searchWidgetElement : Config -> Labels.Labels -> State -> [SearchResult] -> Html
searchWidgetElement config labels state results =
        node "div"
            [ Css.widget ]
            []
            [ headerElement labels.searchTitle
            , searchInputElement
            , submitButtonElement labels.submit
            , searchResultsElement config results
            ]

submitButtonElement : String -> Html
submitButtonElement label = 
    eventNode "input"
        [ Css.submit
        , "type" := "button"
        , "value" := label
        ]
        []
        [ onclick submitButtonClicks.handle (always ()) ]
        []

headerElement : String -> Html
headerElement label = 
    node "div"
        [ Css.header ]
        []
        [ text label ]

searchInputElement : Html
searchInputElement = 
    eventNode "input"
        [ Css.input ]
        []
        [ on "keydown" (when (\e -> e.keyCode == 13) getKeyboardEvent) inputEnterKeyDowns.handle (always ())
        , on "keyup" (getValue) actions.handle UpdateSearchText
        ]
        []

searchResultsElement : Config -> [SearchResult] -> Html
searchResultsElement config results =
    node "div"
        [ Css.results ]
        []
        (concatMap (\r -> map (searchResultEntryElement config) r) results)

searchResultEntryElement : Config -> SearchResultEntry -> Html
searchResultEntryElement config entry =
    let
        w = (toFloat (config.width - 4 * config.imagePadding)) / 2.0
        imgScale = w / (toFloat entry.thumbnailWidth)
    in
        node "div"
            [ Css.resultEntry ]
            []
            [ node "img"
                [ "src"    := entry.thumbnailUrl
                ]
                [ "width"  := px w
                , "height" := px ((toFloat entry.thumbnailHeight) * imgScale)
                ]
                []
            ]
