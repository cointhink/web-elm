module Proto.Schedule_create exposing (..)

-- DO NOT EDIT
-- AUTOGENERATED BY THE ELM PROTOCOL BUFFER COMPILER
-- https://github.com/tiziano88/elm-protobuf
-- source file: proto/schedule_create.proto

import Protobuf exposing (..)

import Json.Decode as JD
import Json.Encode as JE
import Proto.Schedule exposing (..)


type alias ScheduleCreate =
    { schedule : Maybe Schedule -- 2
    }


scheduleCreateDecoder : JD.Decoder ScheduleCreate
scheduleCreateDecoder =
    JD.lazy <| \_ -> decode ScheduleCreate
        |> optional "Schedule" scheduleDecoder


scheduleCreateEncoder : ScheduleCreate -> JE.Value
scheduleCreateEncoder v =
    JE.object <| List.filterMap identity <|
        [ (optionalEncoder "Schedule" scheduleEncoder v.schedule)
        ]
