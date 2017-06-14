module Proto.Schedule_list_partial exposing (..)

-- DO NOT EDIT
-- AUTOGENERATED BY THE ELM PROTOCOL BUFFER COMPILER
-- https://github.com/tiziano88/elm-protobuf
-- source file: proto/schedule_list_partial.proto

import Protobuf exposing (..)

import Json.Decode as JD
import Json.Encode as JE
import Proto.Schedule_run exposing (..)


type alias ScheduleListPartial =
    { listId : String -- 1
    , scheduleRun : Maybe ScheduleRun -- 2
    }


scheduleListPartialDecoder : JD.Decoder ScheduleListPartial
scheduleListPartialDecoder =
    JD.lazy <| \_ -> decode ScheduleListPartial
        |> required "ListId" JD.string ""
        |> optional "ScheduleRun" scheduleRunDecoder


scheduleListPartialEncoder : ScheduleListPartial -> JE.Value
scheduleListPartialEncoder v =
    JE.object <| List.filterMap identity <|
        [ (requiredFieldEncoder "ListId" JE.string "" v.listId)
        , (optionalEncoder "ScheduleRun" scheduleRunEncoder v.scheduleRun)
        ]
