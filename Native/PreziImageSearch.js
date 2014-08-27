Elm.Native.PreziImageSearch = {};

Elm.Native.PreziImageSearch.make = function (elm) {
    elm.Native = elm.Native || {};
    elm.Native.PreziImageSearch = elm.Native.PreziImageSearch || {};
    
    return {
        encodeUri: encodeURI
    }
}