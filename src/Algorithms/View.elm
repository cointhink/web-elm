module Algorithms.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode
import Algorithms.Msg exposing (..)
import Algorithms.Model exposing (..)


view : Model -> Html Msg
view model =
    case model.account of
        Just account ->
            welcome

        Nothing ->
            plzlogin


welcome =
    div [ class "catchphrase" ]
        [ text "Welcome to cointhink." ]


plzlogin =
    div [ class "catchphrase" ]
        [ text "Login to begin." ]
