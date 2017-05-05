port module Splash.App exposing (app)

import Platform.Cmd exposing (Cmd)
import String
import Navigation
import Json.Encode exposing (Value, encode, object, string)
import Json.Decode

import Splash.Msg exposing (..)
import Splash.Model exposing (Model)
import Splash.View exposing (view)
import Signup_form exposing (..)
import Signup_form_response exposing (..)
import Cointhink.Protocol exposing (..)

import Random.Pcg exposing (Seed, initialSeed, step)

port ws_send : WsRequest -> Cmd msg
port ws_recv : (WsResponse -> msg) -> Sub msg

msg_recv: WsResponse -> Msg
msg_recv response =
  let
    debug = Debug.log "ws_resp" response
  in
    case response.method of
      "SignupFormResponse" -> Splash.Msg.SignupResponse
      _ -> Splash.Msg.Noop

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case (Debug.log "splash update" msg) of
      Splash.Msg.ShowSignup ->
        ( { model | mode = ModeSignup }, Navigation.modifyUrl "#signup" )
      Splash.Msg.SignupResponse ->
        ( model, Cmd.none)
      Splash.Msg.SignupEmail email ->
        let
          signupfrm = model.signup
          better = { signupfrm | email = email }
        in
        ( { model | signup = better },
          Cmd.none )
      Splash.Msg.SignupFullname fullname ->
        ( model, Cmd.none)
      Splash.Msg.SignupNickname nickname ->
        ( model, Cmd.none)
      Splash.Msg.SignupSend ->
        let
          signupFormEncoded = signupFormEncoder model.signup
          (uuid, seed) = idGen model.seed
          request = (Debug.log "ws_send" (WsRequest uuid "SignupForm" signupFormEncoded))
        in
        ( { model | seed = seed, signup_req_id = uuid }, ws_send request )
      Splash.Msg.Noop ->
        ( model, Cmd.none )

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch [ ws_recv msg_recv ]

type alias Flags = { seed: Int }

init : Flags -> Navigation.Location -> ( Model, Cmd Msg )
init flags location =
  let
    debug_flags = (Debug.log "Splash init flags" flags)
    debug_location = (Debug.log "Splash init location" location)
    mode =
      case location.hash of
        "#signup" -> ModeSignup
        _ -> ModeSplash
  in
    ( Model (Random.Pcg.initialSeed flags.seed) mode (SignupForm "" "" "") "" (SignupFormResponse False) "",
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
