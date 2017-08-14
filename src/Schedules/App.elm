port module Schedules.App exposing (app)

import Platform.Cmd exposing (Cmd)
import String
import Navigation
import Json.Encode exposing (Value, encode, object, string)
import Json.Decode exposing (decodeValue)
import Schedules.Msg as Msg exposing (..)
import Schedules.Model exposing (..)
import Schedules.View exposing (view)
import Proto.Algolog exposing (..)
import Proto.Algolog_list exposing (..)
import Proto.Account exposing (..)
import Proto.Signup_form exposing (..)
import Proto.Signup_form_response exposing (..)
import Proto.Session_create exposing (..)
import Proto.Session_create_response exposing (..)
import Proto.Schedule_create exposing (..)
import Proto.Schedule_create_response exposing (..)
import Proto.Schedule_list exposing (..)
import Proto.Schedule_list_partial exposing (..)
import Proto.Schedule_list_response exposing (..)
import Proto.Schedule_start exposing (..)
import Proto.Schedule_stop exposing (..)
import Proto.Schedule_delete exposing (..)
import Proto.Schedule_run exposing (..)
import Proto.Schedule exposing (..)
import Cointhink.Protocol exposing (..)
import Random.Pcg exposing (Seed, initialSeed, step)


port ws_send : WsRequest -> Cmd msg


port ws_recv : (WsResponse -> msg) -> Sub msg


msg_recv : WsResponse -> Msg
msg_recv response =
    let
        debug =
            Debug.log "schedules ws_resp" response
    in
        case response.method of
            "SessionCreateResponse" ->
                wsDecode
                    sessionCreateResponseDecoder
                    response.object
                    Msg.SessionCreateResponseMsg
                    Noop

            "ScheduleCreateResponse" ->
                wsDecode
                    scheduleCreateResponseDecoder
                    response.object
                    Msg.ScheduleCreateResponseMsg
                    Noop

            "ScheduleListResponse" ->
                wsDecode
                    scheduleListResponseDecoder
                    response.object
                    Msg.ScheduleListResponseMsg
                    Noop

            "ScheduleListPartial" ->
                wsDecode
                    scheduleListPartialDecoder
                    response.object
                    Msg.ScheduleListPartialMsg
                    Noop

            "Algolog" ->
                wsDecode
                    algologDecoder
                    response.object
                    Msg.AlgologMsg
                    Noop

            _ ->
                (Debug.log "Unknown ws_resp method" Noop)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case (Debug.log "schedules update" msg) of
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

        Msg.ScheduleSelectExchange value ->
            let
                state =
                    model.schedule_state
            in
                ( { model | schedule_state = { state | exchange = value } }, Cmd.none )

        Msg.ScheduleSelectMarket value ->
            let
                state =
                    model.schedule_state
            in
                ( { model | schedule_state = { state | market = value } }, Cmd.none )

        Msg.ScheduleSelectAmount value ->
            let
                state =
                    model.schedule_state
            in
                ( { model | schedule_state = { state | amount = value } }, Cmd.none )

        Msg.ScheduleUpdate ->
            ( model, Cmd.none )

        Msg.ScheduleStart scheduleId ->
            let
                item =
                    Proto.Schedule_start.ScheduleStart scheduleId

                ( postSeed, id, cmd ) =
                    apiCall
                        item
                        "ScheduleStart"
                        scheduleStartEncoder
                        model.seed
                        ws_send
            in
                ( { model | seed = postSeed }, cmd )

        Msg.ScheduleStop scheduleId ->
            let
                item =
                    Proto.Schedule_stop.ScheduleStop scheduleId

                ( postSeed, id, cmd ) =
                    apiCall
                        item
                        "ScheduleStop"
                        scheduleStopEncoder
                        model.seed
                        ws_send
            in
                ( { model | seed = postSeed }, cmd )

        Msg.SessionCreateResponseMsg response ->
            ( { model | account = response.account }, Cmd.none )

        Msg.ScheduleNew ->
            let
                schedule =
                    model.schedule

                scheduleWithState =
                    { schedule | initialState = encode 0 (scheduleStateEncoder model.schedule_state) }

                item =
                    ScheduleCreate (Just scheduleWithState)

                ( postSeed, id, cmd ) =
                    apiCall
                        item
                        "ScheduleCreate"
                        scheduleCreateEncoder
                        model.seed
                        ws_send
            in
                ( { model | seed = postSeed }, cmd )

        Msg.ScheduleCreateResponseMsg response ->
            let
                model_ =
                    { model | schedule_add_req_id = Nothing }
            in
                if response.ok then
                    let
                        ( postSeed, id, cmd ) =
                            apiCall
                                (ScheduleList "")
                                "ScheduleList"
                                scheduleListEncoder
                                model_.seed
                                ws_send
                    in
                        ( { model_ | seed = postSeed, mode = ModeList }
                        , Cmd.batch [ Navigation.modifyUrl "#", cmd ]
                        )
                else
                    ( model_, Cmd.none )

        Msg.ScheduleListResponseMsg response ->
            ( { model | schedule_runs = response.schedules }, Cmd.none )

        Msg.ScheduleListPartialMsg listPartial ->
            let
                updatedRuns =
                    List.map (replace listPartial.scheduleRun) model.schedule_runs

                afterDelete =
                    List.filter filterDelete updatedRuns
            in
                ( { model | schedule_runs = afterDelete }, Cmd.none )

        Msg.ScheduleDelete scheduleId ->
            let
                item =
                    Proto.Schedule_delete.ScheduleDelete scheduleId

                ( postSeed, id, cmd ) =
                    apiCall
                        item
                        "ScheduleDelete"
                        scheduleDeleteEncoder
                        model.seed
                        ws_send
            in
                ( { model | seed = postSeed }, cmd )

        Msg.ScheduleDeleteResponseMsg response ->
            ( model, Cmd.none )

        Msg.AlgologMsg algolog ->
            ( { model | algorun_logs = algolog :: model.algorun_logs }, Cmd.none )

        Msg.AlgorunView algorunId ->
            let
                modelAlgorun =
                    model.algorun

                item =
                    AlgologList algorunId

                ( postSeed, id, cmd ) =
                    apiCall
                        item
                        "AlgologList"
                        algologListEncoder
                        model.seed
                        ws_send
            in
                ( { model
                    | mode = ModeView
                    , algorun = { modelAlgorun | id = algorunId }
                    , seed = postSeed
                  }
                , Cmd.batch
                    [ Navigation.newUrl ("#view/" ++ algorunId)
                    , cmd
                    ]
                )


