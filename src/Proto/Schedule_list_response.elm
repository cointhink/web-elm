module Proto.Schedule_list_response exposing (..)

-- DO NOT EDIT
-- AUTOGENERATED BY THE ELM PROTOCOL BUFFER COMPILER
-- https://github.com/tiziano88/elm-protobuf
-- source file: proto/schedule_list_response.proto

import Protobuf exposing (..)

import Json.Decode as JD
import Json.Encode as JE
import Proto.Schedule_run exposing (..)


type alias ScheduleListResponse =
    { ok : Bool -- 1
    , message : String -- 2
    , schedules : List ScheduleRun -- 3
    }


scheduleListResponseDecoder : JD.Decoder ScheduleListResponse
scheduleListResponseDecoder =
    JD.lazy <| \_ -> decode ScheduleListResponse
        |> required "Ok" JD.bool False
        |> required "Message" JD.string ""
        |> repeated "Schedules" scheduleRunDecoder


scheduleListResponseEncoder : ScheduleListResponse -> JE.Value
scheduleListResponseEncoder v =
    JE.object <| List.filterMap identity <|
        [ (requiredFieldEncoder "Ok" JE.bool False v.ok)
        , (requiredFieldEncoder "Message" JE.string "" v.message)
        , (repeatedFieldEncoder "Schedules" scheduleRunEncoder v.schedules)
        ]
