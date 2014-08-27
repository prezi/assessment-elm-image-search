module PreziImageSearch.Css where

import Html ((:=), Attribute)

cssClass : String -> Attribute
cssClass shortCssClassName = "className" := ("prezi-img-search-" ++ shortCssClassName)

header = cssClass "header"
input = cssClass "input"
widget = cssClass "widget"
results = cssClass "results"
resultCol = cssClass "result-col"
resultEntry = cssClass "result-entry"
submit = cssClass "submit"