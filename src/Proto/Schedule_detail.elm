module Proto.Schedule_detail exposing (..)

-- DO NOT EDIT
-- AUTOGENERATED BY THE ELM PROTOCOL BUFFER COMPILER
-- https://github.com/tiziano88/elm-protobuf
-- source file: proto/schedule_detail.proto

import Protobuf exposing (..)

import Json.Decode as JD
import Json.Encode as JE


type alias ScheduleDetail =
    { scheduleId : String -- 1
    }


scheduleDetailDecoder : JD.Decoder ScheduleDetail
scheduleDetailDecoder =
    JD.lazy <| \_ -> decode ScheduleDetail
        |> required "scheduleId" JD.string ""


scheduleDetailEncoder : ScheduleDetail -> JE.Value
scheduleDetailEncoder v =
    JE.object <| List.filterMap identity <|
        [ (requiredFieldEncoder "scheduleId" JE.string "" v.scheduleId)
        ]
