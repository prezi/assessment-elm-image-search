.PHONY: elm_dependencies standalone

all: build/PreziImageSearchEmbed.js build/elm-runtime.js

clean:
	rm build/*

standalone: build/PreziImageSearchBundle.js

build/elm-runtime.js:
	cp `elm --get-runtime` build/elm-runtime.js

build/PreziImageSearchEmbed.js: elm_dependencies
	elm --make\
		--only-js\
		--src-dir=PreziImageSearch\
		PreziImageSearchEmbed.elm

build/PreziImageSearchBundle.js: elm_dependencies
	cat `elm --get-runtime` Native/PreziImageSearch.js > \
		build/enriched-runtime.js
	echo ";\n" >> build/enriched-runtime.js
	elm --make\
		--only-js\
		--src-dir=PreziImageSearch\
		--set-runtime=build/enriched-runtime.js\
		--bundle-runtime\
		PreziImageSearchEmbed.elm

elm_dependencies:
	elm-get install
