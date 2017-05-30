module Schedules.Msg exposing (..)

import Proto.Session_create_response exposing (..)
import Proto.Schedule_create_response exposing (..)
import Proto.Schedule_list_response exposing (..)


type Mode
    = ModeList
    | ModeAdd
    | ModeUpdate


type Msg
    = Noop
    | SessionCreateResponseMsg SessionCreateResponse
    | ScheduleAdd
    | ScheduleNew
    | ScheduleSelectExchange String
    | ScheduleSelectMarket String
    | ScheduleSelectAmount String
    | ScheduleNewAlgorithm String
    | ScheduleUpdate
    | ScheduleCreateResponseMsg ScheduleCreateResponse
    | ScheduleListResponseMsg ScheduleListResponse
