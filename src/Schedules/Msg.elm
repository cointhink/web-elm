module Schedules.Msg exposing (..)

import Proto.Session_create_response exposing (..)
import Proto.Schedule_create_response exposing (..)
import Proto.Schedule_delete_response exposing (..)
import Proto.Schedule_start_response exposing (..)
import Proto.Schedule_list_response exposing (..)
import Proto.Schedule_list_partial exposing (..)
import Proto.Schedule_detail_response exposing (..)
import Proto.Schedule exposing (..)
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
    | ScheduleListRequest
    | ScheduleSelectField String String
    | ScheduleNewAlgorithm String
    | ScheduleStart String
    | ScheduleStartResponseMsg ScheduleStartResponse
    | ScheduleStop String
    | ScheduleDelete String
    | ScheduleDeleteResponseMsg ScheduleDeleteResponse
    | ScheduleUpdate
    | ScheduleCreateMsg
    | ScheduleCreateResponseMsg ScheduleCreateResponse
    | ScheduleListResponseMsg ScheduleListResponse
    | ScheduleListPartialMsg ScheduleListPartial
    | ScheduleEditView String
    | ScheduleEditUrl String
    | ScheduleDetailResponseMsg ScheduleDetailResponse
    | AlgologMsg Algolog
    | AlgorunView String
    | StripePay
    | AlgorithmDetailReponseMsg AlgorithmDetailResponse
