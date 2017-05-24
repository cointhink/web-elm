module Schedules.Msg exposing (..)

import Proto.Session_create_response exposing (..)
import Proto.Schedule_create_response exposing (..)


type Mode
    = ModeList
    | ModeAdd
    | ModeUpdate


type Msg
    = Noop
    | SessionCreateResponseMsg SessionCreateResponse
    | ScheduleAdd
    | ScheduleNew
    | ScheduleNewExchange String
    | ScheduleNewAlgorithm String
    | ScheduleUpdate
    | ScheduleCreateResponseMsg ScheduleCreateResponse
