port module Navbar.App exposing (app)

-- elm modules
import Platform.Cmd exposing (Cmd)
import Navigation

import Cointhink.Protocol exposing (ws_subscription, WsResponse)
import Cointhink.Shared exposing (Msg)
import Navbar.View exposing (view)

type alias Model = {
    ws_url: String
  }

type alias Flags = { ws : String }

type Msg = Alert String | Noop

port ws_send : (String -> msg) -> Sub msg
do_send: String -> Msg
do_send string =
  let
    debug_param = Debug.log "do_send" string
  in
    Noop

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
      Alert s ->
        ( model, Cmd.none )
      Noop ->
        ( model, Cmd.none )

init : Flags -> Navigation.Location -> ( Model, Cmd Msg )
init flags location =
  let
    debug_url = (Debug.log "init location" location.href)
    debug_flags = (Debug.log "init flags" flags)
  in
    ( { ws_url = "bob" },
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
              ws_send do_send ]

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
