port module Cointhink.Protocol exposing (..)

-- elm modules
import Json.Encode exposing (object, encode, string, int)
import Json.Decode exposing (decodeString, field, array, map2, map3, map5, value, list)
import WebSocket
import Uuid.Barebones
import Random.Pcg exposing (Seed, initialSeed, step)
import String exposing (..)

import Cointhink.Shared exposing (..)

type alias WsResponse = { id : String, method: String, object : Json.Decode.Value }
type alias WsRequest = { id : String, method: String, object: Json.Encode.Value }

idGen: Seed -> (String, Seed)
idGen seed =
  let
    (uuid, new_seed) = step Uuid.Barebones.uuidStringGenerator seed
  in
    (slice 19 36 uuid, new_seed)
