module Schedules.Msg exposing (..)

import Proto.Session_create_response exposing (..)
import Proto.Schedule_create_response exposing (..)
import Proto.Schedule_delete_response exposing (..)
import Proto.Schedule_start_response exposing (..)
import Proto.Schedule_list_response exposing (..)
import Proto.Schedule_list_partial exposing (..)
import Proto.Algolog exposing (..)
import Proto.Algorithm_detail_response exposing (..)


type Mode
    = ModeList
    | ModeAdd
    | ModeUpdate
    | ModeView
    | ModeEdit


type Msg
    = Noop
    | SessionCreateResponseMsg SessionCreateResponse
    | ScheduleNew
    | ScheduleRequest
    | ScheduleSelectField String String
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
    | AlgorithmDetailReponseMsg AlgorithmDetailResponse
    | ScheduleEditView String
