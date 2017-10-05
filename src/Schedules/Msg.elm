module Schedules.Msg exposing (..)

import Proto.Session_create_response exposing (..)
import Proto.Schedule_create_response exposing (..)
import Proto.Schedule_delete_response exposing (..)
import Proto.Schedule_start_response exposing (..)
import Proto.Schedule_list_response exposing (..)
import Proto.Schedule_list_partial exposing (..)
import Proto.Algolog exposing (..)


type Mode
    = ModeList
    | ModeAdd
    | ModeUpdate
    | ModeView


type Msg
    = Noop
    | SessionCreateResponseMsg SessionCreateResponse
    | ScheduleNew
    | ScheduleRequest
    | ScheduleSelectExchange String
    | ScheduleSelectMarket String
    | ScheduleSelectAmount String
    | ScheduleNewAlgorithm String
    | ScheduleStart String
    | ScheduleStartResponseMsg ScheduleStartResponse
    | ScheduleStop String
    | ScheduleDelete String
    | ScheduleDeleteResponseMsg ScheduleDeleteResponse
    | ScheduleUpdate
    | ScheduleCreateResponseMsg ScheduleCreateResponse
    | ScheduleListResponseMsg ScheduleListResponse
    | ScheduleListPartialMsg ScheduleListPartial
    | AlgologMsg Algolog
    | AlgorunView String
    | StripePay
