port module Splash.App exposing (app)

import Platform.Cmd exposing (Cmd)
import String
import Navigation

import Splash.Msg exposing (Msg)
import Splash.Model exposing (Model)
import Splash.View exposing (view)
import Signup_form exposing (..)
import Json.Encode exposing (Value, encode, object, string)
import Json.Decode
import Cointhink.Protocol exposing (WsResponse)

port ws_send : Json.Encode.Value -> Cmd msg
port ws_recv : (WsResponse -> msg) -> Sub msg

msg_recv: WsResponse -> Msg
msg_recv response =
  let
    debug = Debug.log "wsresp" WsResponse
  in
    Splash.Msg.Noop

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case (Debug.log "splash update" msg) of
      Splash.Msg.SignupEmail email ->
        let
          signupfrm = model.signup
          better = { signupfrm | email = email }
        in
        ( { model | signup = better },
          Cmd.none )
      Splash.Msg.SignupDone ->
        ( model, ws_send (Debug.log "update-sending" (signupFormEncoder model.signup)) )
      Splash.Msg.Noop ->
        ( model, Cmd.none )

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch [ ws_recv msg_recv ]

type alias Flags = { }

init : Flags -> Navigation.Location -> ( Model, Cmd Msg )
init flags location =
  let
    debug_flags = (Debug.log "Splash init flags" flags)
  in
    ( Model "" (SignupForm "" "" ""),
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
