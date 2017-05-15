all: build

npm: ./node_modules/.bin/elm
	npm install
	./node_modules/.bin/elm-package install

build: src/*elm
	for elmFile in $^ ; do \
	  elmWord=`basename $$elmFile .elm`; \
	  ./node_modules/.bin/elm-make $$elmFile --output=public/js/elm-$$elmWord.js; \
	done

watch:
	while true; do inotifywait -r src -e MODIFY; make build; done
