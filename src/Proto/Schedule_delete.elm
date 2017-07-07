module Proto.Schedule_delete exposing (..)

-- DO NOT EDIT
-- AUTOGENERATED BY THE ELM PROTOCOL BUFFER COMPILER
-- https://github.com/tiziano88/elm-protobuf
-- source file: proto/schedule_delete.proto

import Protobuf exposing (..)

import Json.Decode as JD
import Json.Encode as JE


type alias ScheduleDelete =
    { scheduleId : String -- 1
    }


scheduleDeleteDecoder : JD.Decoder ScheduleDelete
scheduleDeleteDecoder =
    JD.lazy <| \_ -> decode ScheduleDelete
        |> required "ScheduleId" JD.string ""


scheduleDeleteEncoder : ScheduleDelete -> JE.Value
scheduleDeleteEncoder v =
    JE.object <| List.filterMap identity <|
        [ (requiredFieldEncoder "ScheduleId" JE.string "" v.scheduleId)
        ]