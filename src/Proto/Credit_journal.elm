module Proto.Credit_journal exposing (..)

-- DO NOT EDIT
-- AUTOGENERATED BY THE ELM PROTOCOL BUFFER COMPILER
-- https://github.com/tiziano88/elm-protobuf
-- source file: proto/credit_journal.proto

import Protobuf exposing (..)

import Json.Decode as JD
import Json.Encode as JE


type alias CreditJournal =
    { id : String -- 1
    , accountId : String -- 2
    , scheduleId : String -- 3
    , status : String -- 4
    , stripeTx : String -- 5
    , creditAdjustment : Int -- 6
    , totalUsd : Float -- 7
    }


creditJournalDecoder : JD.Decoder CreditJournal
creditJournalDecoder =
    JD.lazy <| \_ -> decode CreditJournal
        |> required "Id" JD.string ""
        |> required "AccountId" JD.string ""
        |> required "ScheduleId" JD.string ""
        |> required "Status" JD.string ""
        |> required "StripeTx" JD.string ""
        |> required "CreditAdjustment" JD.int 0
        |> required "TotalUsd" JD.float 0.0


creditJournalEncoder : CreditJournal -> JE.Value
creditJournalEncoder v =
    JE.object <| List.filterMap identity <|
        [ (requiredFieldEncoder "Id" JE.string "" v.id)
        , (requiredFieldEncoder "AccountId" JE.string "" v.accountId)
        , (requiredFieldEncoder "ScheduleId" JE.string "" v.scheduleId)
        , (requiredFieldEncoder "Status" JE.string "" v.status)
        , (requiredFieldEncoder "StripeTx" JE.string "" v.stripeTx)
        , (requiredFieldEncoder "CreditAdjustment" JE.int 0 v.creditAdjustment)
        , (requiredFieldEncoder "TotalUsd" JE.float 0.0 v.totalUsd)
        ]
