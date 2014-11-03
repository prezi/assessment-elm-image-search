.PHONY: elm_dependencies

all: build/PreziImageSearchEmbed.js build/elm-runtime.js

build/elm-runtime.js:
	cp `elm --get-runtime` build/elm-runtime.js

build/PreziImageSearchEmbed.js: elm_dependencies
	elm --make\
		--only-js\
		--src-dir=PreziImageSearch\
		PreziImageSearchEmbed.elm

elm_dependencies:
	elm-get install
