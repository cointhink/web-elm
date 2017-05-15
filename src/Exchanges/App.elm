port module Exchanges.App exposing (app)

import Platform.Cmd exposing (Cmd)
import String
import Navigation
import Json.Encode exposing (Value, encode, object, string)
import Json.Decode exposing (decodeValue)
import Exchanges.Msg as Msg exposing (..)
import Exchanges.Model exposing (..)
import Exchanges.View exposing (view)
import Proto.Account exposing (..)
import Proto.Signup_form exposing (..)
import Proto.Signup_form_response exposing (..)
import Proto.Session_create exposing (..)
import Proto.Session_create_response exposing (..)
import Cointhink.Protocol exposing (..)
import Random.Pcg exposing (Seed, initialSeed, step)


port ws_send : WsRequest -> Cmd msg


port ws_recv : (WsResponse -> msg) -> Sub msg


msg_recv : WsResponse -> Msg
msg_recv response =
    let
        debug =
            Debug.log "splash ws_resp" response
    in
        case response.method of
            "SessionCreateResponse" ->
                case decodeValue sessionCreateResponseDecoder response.object of
                    Ok response ->
                        Msg.SessionCreateResponseMsg response

                    Err reason ->
                        Noop

            _ ->
                Noop


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case (Debug.log "splash update" msg) of
        Msg.Noop ->
            ( model, Cmd.none )

        Msg.ExchangeSend ->
            ( model, Cmd.none )

        Msg.ExchangeNew ->
            ( { model | mode = Msg.ModeAdd }, Cmd.none )

        Msg.ExchangeNewApiKey apiKey ->
            ( model, Cmd.none )

        Msg.SessionCreateResponseMsg response ->
            ( { model | account = response.account }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ ws_recv msg_recv ]


type alias Flags =
    { seed : Int }


init : Flags -> Navigation.Location -> ( Model, Cmd Msg )
init flags location =
    let
        debug_flags =
            (Debug.log "Exchanges init flags" flags)

        debug_location =
            (Debug.log "Exchanges init location" location)

        mode =
            case location.hash of
                "#add" ->
                    ModeAdd

                _ ->
                    ModeList
    in
        ( defaultModel mode flags.seed, Cmd.none )


fromUrl : Navigation.Location -> Msg
fromUrl url =
    let
        debug_url =
            (Debug.log "fromUrl" url)
    in
        Msg.Noop


app =
    Navigation.programWithFlags
        fromUrl
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
