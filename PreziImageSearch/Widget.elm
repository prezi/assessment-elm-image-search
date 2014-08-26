module PreziImageSearch.Widget where

import Graphics.Input (Input)
import Graphics.Input as Input
import Html
import Html (eventNode, node, text, toElement, (:=), Attribute, Html)
import Html.Events (getValue, on, onclick)
import Http
import Maybe
import Window

import PreziImageSearch.Css as Css
import PreziImageSearch.Labels as Labels

{- Model -}

type State =
    { charCount : Int
    , searchText : String
    }

emptyState : State
emptyState = 
    { charCount = 0
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

scene : State -> (Http.Response String) -> (Int, Int) -> Element
scene state httpResponse (w, h) = toElement 300 h (searchWidgetElement state httpResponse)

searchQuery : State -> String
searchQuery state =  ""  ++ state.searchText

{- Signals and inputs -}

actions : Input Action
actions = Input.input NoOp

submitButtonClicks : Input ()
submitButtonClicks = Input.input ()

state : Signal State
state = foldp step emptyState actions.signal

searchSubmits : Signal State 
searchSubmits = sampleOn submitButtonClicks.signal state

searchResponses : Signal (Http.Response String)
searchResponses = Http.sendGet (searchQuery <~ searchSubmits)

widget : Signal Element
widget = scene <~ state ~ searchResponses ~ Window.dimensions

{- UI -}

submitButtonElement : Html
submitButtonElement = eventNode "button"
                        []
                        []
                        [ onclick submitButtonClicks.handle (always ())]
                        [ text "Test" ]

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
                        [ on "keyup" (getValue) actions.handle UpdateSearchText ]
                        []

searchWidgetElement : State -> Http.Response String -> Html
searchWidgetElement state httpResponse = node "div"
                        [ Css.widget ]
                        [ "border" := "1px solid #FF00FF" ]
                        [ headerElement
                        , searchInputElement
                        , charCountElement state.charCount
                        , submitButtonElement
                        , searchResultElement httpResponse
                        ]

searchResultElement : Http.Response String -> Html
searchResultElement httpResponse = node "div"
                                    []
                                    []
                                    [ node "textarea"
                                        []
                                        []
                                        [ text (show httpResponse) ]
                                    ]




