module PreziImageSearch where

import PreziImageSearch.Config as Config
import PreziImageSearch.SearchEngine (..)
import PreziImageSearch.Widget as Widget

selectedImages : Signal SearchResultEntry
selectedImages = Widget.selectedImages

widget : Signal Config.Config -> Signal Element
widget config = Widget.widget config