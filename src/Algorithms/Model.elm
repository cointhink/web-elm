module Algorithms.Model exposing (..)

import String
import Algorithms.Msg exposing (..)
import Proto.Account exposing (..)
import Random.Pcg exposing (Seed)


type alias Model =
    { account : Maybe Account
    , mode : Mode
    , seed : Seed
    }


defaultModel : Mode -> Int -> Model
defaultModel mode seed =
    Model
        Nothing
        mode
        (Random.Pcg.initialSeed seed)
