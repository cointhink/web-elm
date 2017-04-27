all: build

npm: ./node_modules/.bin/elm
	npm install
	./node_modules/.bin/elm-package install

build: src/*.elm
	./node_modules/.bin/elm-make src/Navbar.elm src/Splash.elm src/Markets.elm --output=public/js/elm.js
