module PreziImageSearch.Labels where

import PreziImageSearch.Config as Config

type Labels = {
        title : String,
        searchTitle : String,
        submit : String
    }


labels : Config.Language -> Labels
labels lang =
    case lang of
        Config.Hun -> hunLabels
        Config.Eng -> engLabels


engLabels : Labels
engLabels = {
        title = "Insert image",
        searchTitle = "Search images on the web",
        submit = "Search"
    }


hunLabels : Labels
hunLabels = {
        title = "Kép beillesztése",
        searchTitle = "Kép keresése az interneten",
        submit = "Keres"
    }
