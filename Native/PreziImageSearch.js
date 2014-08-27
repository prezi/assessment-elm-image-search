Elm.Native.PreziImageSearch = {};

Elm.Native.PreziImageSearch.make = function (elm) {
    elm.Native = elm.Native || {};
    elm.Native.PreziImageSearch = elm.Native.PreziImageSearch || {};
    
    if (elm.Native.PreziImageSearch.values) return elm.Native.PreziImageSearch.values;

    elm.Native.PreziImageSearch.values = {
        encodeUri: encodeURI
    }

    return elm.Native.PreziImageSearch.values;
}