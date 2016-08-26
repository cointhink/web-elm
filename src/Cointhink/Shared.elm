module Cointhink.Shared exposing (..)

type Msg =   OrderbookQuery
           | ExchangesQuery
           | OrderbookUpdate Orderbook
           | ExchangeUpdate Exchange
           | Alert String
           | Noop


type alias Orderbook = {
              date : String,
              exchange : String,
              market : Market,
              bids : List (String,Float),
              asks : List (String,Float)
           }

type alias Market = { base : String, quote : String }

type alias Exchange = {
               id : String,
               markets : List Market,
               date : String
             }

