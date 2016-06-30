port module Main exposing (..)

import Html.App
import Debug

import Cointhink exposing (..)


main = Html.App.programWithFlags {
          init = Debug.log "init" init,
          view = view,
          update = update,
          subscriptions = subscriptions
        }

