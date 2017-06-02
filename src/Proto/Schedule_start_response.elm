-- DO NOT EDIT
-- AUTOGENERATED BY THE ELM PROTOCOL BUFFER COMPILER
-- https://github.com/tiziano88/elm-protobuf
-- source file: proto/schedule_start_response.proto

module Proto.Schedule_start_response exposing (..)

import Protobuf exposing (..)

import Json.Decode as JD
import Json.Encode as JE


type alias ScheduleStartResponse =
    { ok : Bool -- 1
    , message : String -- 2
    }


scheduleStartResponseDecoder : JD.Decoder ScheduleStartResponse
scheduleStartResponseDecoder =
    JD.lazy <| \_ -> decode ScheduleStartResponse
        |> required "Ok" JD.bool False
        |> required "Message" JD.string ""


scheduleStartResponseEncoder : ScheduleStartResponse -> JE.Value
scheduleStartResponseEncoder v =
    JE.object <| List.filterMap identity <|
        [ (requiredFieldEncoder "Ok" JE.bool False v.ok)
        , (requiredFieldEncoder "Message" JE.string "" v.message)
        ]
