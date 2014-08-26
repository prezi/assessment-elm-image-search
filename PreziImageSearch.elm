module PreziImageSearch where

import PreziImageSearch.Config as Config
import PreziImageSearch.Widget as Widget

widget : Config.Config -> Signal Element
widget config = Widget.widget config