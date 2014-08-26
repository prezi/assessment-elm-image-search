module PreziImageSearch.Widget where

import Graphics.Input (Input)
import Graphics.Input as Input
import Html
import Html (eventNode, node, text, toElement, (:=), Attribute, Html)
import Html.Events (getValue, getKeyboardEvent, on, onclick, onkeydown, onkeyup, when)
import Http
import Maybe
import Window

import PreziImageSearch.Css as Css
import PreziImageSearch.Config (Config)
import PreziImageSearch.Labels as Labels
import PreziImageSearch.SearchEngine (..)
import PreziImageSearch.TestSearchEngine as TestSearchEnigne
import PreziImageSearch.GoogleSearchEngine as GoogleSearchEnigne

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

scene : Config -> State -> SearchResult -> (Int, Int) -> Element
scene config state searchResult (w, h) = toElement config.width h (searchWidgetElement state searchResult)

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
searchSubmits = sampleOn
                    (merge
                        submitButtonClicks.signal
                        inputEnterKeyDowns.signal)
                    state

searchQueries : Signal SearchQuery
searchQueries = searchQuery <~ searchSubmits

searchResults : Config -> Signal SearchResult
searchResults config = GoogleSearchEnigne.results config searchQueries

{- UI -}

submitButtonElement : Html
submitButtonElement = eventNode "input"
                        [ Css.submit
                        , "type" := "button"
                        , "value" := Labels.submit
                        ]
                        []
                        [ onclick submitButtonClicks.handle (always ()) ]
                        []

charCountElement : Int -> Html
charCountElement cnt = node "div"
                    []
                    []
                    [ text (show cnt) ]

headerElement : Html
headerElement = node "div"
                    [ Css.header ]
                    []
                    [ text Labels.searchTitle ]

searchInputElement : Html
searchInputElement = eventNode "input"
                        [ Css.input ]
                        []
                        [ on "keydown" (when (\e -> e.keyCode == 13) getKeyboardEvent) inputEnterKeyDowns.handle (always ())
                        , on "keyup" (getValue) actions.handle UpdateSearchText
                        ]
                        []

searchWidgetElement : State -> SearchResult -> Html
searchWidgetElement state searchResult = node "div"
                        [ Css.widget ]
                        [ "border" := "1px solid #FF00FF" ]
                        [ headerElement
                        , searchInputElement
                        , charCountElement state.charCount
                        , submitButtonElement
                        , searchResultElement searchResult
                        ]

searchResultElement : SearchResult -> Html
searchResultElement searchResult = node "div"
                                    []
                                    []
                                    [ node "textarea"
                                        []
                                        []
                                        [ text (show searchResult) ]
                                    ]




