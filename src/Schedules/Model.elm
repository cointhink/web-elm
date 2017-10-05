module Schedules.Model exposing (..)

import String
import Schedules.Msg exposing (..)
import Proto.Algolog exposing (..)
import Proto.Algorun exposing (..)
import Proto.Account exposing (..)
import Proto.Schedule exposing (..)
import Proto.Schedule_run exposing (..)
import Random.Pcg exposing (Seed)
import Json.Encode as JE


type alias Model =
    { account : Maybe Account
    , mode : Mode
    , seed : Seed
    , schedule : Schedule
    , schedule_add_req_id : Maybe String
    , schedule_state : ScheduleState
    , schedule_runs : List ScheduleRun
    , algorun : Algorun
    , algorun_logs : List Algolog
    }


type alias ScheduleState =
    { exchange : String
    , market : String
    , amount : String
    }


defaultModel : Seed -> Mode -> Schedule -> Algorun -> Model
defaultModel seed mode schedule algorun =
    Model
        Nothing
        mode
        seed
        schedule
        Nothing
        (ScheduleState "" "" "")
        []
        algorun
        []


birdSeed : Int -> Seed
birdSeed intSeed =
    Random.Pcg.initialSeed intSeed


blankSchedule =
    scheduleWithAlgoId "noop"


scheduleWithAlgoId : String -> Schedule
scheduleWithAlgoId algoId =
    Schedule "" "" algoId Schedule_Unknown "{}" ""


blankAlgorun : String -> Algorun
blankAlgorun id =
    Algorun id "" "" "" "" "" ""


scheduleStateEncoder : ScheduleState -> JE.Value
scheduleStateEncoder item =
    JE.object
        [ ( "Exchange", JE.string item.exchange )
        , ( "Market", JE.string item.market )
        , ( "Amount", JE.string item.amount )
        ]


isFormSent : Model -> Bool
isFormSent model =
    case model.schedule_add_req_id of
        Just id ->
            True

        Nothing ->
            False
