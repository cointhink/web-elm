port module Splash.App exposing (app)

import Platform.Cmd exposing (Cmd)
import String
import Navigation

import Splash.View
view = Splash.View.view

type alias Model = {
  }
type Msg = Noop

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
      Noop ->
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
    ( {  },
      Cmd.none )

fromUrl : Navigation.Location -> Msg
fromUrl url =
  let
    debug_url = (Debug.log "fromUrl" url)
  in
    Noop

app = Navigation.programWithFlags
        fromUrl
        {
          init = init,
          view = view,
          update = update,
          subscriptions = subscriptions
        }
