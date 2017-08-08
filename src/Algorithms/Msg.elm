module Algorithms.Msg exposing (..)

import Proto.Session_create_response exposing (..)
import Proto.Algorithm_list_response exposing (..)


type Mode
    = ModeList
    | ModeAdd
    | ModeUpdate


type Msg
    = Noop
    | AppInit
    | SessionCreateResponseMsg SessionCreateResponse
    | AlgorithmNewButton
    | AlgorithmNew
    | AlgorithmUpdate
    | AlgorithmListResponseMsg AlgorithmListResponse
