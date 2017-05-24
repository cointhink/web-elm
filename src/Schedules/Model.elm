module Schedules.Model exposing (..)

import String
import Schedules.Msg exposing (..)
import Proto.Account exposing (..)
import Proto.Schedule exposing (..)
import Random.Pcg exposing (Seed)


type alias Model =
    { account : Maybe Account
    , mode : Mode
    , seed : Seed
    , schedule : Schedule
    , schedule_add_req_id : Maybe String
    }


defaultModel : Int -> Mode -> Model
defaultModel seed mode =
    Model
        Nothing
        mode
        (Random.Pcg.initialSeed seed)
        (Schedule "" "" "noop" "")
        Nothing


isFormSent : Model -> Bool
isFormSent model =
    case model.schedule_add_req_id of
        Just id ->
            True

        Nothing ->
            False
