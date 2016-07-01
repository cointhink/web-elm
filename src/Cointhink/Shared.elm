module Cointhink.Shared exposing (..)

type Msg = Init | OrderbookUpdate Orderbook | Noop

type alias Orderbook = { date : String, exchange : String }
