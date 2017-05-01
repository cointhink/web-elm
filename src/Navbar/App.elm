port module Navbar.App exposing (app)

-- elm modules
import Platform.Cmd exposing (Cmd)
import Navigation

import Cointhink.Protocol exposing (ws_subscription, WsResponse, wsSend)
import Cointhink.Shared exposing (Msg)
import Navbar.View exposing (view)

type alias Model = {
    ws_url: String
  }

type alias Flags = { ws : String }

type Msg = Alert String | Noop | SendOut String

port ws_send : (String -> msg) -> Sub msg

msg_send: String -> Msg
msg_send string = SendOut string

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
      SendOut string ->
        ( model, wsSend model.ws_url string )
      Alert s ->
        ( model, Cmd.none )
      Noop ->
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
  Sub.batch [ ws_subscription dispatch model.ws_url,
              ws_send msg_send ]

dispatch : WsResponse -> Msg
dispatch wsresponse =
  case wsresponse.rtype of
    _ -> Noop

app = Navigation.programWithFlags
        fromUrl
        {
          init = init,
          view = view,
          update = update,
          subscriptions = subscriptions
        }
