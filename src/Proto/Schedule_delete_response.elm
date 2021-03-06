module Proto.Schedule_delete_response exposing (..)

-- DO NOT EDIT
-- AUTOGENERATED BY THE ELM PROTOCOL BUFFER COMPILER
-- https://github.com/tiziano88/elm-protobuf
-- source file: proto/schedule_delete_response.proto

import Protobuf exposing (..)

import Json.Decode as JD
import Json.Encode as JE


type alias ScheduleDeleteResponse =
    { ok : Bool -- 1
    , message : String -- 2
    }


scheduleDeleteResponseDecoder : JD.Decoder ScheduleDeleteResponse
scheduleDeleteResponseDecoder =
    JD.lazy <| \_ -> decode ScheduleDeleteResponse
        |> required "Ok" JD.bool False
        |> required "Message" JD.string ""


scheduleDeleteResponseEncoder : ScheduleDeleteResponse -> JE.Value
scheduleDeleteResponseEncoder v =
    JE.object <| List.filterMap identity <|
        [ (requiredFieldEncoder "Ok" JE.bool False v.ok)
        , (requiredFieldEncoder "Message" JE.string "" v.message)
        ]
