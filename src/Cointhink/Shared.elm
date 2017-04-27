module Cointhink.Shared exposing (..)

type Msg =   OrderbookQuery
           | ExchangesQuery
           | OrderbookUpdate Orderbook
           | ExchangeUpdate Exchange
           | Alert String
           | MarketChoice String
           | Noop

type alias Exchange = {
               id : String,
               markets : List Market,
               date : String
             }

type alias Orderbook = {
              date : String,
              exchange : String,
              market : Market,
              bids : List Offer,
              asks : List Offer
           }

type alias Market = { base : String, quote : String }

type alias Offer = { price: String, quantity: Float }
