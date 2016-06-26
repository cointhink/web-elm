all: build

npm: ./node_modules/.bin/elm
	npm install
	./node_modules/.bin/elm-package install

build: hello.elm
	./node_modules/.bin/elm-make hello.elm --output=public/index.html
