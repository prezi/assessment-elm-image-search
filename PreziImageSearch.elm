module PreziImageSearch where

import PreziImageSearch.Widget

type Config = PreziImageSearch.Widget.Config

widget : Config -> Signal Element
widget config = PreziImageSearch.Widget.widget config