module Schedules.Msg exposing (..)

import Proto.Session_create_response exposing (..)


type Mode
    = ModeList
    | ModeAdd
    | ModeUpdate


type Msg
    = Noop
    | SessionCreateResponseMsg SessionCreateResponse
    | ScheduleNewButton
    | ScheduleNew
    | ScheduleNewExchange String
    | ScheduleNewAlgorithm String
    | ScheduleUpdate
