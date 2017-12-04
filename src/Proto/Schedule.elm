module Proto.Schedule exposing (..)

-- DO NOT EDIT
-- AUTOGENERATED BY THE ELM PROTOCOL BUFFER COMPILER
-- https://github.com/tiziano88/elm-protobuf
-- source file: proto/schedule.proto

import Protobuf exposing (..)

import Json.Decode as JD
import Json.Encode as JE


type alias Schedule =
    { id : String -- 1
    , accountId : String -- 2
    , algorithmId : String -- 3
    , status : Schedule_States -- 4
    , initialState : String -- 5
    , enabledUntil : String -- 6
    , executor : Schedule_Executors -- 7
    }


type Schedule_States
    = Schedule_Unknown -- 0
    | Schedule_Disabled -- 1
    | Schedule_Enabled -- 2
    | Schedule_Deleted -- 3


type Schedule_Executors
    = Schedule_Container -- 0
    | Schedule_Lambda -- 1
    | Schedule_LambdaMaster -- 2


scheduleDecoder : JD.Decoder Schedule
scheduleDecoder =
    JD.lazy <| \_ -> decode Schedule
        |> required "Id" JD.string ""
        |> required "AccountId" JD.string ""
        |> required "AlgorithmId" JD.string ""
        |> required "Status" schedule_StatesDecoder schedule_StatesDefault
        |> required "InitialState" JD.string ""
        |> required "EnabledUntil" JD.string ""
        |> required "Executor" schedule_ExecutorsDecoder schedule_ExecutorsDefault


schedule_StatesDecoder : JD.Decoder Schedule_States
schedule_StatesDecoder =
    let
        lookup s =
            case s of
                "unknown" ->
                    Schedule_Unknown

                "disabled" ->
                    Schedule_Disabled

                "enabled" ->
                    Schedule_Enabled

                "deleted" ->
                    Schedule_Deleted

                _ ->
                    Schedule_Unknown
    in
        JD.map lookup JD.string


schedule_StatesDefault : Schedule_States
schedule_StatesDefault = Schedule_Unknown


schedule_ExecutorsDecoder : JD.Decoder Schedule_Executors
schedule_ExecutorsDecoder =
    let
        lookup s =
            case s of
                "container" ->
                    Schedule_Container

                "lambda" ->
                    Schedule_Lambda

                "lambda_master" ->
                    Schedule_LambdaMaster

                _ ->
                    Schedule_Container
    in
        JD.map lookup JD.string


schedule_ExecutorsDefault : Schedule_Executors
schedule_ExecutorsDefault = Schedule_Container


scheduleEncoder : Schedule -> JE.Value
scheduleEncoder v =
    JE.object <| List.filterMap identity <|
        [ (requiredFieldEncoder "Id" JE.string "" v.id)
        , (requiredFieldEncoder "AccountId" JE.string "" v.accountId)
        , (requiredFieldEncoder "AlgorithmId" JE.string "" v.algorithmId)
        , (requiredFieldEncoder "Status" schedule_StatesEncoder schedule_StatesDefault v.status)
        , (requiredFieldEncoder "InitialState" JE.string "" v.initialState)
        , (requiredFieldEncoder "EnabledUntil" JE.string "" v.enabledUntil)
        , (requiredFieldEncoder "Executor" schedule_ExecutorsEncoder schedule_ExecutorsDefault v.executor)
        ]


schedule_StatesEncoder : Schedule_States -> JE.Value
schedule_StatesEncoder v =
    let
        lookup s =
            case s of
                Schedule_Unknown ->
                    "unknown"

                Schedule_Disabled ->
                    "disabled"

                Schedule_Enabled ->
                    "enabled"

                Schedule_Deleted ->
                    "deleted"

    in
        JE.string <| lookup v


schedule_ExecutorsEncoder : Schedule_Executors -> JE.Value
schedule_ExecutorsEncoder v =
    let
        lookup s =
            case s of
                Schedule_Container ->
                    "container"

                Schedule_Lambda ->
                    "lambda"

                Schedule_LambdaMaster ->
                    "lambda_master"

    in
        JE.string <| lookup v
