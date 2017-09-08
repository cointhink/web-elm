port module Navbar.App exposing (app)

import Platform.Cmd exposing (Cmd)
import Navigation
import Json.Encode
import Json.Decode exposing (decodeValue, decodeString)
import Cointhink.Protocol exposing (..)
import Navbar.View exposing (view)
import Navbar.Msg as Msg exposing (..)
import Navbar.Model exposing (..)
import Proto.Session_create exposing (..)
import Proto.Session_create_response exposing (..)
import Proto.Signup_form_response exposing (..)
import Proto.Signin_email exposing (..)
import Proto.Signin_email_response exposing (..)
import Proto.Account exposing (..)
import Random.Pcg exposing (Seed, initialSeed, step)


type alias StoreItemRecord =
    { item : String, value : String }


type alias RemoveItemRecord =
    { item : String }


port ws_send : WsRequest -> Cmd msg


port store_item : StoreItemRecord -> Cmd msg


port remove_item : RemoveItemRecord -> Cmd msg


port ws_recv : (WsResponse -> msg) -> Sub msg


store_token : String -> Cmd msg
store_token token =
    store_item (StoreItemRecord "token" token)


clear_token : Cmd msg
clear_token =
    remove_item (RemoveItemRecord "token")


msg_recv : WsResponse -> Msg
msg_recv response =
    let
        debug =
            Debug.log "navbar ws_resp" response
    in
        case response.method of
            "SignupFormResponse" ->
                case decodeValue signupFormResponseDecoder response.object of
                    Ok formResponse ->
                        Msg.TokenReceived formResponse.token

                    Err reason ->
                        Noop

            "SessionCreateResponse" ->
                case decodeValue sessionCreateResponseDecoder response.object of
                    Ok response ->
                        Msg.SessionCreateResponseMsg response

                    Err reason ->
                        Noop

            "SigninEmailResponse" ->
                case decodeValue signinEmailResponseDecoder response.object of
                    Ok response ->
                        Msg.SigninEmailResponseMsg response

                    Err reason ->
                        Noop

            "WebsocketFail" ->
                case decodeValue Json.Decode.string response.object of
                    Ok msg ->
                        Msg.WebsocketFail msg

                    Err reason ->
                        Noop

            _ ->
                Msg.Noop


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Msg.Noop ->
            ( model, Cmd.none )

        Msg.WebsocketFail msg ->
            ( { model | netFail = Just msg }, Cmd.none )

        Msg.SigninEmailResponseMsg signinEmailResponse ->
            ( { model | signinEmailMessage = signinEmailResponse.message }, Cmd.none )

        Msg.SigninEmailChg email ->
            let
                signinEmail =
                    model.signinEmail
            in
                ( { model | signinEmail = { signinEmail | email = email } }, Cmd.none )

        Msg.SigninEmailDone ->
            let
                signinEmailEncoded =
                    signinEmailEncoder model.signinEmail

                ( uuid, seed ) =
                    idGen model.seed

                request =
                    (Debug.log "ws_send" (WsRequest uuid "SigninEmail" signinEmailEncoded))
            in
                ( { model | seed = seed }, ws_send request )

        Msg.SessionCreateResponseMsg response ->
            case response.ok of
                False ->
                    ( { model | hasToken = False }, Cmd.none )

                True ->
                    ( { model | account = response.account }, Cmd.none )

        Msg.TokenReceived token ->
            ( (Debug.log "navbar token received. storing." model), store_token token )

        Msg.LogoutButton ->
            ( { model | account = Nothing, hasToken = False }, Cmd.batch [ clear_token, Navigation.load "/" ] )

        Msg.UsercardMenu ->
            ( { model
                | showUsercardMenu =
                    (if model.showUsercardMenu then
                        False
                     else
                        True
                    )
              }
            , Cmd.none
            )


type alias Flags =
    { seed : Int
    , ws : String
    , token : Maybe String
    }


init : Flags -> Navigation.Location -> ( Model, Cmd Msg )
init flags location =
    let
        --debug_url = (Debug.log "init location" location.href)
        debug_flags =
            (Debug.log "Navbar init flags" flags)

        hasToken =
            case flags.token of
                Just token ->
                    True

                Nothing ->
                    False

        ( uuid, seed ) =
            idGen (initialSeed flags.seed)

        newCmd =
            case flags.token of
                Just token ->
                    let
                        sessionCreateEncoded =
                            sessionCreateEncoder (SessionCreate token)

                        request =
                            (Debug.log "ws_send" (WsRequest uuid "SessionCreate" sessionCreateEncoded))
                    in
                        ws_send request

                Nothing ->
                    Cmd.none
    in
        ( defaultModel flags.ws hasToken seed, newCmd )


fromUrl : Navigation.Location -> Msg
fromUrl url =
    let
        debug_url =
            (Debug.log "fromUrl" url)
    in
        Noop


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ ws_recv msg_recv ]


app =
    Navigation.programWithFlags
        fromUrl
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
