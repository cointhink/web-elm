all: build

npm: ./node_modules/.bin/elm
	npm install
	./node_modules/.bin/elm-package install

build: src/*.elm
	./node_modules/.bin/elm-make $^ --output=public/js/elm.js

watch:
	while true; do inotifywait -r src -e MODIFY; make build; done
