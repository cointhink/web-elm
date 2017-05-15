module Algorithms.Msg exposing (..)

import Proto.Session_create_response exposing (..)


type Mode
    = ModeSplash
    | ModeSignup


type Msg
    = Noop
    | SessionCreateResponseMsg SessionCreateResponse
