module Schedules.Model exposing (..)

import String
import Schedules.Msg exposing (..)
import Proto.Account exposing (..)
import Proto.Schedule exposing (..)
import Random.Pcg exposing (Seed)
import Json.Encode as JE


type alias Model =
    { account : Maybe Account
    , mode : Mode
    , seed : Seed
    , schedule : Schedule
    , schedule_add_req_id : Maybe String
    , schedule_state : ScheduleState
    , schedules : List Schedule
    }


type alias ScheduleState =
    { exchange : String
    , market : String
    , amount : String
    }


scheduleStateEncoder : ScheduleState -> JE.Value
scheduleStateEncoder item =
    JE.object
        [ ( "Exchange", JE.string item.exchange )
        , ( "Market", JE.string item.market )
        , ( "Amount", JE.string item.amount )
        ]


defaultModel : Int -> Mode -> Model
defaultModel seed mode =
    Model
        Nothing
        mode
        (Random.Pcg.initialSeed seed)
        (Schedule "" "" "noop" "" "{}")
        Nothing
        (ScheduleState "" "" "")
        []


isFormSent : Model -> Bool
isFormSent model =
    case model.schedule_add_req_id of
        Just id ->
            True

        Nothing ->
            False
