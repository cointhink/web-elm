module Algorithms.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode
import Algorithms.Msg as Msg exposing (..)
import Algorithms.Model exposing (..)


view : Model -> Html Msg
view model =
    case model.account of
        Just account ->
            case model.mode of
                Msg.ModeList ->
                    algos

                Msg.ModeAdd ->
                    algoNew model

                Msg.ModeUpdate ->
                    algoUpdate model

        Nothing ->
            plzlogin


algos =
    div [ class "" ]
        [ div [ class "centerblock" ] [ text "Your Algorithms" ]
        , algoList

        --, algoAddButton
        ]


algoList =
    div [ class "" ]
        [ ul []
            [ li []
                [ div [ class "flexrow" ]
                    [ span [ class "algo-name" ] [ text "Weekly-Tue" ]
                    , span [] [ text "Cointhink" ]
                    ]
                ]
            , li []
                [ div [ class "flexrow" ]
                    [ span [ class "algo-name" ] [ text "Weekly-Thur" ]
                    , span [] [ text "Cointhink" ]
                    ]
                ]
            , li []
                [ div [ class "flexrow" ]
                    [ span [ class "algo-name" ] [ text "Monthly" ]
                    , span [] [ text "Cointhink" ]
                    ]
                ]
            ]
        ]


algoAddButton =
    div [ class "" ]
        [ button [ onClick Msg.AlgorithmNewButton ] [ text "Add algorithm" ] ]


algoNew model =
    div [ class "algorithm-add" ]
        [ Html.form
            [ class ""
            , onWithOptions
                "submit"
                { preventDefault = True, stopPropagation = False }
                (Json.Decode.succeed Msg.AlgorithmUpdate)
            ]
            [ div [] [ text "Add an algorithm" ]
            , fieldset [ disabled (False) ]
                [ algoNewName
                ]
            ]
        , button []
            [ text
                (if False then
                    "Sending..."
                 else
                    "Add"
                )
            ]
        ]


algoNewName =
    div []
        [ Html.label [ for "f_exchangecode" ] [ text "name: " ]
        , Html.input [ for "f_code" ] []
        ]


algoUpdate model =
    div [ class "algorithm-add" ]
        [ Html.form
            [ class ""
            , onWithOptions
                "submit"
                { preventDefault = True, stopPropagation = False }
                (Json.Decode.succeed Msg.AlgorithmUpdate)
            ]
            [ div [] [ text "Update the algorithm" ]
            , fieldset [ disabled (False) ]
                [ Html.textarea
                    [ id "f_code"
                    , placeholder "Code"
                    ]
                    []
                ]
            ]
        , button []
            [ text
                (if False then
                    "Sending..."
                 else
                    "Submit"
                )
            ]
        ]


plzlogin =
    div [ class "catchphrase" ]
        [ text "Login to begin." ]
