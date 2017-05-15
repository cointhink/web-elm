module Exchanges.Msg exposing (..)

import Proto.Session_create_response exposing (..)


type Mode
    = ModeList
    | ModeAdd


type Msg
    = Noop
    | SessionCreateResponseMsg SessionCreateResponse
    | ExchangeNew
    | ExchangeNewApiKey String
    | ExchangeSend
