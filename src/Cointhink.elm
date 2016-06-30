port module Cointhink exposing (init, subscriptions, view, update)

import Platform.Cmd exposing (Cmd)
import Task

import Components

port output : () -> Cmd msg

view = Components.view

type alias Model = String

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case (Debug.log "MESSAGE" msg) of
        Init ->
            ( "init", output () )
        Ask ->
            ( model, output () )
        Get x ->
            ( "wtf", Cmd.none )

type Msg = Init | Ask | Get Int

port input : (Int -> msg) -> Sub msg

subscriptions : Model -> Sub Msg
subscriptions model =
     input Get

init : ( Model, Cmd Msg )
init =
    ( "",
      send Init )

send : Msg -> Cmd Msg
send msg =
  Task.perform identity identity (Task.succeed msg)


