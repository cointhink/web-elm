module Proto.Schedule_stop exposing (..)

-- DO NOT EDIT
-- AUTOGENERATED BY THE ELM PROTOCOL BUFFER COMPILER
-- https://github.com/tiziano88/elm-protobuf
-- source file: proto/schedule_stop.proto

import Protobuf exposing (..)

import Json.Decode as JD
import Json.Encode as JE


type alias ScheduleStop =
    { scheduleId : String -- 1
    }


scheduleStopDecoder : JD.Decoder ScheduleStop
scheduleStopDecoder =
    JD.lazy <| \_ -> decode ScheduleStop
        |> required "ScheduleId" JD.string ""


scheduleStopEncoder : ScheduleStop -> JE.Value
scheduleStopEncoder v =
    JE.object <| List.filterMap identity <|
        [ (requiredFieldEncoder "ScheduleId" JE.string "" v.scheduleId)
        ]
