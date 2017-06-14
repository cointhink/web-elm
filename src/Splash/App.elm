port module Splash.App exposing (app)

import Platform.Cmd exposing (Cmd)
import String
import Navigation
import Json.Encode exposing (Value, encode, object, string)
import Json.Decode exposing (decodeValue)
import Splash.Msg as Msg exposing (..)
import Splash.Model exposing (..)
import Splash.View exposing (view)
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
            "SignupFormResponse" ->
                case decodeValue signupFormResponseDecoder response.object of
                    Ok formResponse ->
                        Msg.SignupResponse formResponse

                    Err reason ->
                        Noop

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

        Msg.ShowSignup ->
            ( { model | mode = ModeSignup }, Navigation.modifyUrl "#signup" )

        Msg.SignupEmail email ->
            let
                signup =
                    model.signup

                account =
                    Maybe.withDefault blankAccount signup.account
            in
                ( { model | signup = { signup | account = (Just { account | email = email }) } }
                , Cmd.none
                )

        Msg.SignupFullname fullname ->
            let
                signup =
                    model.signup

                account =
                    Maybe.withDefault blankAccount signup.account
            in
                ( { model | signup = { signup | account = (Just { account | fullname = fullname }) } }
                , Cmd.none
                )

        Msg.SignupNickname username ->
            let
                signup =
                    model.signup

                account =
                    Maybe.withDefault blankAccount signup.account
            in
                ( { model | signup = { signup | account = (Just { account | username = username }) } }
                , Cmd.none
                )

        Msg.SignupSend ->
            let
                signupFormEncoded =
                    signupFormEncoder model.signup

                ( uuid, seed ) =
                    idGen model.seed

                request =
                    (Debug.log "ws_send" (WsRequest uuid "SignupForm" signupFormEncoded))
            in
                ( { model | seed = seed, signup_req_id = uuid }, ws_send request )

        Msg.SignupResponse r ->
            ( { model | signup_req_id = "", signup_response = Just r }
            , case r.ok of
                True ->
                    let
                        sessionCreateEncoded =
                            sessionCreateEncoder (SessionCreate r.token)

                        ( uuid, seed ) =
                            idGen model.seed

                        request =
                            (Debug.log "ws_send" (WsRequest uuid "SessionCreate" sessionCreateEncoded))
                    in
                        ws_send request

                False ->
                    Cmd.none
            )

        Msg.SessionCreateResponseMsg response ->
            case response.ok of
                True ->
                    ( { model | account = response.account }, Navigation.load "/schedules" )

                False ->
                    ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ ws_recv msg_recv ]


type alias Flags =
    { seed : Int }


init : Flags -> Navigation.Location -> ( Model, Cmd Msg )
init flags location =
    let
        debug_flags =
            (Debug.log "Splash init flags" flags)

        debug_location =
            (Debug.log "Splash init location" location)

        mode =
            case location.hash of
                "#signup" ->
                    ModeSignup

                _ ->
                    ModeSplash
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
