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
            algos

        Nothing ->
            plzlogin


algos =
    div [ class "" ]
        [ div [ class "centerblock" ] [ text "Your Algorithms" ]
        , algoList
        ]


algoList =
    div [ class "" ]
        [ ul []
            [ li [] [ text "one" ]
            ]
        ]


plzlogin =
    div [ class "catchphrase" ]
        [ text "Login to begin." ]
