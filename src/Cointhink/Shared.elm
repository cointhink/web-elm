module Cointhink.Shared exposing (..)

type Msg = Init
           | OrderbookUpdate Orderbook
           | Alert String
           | Noop


type alias Orderbook = {
              date : String,
              exchange : String,
              market : OrderbookMarket,
              bids : List (String,Float),
              asks : List (String,Float)
           }

type alias OrderbookMarket = { base : String, quote : String }