port module Main exposing (..)

import String

import Navigation

import Cointhink exposing (..)

main = Navigation.programWithFlags
        fromUrl
        {
          init = init,
          view = view,
          update = update,
          subscriptions = subscriptions
        }
