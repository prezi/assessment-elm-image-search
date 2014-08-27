module PreziImageSearch.Css where

import Html ((:=), Attribute)

cssClass : String -> Attribute
cssClass shortCssClassName = "className" := ("prezi-img-search-" ++ shortCssClassName)

header      = cssClass "header"
input       = cssClass "input"
resultCol   = cssClass "result-col"
resultEntry = cssClass "result-entry"
results     = cssClass "results"
submit      = cssClass "submit"
widget      = cssClass "widget"