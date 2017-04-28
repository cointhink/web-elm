port module Splash.App exposing (app)

import Platform.Cmd exposing (Cmd)
import String
import Navigation

import Splash.Msg exposing (Msg)
import Splash.Model exposing (Model)
import Splash.View exposing (view)

port ws_send : String -> Cmd msg

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case (Debug.log "splash update" msg) of
      Splash.Msg.SignupEmail email ->
        ( { model | email = email },
          Cmd.none )
      Splash.Msg.SignupDone ->
        ( model, ws_send (Debug.log "sending" "{}") )
      Splash.Msg.Noop ->
        ( model, Cmd.none )

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

type alias Flags = { }

init : Flags -> Navigation.Location -> ( Model, Cmd Msg )
init flags location =
  let
    debug_url = (Debug.log "init location" location.href)
    debug_flags = (Debug.log "init flags" flags)
  in
    ( Model "",
      Cmd.none )

fromUrl : Navigation.Location -> Msg
fromUrl url =
  let
    debug_url = (Debug.log "fromUrl" url)
  in
    Splash.Msg.Noop

app = Navigation.programWithFlags
        fromUrl
        {
          init = init,
          view = view,
          update = update,
          subscriptions = subscriptions
        }
