port module Main exposing (..)

import Debug
import Navigation
import String

import Cointhink exposing (..)


main = Navigation.programWithFlags urlParser {
          init = init,
          view = view,
          update = update,
          urlUpdate = urlUpdate,
          subscriptions = subscriptions
        }

fromUrl : String -> Result String Int
fromUrl url =
  String.toInt (String.dropLeft 2 (Debug.log "fromUrl" url))

urlParser : Navigation.Parser (Result String Int)
urlParser =
  Navigation.makeParser (fromUrl << .hash)
