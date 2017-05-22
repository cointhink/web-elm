module Algorithms.Msg exposing (..)

import Proto.Session_create_response exposing (..)


type Mode
    = ModeList
    | ModeAdd
    | ModeUpdate


type Msg
    = Noop
    | SessionCreateResponseMsg SessionCreateResponse
    | AlgorithmNewButton
    | AlgorithmNew
    | AlgorithmUpdate
