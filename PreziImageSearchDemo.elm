module PreziImageSearchDemo where

import PreziImageSearch
import PreziImageSearch.Config as Config
import PreziImageSearch.Config (..)

config : Config.Config
config = { 
        width = 300,
        imagePadding = 3,
        googleCustomSearchId = "",
        googleApiKey  = "",
        googleTestResponse = False,
        language = Config.Hun
    }

main : Signal Element
main = PreziImageSearch.widget (constant config)
