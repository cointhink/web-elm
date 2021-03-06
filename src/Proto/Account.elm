module Proto.Account exposing (..)

-- DO NOT EDIT
-- AUTOGENERATED BY THE ELM PROTOCOL BUFFER COMPILER
-- https://github.com/tiziano88/elm-protobuf
-- source file: proto/account.proto

import Protobuf exposing (..)

import Json.Decode as JD
import Json.Encode as JE


type alias Account =
    { id : String -- 1
    , email : String -- 2
    , username : String -- 3
    , fullname : String -- 4
    , timeZone : String -- 5
    , scheduleCredits : Int -- 6
    , stripe : String -- 7
    }


accountDecoder : JD.Decoder Account
accountDecoder =
    JD.lazy <| \_ -> decode Account
        |> required "Id" JD.string ""
        |> required "Email" JD.string ""
        |> required "Username" JD.string ""
        |> required "Fullname" JD.string ""
        |> required "TimeZone" JD.string ""
        |> required "ScheduleCredits" JD.int 0
        |> required "Stripe" JD.string ""


accountEncoder : Account -> JE.Value
accountEncoder v =
    JE.object <| List.filterMap identity <|
        [ (requiredFieldEncoder "Id" JE.string "" v.id)
        , (requiredFieldEncoder "Email" JE.string "" v.email)
        , (requiredFieldEncoder "Username" JE.string "" v.username)
        , (requiredFieldEncoder "Fullname" JE.string "" v.fullname)
        , (requiredFieldEncoder "TimeZone" JE.string "" v.timeZone)
        , (requiredFieldEncoder "ScheduleCredits" JE.int 0 v.scheduleCredits)
        , (requiredFieldEncoder "Stripe" JE.string "" v.stripe)
        ]
