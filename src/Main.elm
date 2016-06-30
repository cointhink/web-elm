port module Main exposing (..)

import Html.App exposing (program)
import Debug exposing (log)

import Cointhink exposing (..)


main = program {
          init = log "init" init,
          view = view,
          update = update,
          subscriptions = subscriptions
        }

