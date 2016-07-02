module Cointhink.Shared exposing (..)

type Msg = Init
           | OrderbookUpdate Orderbook
           | Alert String
           | Noop

type alias Orderbook = {
              date : String,
              exchange : String,
              market : { base : String , quote : String },
              bids : List (String,Float),
              asks : List (String,Float)
           }
