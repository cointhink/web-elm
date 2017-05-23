port module Schedules.App exposing (app)

import Platform.Cmd exposing (Cmd)
import String
import Navigation
import Json.Encode exposing (Value, encode, object, string)
import Json.Decode exposing (decodeValue)
import Schedules.Msg as Msg exposing (..)
import Schedules.Model exposing (..)
import Schedules.View exposing (view)
import Proto.Account exposing (..)
import Proto.Signup_form exposing (..)
import Proto.Signup_form_response exposing (..)
import Proto.Session_create exposing (..)
import Proto.Session_create_response exposing (..)
import Proto.Schedule_create exposing (..)
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

        Msg.ScheduleAdd ->
            ( { model | mode = ModeAdd }, Navigation.modifyUrl "#add" )

        Msg.ScheduleNewAlgorithm value ->
            let
                item =
                    model.schedule
            in
                ( { model | schedule = { item | algorithmId = value } }, Cmd.none )

        Msg.ScheduleNewExchange value ->
            ( model, Cmd.none )

        Msg.ScheduleUpdate ->
            ( model, Cmd.none )

        Msg.SessionCreateResponseMsg response ->
            ( { model | account = response.account }, Cmd.none )

        Msg.ScheduleNew ->
            let
                item =
                    ScheduleCreate "" (Just model.schedule)

                itemEncoded =
                    scheduleCreateEncoder item

                ( uuid, seed ) =
                    idGen model.seed

                request =
                    (Debug.log "ws_send" (WsRequest uuid "ScheduleCreate" itemEncoded))
            in
                ( { model | seed = seed }, ws_send request )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ ws_recv msg_recv ]


type alias Flags =
    { seed : Int }


init : Flags -> Navigation.Location -> ( Model, Cmd Msg )
init flags location =
    let
        debug_flags =
            (Debug.log "Schedules init flags" flags)

        debug_location =
            (Debug.log "Schedules init location" location)

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
