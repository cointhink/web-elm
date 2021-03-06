module Proto.Algorun exposing (..)

-- DO NOT EDIT
-- AUTOGENERATED BY THE ELM PROTOCOL BUFFER COMPILER
-- https://github.com/tiziano88/elm-protobuf
-- source file: proto/algorun.proto

import Protobuf exposing (..)

import Json.Decode as JD
import Json.Encode as JE


type alias Algorun =
    { id : String -- 1
    , algorithmId : String -- 2
    , accountId : String -- 3
    , scheduleId : String -- 4
    , status : String -- 5
    , code : String -- 6
    , image : String -- 7
    , state : String -- 8
    }


type Algorun_States
    = Algorun_Unknown -- 0
    | Algorun_Building -- 1
    | Algorun_Starting -- 2
    | Algorun_Running -- 3
    | Algorun_Stopped -- 4
    | Algorun_Destroying -- 5
    | Algorun_Deleted -- 6


algorunDecoder : JD.Decoder Algorun
algorunDecoder =
    JD.lazy <| \_ -> decode Algorun
        |> required "Id" JD.string ""
        |> required "AlgorithmId" JD.string ""
        |> required "AccountId" JD.string ""
        |> required "ScheduleId" JD.string ""
        |> required "Status" JD.string ""
        |> required "Code" JD.string ""
        |> required "Image" JD.string ""
        |> required "State" JD.string ""


algorun_StatesDecoder : JD.Decoder Algorun_States
algorun_StatesDecoder =
    let
        lookup s =
            case s of
                "unknown" ->
                    Algorun_Unknown

                "building" ->
                    Algorun_Building

                "starting" ->
                    Algorun_Starting

                "running" ->
                    Algorun_Running

                "stopped" ->
                    Algorun_Stopped

                "destroying" ->
                    Algorun_Destroying

                "deleted" ->
                    Algorun_Deleted

                _ ->
                    Algorun_Unknown
    in
        JD.map lookup JD.string


algorun_StatesDefault : Algorun_States
algorun_StatesDefault = Algorun_Unknown


algorunEncoder : Algorun -> JE.Value
algorunEncoder v =
    JE.object <| List.filterMap identity <|
        [ (requiredFieldEncoder "Id" JE.string "" v.id)
        , (requiredFieldEncoder "AlgorithmId" JE.string "" v.algorithmId)
        , (requiredFieldEncoder "AccountId" JE.string "" v.accountId)
        , (requiredFieldEncoder "ScheduleId" JE.string "" v.scheduleId)
        , (requiredFieldEncoder "Status" JE.string "" v.status)
        , (requiredFieldEncoder "Code" JE.string "" v.code)
        , (requiredFieldEncoder "Image" JE.string "" v.image)
        , (requiredFieldEncoder "State" JE.string "" v.state)
        ]


algorun_StatesEncoder : Algorun_States -> JE.Value
algorun_StatesEncoder v =
    let
        lookup s =
            case s of
                Algorun_Unknown ->
                    "unknown"

                Algorun_Building ->
                    "building"

                Algorun_Starting ->
                    "starting"

                Algorun_Running ->
                    "running"

                Algorun_Stopped ->
                    "stopped"

                Algorun_Destroying ->
                    "destroying"

                Algorun_Deleted ->
                    "deleted"

    in
        JE.string <| lookup v
