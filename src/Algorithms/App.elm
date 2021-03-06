port module Algorithms.App exposing (app)

import Platform.Cmd exposing (Cmd)
import String
import Navigation
import Json.Encode exposing (Value, encode, object, string)
import Json.Decode exposing (decodeValue)
import Algorithms.Msg as Msg exposing (..)
import Algorithms.Model exposing (..)
import Algorithms.View exposing (view)
import Proto.Account exposing (..)
import Proto.Signup_form exposing (..)
import Proto.Signup_form_response exposing (..)
import Proto.Session_create exposing (..)
import Proto.Session_create_response exposing (..)
import Proto.Schedule_create exposing (..)
import Proto.Algorithm_list exposing (..)
import Proto.Algorithm_list_response exposing (..)
import Cointhink.Protocol exposing (..)
import Random.Pcg exposing (Seed, initialSeed, step)


port ws_send : WsRequest -> Cmd msg


port ws_recv : (WsResponse -> msg) -> Sub msg


msg_recv : WsResponse -> Msg
msg_recv response =
    let
        debug =
            Debug.log "algorithms ws_resp" response
    in
        case response.method of
            "Noop" ->
                Noop

            "SessionCreateResponse" ->
                case decodeValue sessionCreateResponseDecoder response.object of
                    Ok response ->
                        Msg.SessionCreateResponseMsg response

                    Err reason ->
                        Noop

            "AlgorithmListResponse" ->
                case decodeValue algorithmListResponseDecoder response.object of
                    Ok response ->
                        Msg.AlgorithmListResponseMsg response

                    Err reason ->
                        Noop

            _ ->
                Noop


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case (Debug.log "algorithms update" msg) of
        Msg.Noop ->
            ( model, Cmd.none )

        Msg.AppInit ->
            if model.mode == ModeList then
                let
                    algorithmListEncoded =
                        algorithmListEncoder (AlgorithmList "")

                    ( uuid, seed ) =
                        idGen model.seed

                    request =
                        (Debug.log "ws_send" (WsRequest uuid "AlgorithmList" algorithmListEncoded))
                in
                    ( { model | seed = seed }, ws_send request )
            else
                ( (Debug.log "appinit" model), Cmd.none )

        Msg.AlgorithmNewButton ->
            ( { model | mode = ModeAdd }, Navigation.modifyUrl "#add" )

        Msg.AlgorithmUpdate ->
            ( model, Cmd.none )

        Msg.SessionCreateResponseMsg response ->
            ( { model | account = response.account }, Cmd.none )

        Msg.AlgorithmListResponseMsg response ->
            ( { model | algorithms = response.algorithms }, Cmd.none )

        Msg.AlgorithmNew ->
            case model.scheduleCreate of
                Just scheduleCreate ->
                    let
                        signupFormEncoded =
                            scheduleCreateEncoder scheduleCreate

                        ( uuid, seed ) =
                            idGen model.seed

                        request =
                            (Debug.log "ws_send" (WsRequest uuid "SignupForm" signupFormEncoded))
                    in
                        ( { model | seed = seed }, ws_send request )

                Nothing ->
                    ( model, Cmd.none )

        Msg.ScheduleAddButton data ->
            let
                newUrl =
                    "/schedules?ex=" ++ (Debug.log "addbtn" data) ++ "#add"
            in
                ( model, Navigation.load newUrl )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ ws_recv msg_recv ]


type alias Flags =
    { seed : Int }


init : Flags -> Navigation.Location -> ( Model, Cmd Msg )
init flags location =
    let
        debug_flags =
            (Debug.log "Algorithms init flags" flags)

        debug_location =
            (Debug.log "Algorithms init location" location)

        mode =
            case location.hash of
                "#add" ->
                    ModeAdd

                _ ->
                    ModeList
    in
        update Msg.AppInit (defaultModel mode flags.seed)


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
