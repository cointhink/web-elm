port module Main exposing (..)

import Html exposing (..)
import Html.App exposing (program)
import Platform.Cmd exposing (Cmd)
import Task exposing (..)

import Cointhink exposing (..)

type alias Model = String

type Msg = Ask | Get Int

port input : (Int -> msg) -> Sub msg

subscriptions : Model -> Sub Msg
subscriptions model =
     input Get

init : ( Model, Cmd Msg )
init =
    ( "", send Ask )

send : msg -> Cmd msg
send msg =
  Task.perform identity identity (Task.succeed msg)

main = program { init = init, view = view, update = update, subscriptions = subscriptions}
