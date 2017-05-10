all: build

npm: ./node_modules/.bin/elm
	npm install
	./node_modules/.bin/elm-package install

build: build-navbar build-splash build-dashboard

build-navbar:
	./node_modules/.bin/elm-make src/Navbar.elm --output=public/js/elm-navbar.js

build-splash:
	./node_modules/.bin/elm-make src/Splash.elm --output=public/js/elm-splash.js

build-dashboard:
	./node_modules/.bin/elm-make src/Dashboard.elm --output=public/js/elm-dashboard.js

watch:
	while true; do inotifywait -r src -e MODIFY; make build; done
