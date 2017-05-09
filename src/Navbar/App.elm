port module Navbar.App exposing (app)

-- elm modules
import Platform.Cmd exposing (Cmd)
import Navigation
import Json.Decode
import Json.Encode

import Cointhink.Protocol exposing (WsResponse)
import Navbar.View exposing (view)
import Navbar.Msg exposing (..)

type alias Model = {
    ws_url: String
  }

type alias Flags = { ws : String }

port ws_send : Json.Encode.Value -> Cmd msg
port ws_recv : (WsResponse -> msg) -> Sub msg

msg_recv: WsResponse -> Msg
msg_recv response =
  let
    debug = Debug.log "navbar ws_resp" response
  in
    case response.method of
      "LoginResponse" -> Navbar.Msg.LoginResponse
      _ -> Navbar.Msg.Noop

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Noop ->
      ( model, Cmd.none )
    LoginResponse ->
      ( model, Cmd.none )

init : Flags -> Navigation.Location -> ( Model, Cmd Msg )
init flags location =
  let
    --debug_url = (Debug.log "init location" location.href)
    debug_flags = (Debug.log "Navbar init flags" flags)
  in
    ( Model flags.ws,
      Cmd.none )

fromUrl : Navigation.Location -> Msg
fromUrl url =
  let
    debug_url = (Debug.log "fromUrl" url)
  in
    Noop

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch [ ws_recv msg_recv ]

app = Navigation.programWithFlags
  fromUrl
  {
    init = init,
    view = view,
    update = update,
    subscriptions = subscriptions
  }
