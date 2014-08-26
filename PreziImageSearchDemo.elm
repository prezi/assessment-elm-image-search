import PreziImageSearch

config : PreziImageSearch.Config
config =
    { width                = 300
    , googleCustomSearchId = ""
    , googleApiKey         = ""
    , googleTestResponse   = False
    }

main : Signal Element
main = PreziImageSearch.widget config




