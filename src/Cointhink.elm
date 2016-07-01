port module Cointhink exposing (init, subscriptions, view, update)

import Platform.Cmd exposing (Cmd)
import Task
import WebSocket
import Json.Encode exposing (object, encode, string, int)

import Components

type Msg = Init | Ask | Noop

port input : (Int -> msg) -> Sub msg
port graphdata : () -> Cmd msg
port setup : () -> Cmd msg

view = Components.view

type alias Model = { ws_url: String, start_range : String }

wsSend : String -> Json.Encode.Value -> Cmd Msg
wsSend url say = WebSocket.send url (encode 2 (Debug.log "say" say))

exchangesRpc : Model -> Cmd Msg
exchangesRpc model = wsSend model.ws_url (exchangesRequest)

marketRpc : Model -> String -> String -> Cmd Msg
marketRpc model base quote = wsSend model.ws_url (coinrequest base quote)

coinrequest : String -> String -> Json.Encode.Value
coinrequest base quote = object [ ( "method" , string "orderbook" ),
                                  ( "params" , object [ ("base", string base),
                                                        ("quote", string quote),
                                                        ("days", int 1)
                                                      ] )
                                ]
exchangesRequest = object [ ( "method" , string "exchanges" ) ]

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case (Debug.log "MESSAGE" msg) of
        Init ->
            ( Debug.log "model" model, Cmd.batch [ exchangesRpc model,
                                                   marketRpc model "btc" "xusd" ]
                                                    )
        Ask ->
            ( Debug.log "model" model, graphdata () )
        Noop ->
            ( model, Cmd.none )


ws_parse : String -> Msg
ws_parse str =
  case (Debug.log "ws" str) of
    "ab" -> Ask
    _ -> Noop

subscriptions : Model -> Sub Msg
subscriptions model =
  WebSocket.listen model.ws_url ws_parse

type alias Flags = { url : String }

init : Flags -> ( Model, Cmd Msg )
init flags =
    ( Model ((Debug.log "flags" flags).url) "2014",
      Cmd.batch [ setup (), send Init ] )

send : Msg -> Cmd Msg
send msg =
  Task.perform identity identity (Task.succeed msg)