replace : Maybe ScheduleRun -> ScheduleRun -> ScheduleRun
replace replacement existing =
    case replacement of
        Just r1 ->
            case r1.schedule of
                Just rs1 ->
                    case existing.schedule of
                        Just es1 ->
                            if rs1.id == es1.id then
                                r1
                            else
                                existing

                        Nothing ->
                            existing

                Nothing ->
                    existing

        Nothing ->
            existing


filterDelete scheduleRun =
    case scheduleRun.schedule of
        Just schedule ->
            schedule.status /= Schedule_Deleted

        Nothing ->
            False


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ ws_recv msg_recv ]


type alias Flags =
    { seed : Int }


init : Flags -> Navigation.Location -> ( Model, Cmd Msg )
init flags location =
    let
        firstSeed =
            birdSeed flags.seed

        words =
            String.split "/" location.hash
    in
        case List.head words of
            Just word ->
                case word of
                    "#add" ->
                        let
                            algoIdMaybe =
                                List.head (List.drop 1 (String.split "=" location.search))

                            schedule =
                                case algoIdMaybe of
                                    Just algoId ->
                                        (scheduleWithAlgoId algoId)

                                    _ ->
                                        blankSchedule
                        in
                            ( defaultModel firstSeed
                                ModeAdd
                                schedule
                                (blankAlgorun "")
                            , Cmd.none
                            )

                    "#view" ->
                        let
                            wordsSlice =
                                List.reverse (List.take 2 words)

                            ( runId, ( postPostSeed, apiId, cmd ) ) =
                                case List.head wordsSlice of
                                    Just id ->
                                        let
                                            theRest =
                                                apiCall
                                                    (AlgologList id)
                                                    "AlgologList"
                                                    algologListEncoder
                                                    firstSeed
                                                    ws_send
                                        in
                                            ( id, theRest )

                                    Nothing ->
                                        ( "", ( firstSeed, "", Cmd.none ) )
                        in
                            ( defaultModel postPostSeed
                                ModeView
                                blankSchedule
                                (blankAlgorun runId)
                            , cmd
                            )

                    _ ->
                        doTheList firstSeed

            Nothing ->
                doTheList firstSeed


doTheList : Seed -> ( Model, Cmd Msg )
doTheList firstSeed =
    let
        modedSeededModel =
            defaultModel firstSeed ModeList blankSchedule (blankAlgorun "")

        ( postSeed, id, cmd ) =
            apiCall
                (ScheduleList "")
                "ScheduleList"
                scheduleListEncoder
                modedSeededModel.seed
                ws_send
    in
        ( { modedSeededModel | seed = postSeed }, cmd )


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
