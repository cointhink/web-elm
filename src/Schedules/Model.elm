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
    }


defaultModel : Mode -> Int -> Model
defaultModel mode seed =
    Model
        Nothing
        mode
        (Random.Pcg.initialSeed seed)
        (Schedule "" "" "noop" "")
