module PreziImageSearch where

import PreziImageSearch.Config
import PreziImageSearch.Widget

type Config = PreziImageSearch.Config.Config

widget : Config -> Signal Element
widget config = PreziImageSearch.Widget.widget config