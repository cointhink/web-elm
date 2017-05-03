module Cointhink.Protocol exposing (..)

-- elm modules
import Json.Encode exposing (object, encode, string, int)
import Json.Decode exposing (decodeString, field, array, map2, map3, map5, value, list)
import WebSocket

import Cointhink.Shared exposing (..)

type alias WsResponse = { id : String, class: String, object : Json.Decode.Value }
type alias WsRequest = { id : String, class: String, object: Json.Encode.Value }


