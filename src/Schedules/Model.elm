module Schedules.Model exposing (..)

import String
import Dict
import Schedules.Msg exposing (..)
import Proto.Algolog exposing (..)
import Proto.Algorun exposing (..)
import Proto.Account exposing (..)
import Proto.Algorithm exposing (..)
import Proto.Schedule exposing (..)
import Proto.Schedule_run exposing (..)
import Random.Pcg exposing (Seed)
import Json.Encode as JE
import Json.Decode as JD


type alias Model =
    { account : Maybe Account
    , mode : Mode
    , seed : Seed
    , schedule : Schedule
    , schedule_new_algorithm_req_id : Maybe String
    , schedule_new_algorithm : Maybe Algorithm
    , schedule_new_schema : Dict.Dict String SchemaRecord
    , schedule_new_initial_values : Dict.Dict String String
    , schedule_add_req_id : Maybe String
    , schedule_edit_schedule_id : Maybe String
    , schedule_runs : List ScheduleRun
    , algorun : Algorun
    , algorun_logs : List Algolog
    , top_notice : String
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
        Nothing
        Dict.empty
        Dict.empty
        Nothing
        Nothing
        []
        algorun
        []
        ""


birdSeed : Int -> Seed
birdSeed intSeed =
    Random.Pcg.initialSeed intSeed


blankSchedule =
    scheduleWithAlgoId "noop"


scheduleWithAlgoId : String -> Schedule
scheduleWithAlgoId algoId =
    Schedule "" "" algoId Schedule_Unknown "{}" "" Schedule_Container


blankAlgorun : String -> Algorun
blankAlgorun id =
    Algorun id "" "" "" "" "" "" ""


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


schemaRecordDecoder =
    JD.map3 SchemaRecord
        (JD.field "type" JD.string)
        (JD.field "default" JD.string)
        (JD.field "display" JD.string)


type alias SchemaRecord =
    { type_ : String
    , default : String
    , display : String
    }
