module Schedules.Msg exposing (..)

import Proto.Session_create_response exposing (..)
import Proto.Schedule_create_response exposing (..)
import Proto.Schedule_list_response exposing (..)
import Proto.Schedule_list_partial exposing (..)


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
    | ScheduleStart String
    | ScheduleStop String
    | ScheduleUpdate
    | ScheduleCreateResponseMsg ScheduleCreateResponse
    | ScheduleListResponseMsg ScheduleListResponse
    | ScheduleListPartialMsg ScheduleListPartial
