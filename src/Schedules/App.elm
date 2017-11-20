port module Schedules.App exposing (app)

import Platform.Cmd exposing (Cmd)
import String
import Dict
import Navigation
import Json.Encode exposing (Value, encode, object, string)
import Json.Decode as JD
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
import Proto.Schedule_start_response exposing (..)
import Proto.Schedule_stop exposing (..)
import Proto.Schedule_delete exposing (..)
import Proto.Schedule_run exposing (..)
import Proto.Schedule exposing (..)
import Proto.Algorithm_detail exposing (..)
import Proto.Algorithm_detail_response exposing (..)
import Cointhink.Protocol exposing (..)
import Random.Pcg exposing (Seed, initialSeed, step)


port ws_send : WsRequest -> Cmd msg


port ws_recv : (WsResponse -> msg) -> Sub msg


port stripe_pay : String -> Cmd msg


msg_recv : WsResponse -> Msg
msg_recv response =
    let
        debug =
            Debug.log "schedules ws_resp" response
    in
        case response.method of
            "Noop" ->
                Noop

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

            "ScheduleStartResponse" ->
                wsDecode
                    scheduleStartResponseDecoder
                    response.object
                    Msg.ScheduleStartResponseMsg
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

            "AlgorithmDetailResponse" ->
                wsDecode
                    algorithmDetailResponseDecoder
                    response.object
                    Msg.AlgorithmDetailReponseMsg
                    Noop

            _ ->
                Noop


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case (Debug.log "schedules update" msg) of
        Msg.Noop ->
            ( model, Cmd.none )

        Msg.StripePay ->
            case model.account of
                Nothing ->
                    ( model, Cmd.none )

                Just account ->
                    ( model, stripe_pay account.email )

        Msg.ScheduleNewAlgorithm aId ->
            let
                item =
                    model.schedule

                ( postSeed, id, cmd ) =
                    apiCall
                        (Proto.Algorithm_detail.AlgorithmDetail aId)
                        "AlgorithmDetail"
                        algorithmDetailEncoder
                        model.seed
                        ws_send
            in
                ( { model
                    | mode = ModeAdd
                    , schedule = { item | algorithmId = aId }
                    , schedule_new_algorithm_req_id = Just id
                    , schedule_new_initial_values = Dict.empty
                    , seed = postSeed
                  }
                , cmd
                )

        Msg.ScheduleSelectField key value ->
            let
                initial_values =
                    Dict.insert key value model.schedule_new_initial_values
            in
                ( { model | schedule_new_initial_values = initial_values }, Cmd.none )

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

        Msg.ScheduleStartResponseMsg scheduleStartResponse ->
            ( { model | top_notice = scheduleStartResponse.message }, Cmd.none )

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
                    { schedule
                        | initialState =
                            encode 0
                                (object
                                    (Dict.toList
                                        (Dict.map (\k v -> string v) model.schedule_new_initial_values)
                                    )
                                )
                    }

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
            case model.account of
                Just account ->
                    let
                        model_ =
                            { model | schedule_add_req_id = Nothing }

                        account_ =
                            { account | scheduleCredits = account.scheduleCredits - 1 }
                    in
                        if response.ok then
                            let
                                ( subModel, cmd ) =
                                    update Msg.ScheduleRequest model_
                            in
                                ( { subModel | account = Just account_ }
                                , Cmd.batch [ Navigation.modifyUrl "#", cmd ]
                                )
                        else
                            ( model_, Cmd.none )

                Nothing ->
                    ( model, Cmd.none )

        Msg.ScheduleRequest ->
            let
                ( postSeed, id, cmd ) =
                    apiCall
                        (ScheduleList "")
                        "ScheduleList"
                        scheduleListEncoder
                        model.seed
                        ws_send
            in
                ( { model | seed = postSeed, mode = ModeList }, cmd )

        Msg.ScheduleListResponseMsg response ->
            ( { model | schedule_runs = response.schedules }, Cmd.none )

        Msg.ScheduleListPartialMsg listPartial ->
            let
                updatedRuns =
                    model.schedule_runs
                        |> List.map (replace listPartial.scheduleRun)
                        |> List.filter filterDelete
            in
                ( { model | schedule_runs = updatedRuns }, Cmd.none )

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
            ( if algolog.algorunId == model.algorun.id then
                { model
                    | algorun_logs =
                        (algolog :: model.algorun_logs)
                            |> List.sortWith logDateOrder
                }
              else
                model
            , Cmd.none
            )

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
                    , algorun_logs = []
                    , seed = postSeed
                  }
                , cmd
                )

        Msg.AlgorithmDetailReponseMsg algoDetailResp ->
            case algoDetailResp.ok of
                True ->
                    let
                        algorithmMaybe =
                            algoDetailResp.algorithm

                        fields =
                            case algorithmMaybe of
                                Just algorithm ->
                                    case JD.decodeString (JD.dict schemaRecordDecoder) algorithm.schema of
                                        Ok items ->
                                            items

                                        Err err ->
                                            Dict.empty

                                Nothing ->
                                    Dict.empty

                        default_values =
                            Dict.map (\k v -> v.default) fields
                    in
                        ( { model
                            | schedule_new_algorithm = algorithmMaybe
                            , schedule_new_initial_values = default_values
                            , schedule_new_schema = fields
                          }
                        , Cmd.none
                        )

                False ->
                    ( model, Cmd.none )

        Msg.ScheduleEditView scheduleId ->
            ( { model | mode = ModeEdit }, Cmd.none )


logDateOrder : Algolog -> Algolog -> Order
logDateOrder a b =
    case compare a.createdAt b.createdAt of
        LT ->
            GT

        GT ->
            LT

        EQ ->
            EQ


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

        firstModel =
            defaultModel firstSeed ModeList blankSchedule (blankAlgorun "")

        firstAction =
            fromUrl location
    in
        update firstAction firstModel


fromUrl : Navigation.Location -> Msg
fromUrl location =
    let
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
                        in
                            case algoIdMaybe of
                                Just algoId ->
                                    Msg.ScheduleNewAlgorithm algoId

                                _ ->
                                    Msg.Noop

                    "#view" ->
                        let
                            wordsSlice =
                                List.reverse (List.take 2 words)
                        in
                            case List.head wordsSlice of
                                Just id ->
                                    Msg.AlgorunView id

                                Nothing ->
                                    Msg.Noop

                    "#edit" ->
                        let
                            wordsSlice =
                                List.reverse (List.take 2 words)
                        in
                            case List.head wordsSlice of
                                Just id ->
                                    Msg.ScheduleEditView id

                                Nothing ->
                                    Msg.Noop

                    _ ->
                        Msg.ScheduleRequest

            Nothing ->
                Msg.ScheduleRequest


app =
    Navigation.programWithFlags
        fromUrl
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
