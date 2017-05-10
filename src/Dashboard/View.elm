module Dashboard.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode

import Dashboard.Msg exposing (..)
import Dashboard.Model exposing (..)

view : Model -> Html Msg
view model =
  div [ class "catchphrase" ]
      [ text "Welcome to cointhink." ]

