port module Cointhink.Protocol exposing (..)

-- elm modules

import Json.Encode exposing (object, encode, string, int)
import Json.Decode exposing (decodeValue, decodeString, field, array, map2, map3, map5, value, list)
import WebSocket
import Uuid.Barebones
import Random.Pcg exposing (Seed, initialSeed, step)
import String exposing (..)


type alias WsResponse =
    { id : String, method : String, object : Json.Decode.Value }


type alias WsRequest =
    { id : String, method : String, object : Json.Encode.Value }


idGen : Seed -> ( String, Seed )
idGen seed =
    let
        ( uuid, new_seed ) =
            step Uuid.Barebones.uuidStringGenerator seed
    in
        ( slice 19 36 uuid, new_seed )


apiCall :
    item
    -> String
    -> (item -> Json.Encode.Value)
    -> Seed
    -> (WsRequest -> Cmd msg)
    -> ( Seed, String, Cmd msg )
apiCall item itemName itemEncoder seed ws_send =
    let
        itemEncoded =
            itemEncoder item

        ( uuid, newSeed ) =
            idGen seed

        request =
            (Debug.log "ws_send" (WsRequest uuid itemName itemEncoded))
    in
        ( newSeed, uuid, ws_send request )


wsDecode decoder payload okMsg errMsg =
    case decodeValue decoder payload of
        Ok response ->
            okMsg response

        Err reason ->
            errMsg
