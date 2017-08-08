module Algorithms.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode
import Algorithms.Msg as Msg exposing (..)
import Algorithms.Model exposing (..)
import Cointhink.Views exposing (..)


view : Model -> Html Msg
view model =
    Cointhink.Views.mainView (page model)


page model =
    case model.account of
        Just account ->
            case model.mode of
                Msg.ModeList ->
                    algos model

                Msg.ModeAdd ->
                    algoNew model

                Msg.ModeUpdate ->
                    algoUpdate model

        Nothing ->
            plzlogin


algos model =
    div [ class "" ]
        [ div [ class "centerblock" ] [ text "Available Algorithms" ]
        , algoList model

        --, algoAddButton
        ]


algoList model =
    div [ class "algo-list" ]
        [ ul []
            (List.map
                algorithmRow
                model.algorithms
            )
        ]


algorithmRow algorithm =
    li []
        [ div [ class "flexrow" ]
            [ span [ class "algo-name" ] [ text "Weekly-Tue" ]
            , span [ class "algo-owner" ] [ text "Cointhink" ]
            ]
        , div [ class "algo-description" ] [ text "Issue a buy order on each Tuesday." ]
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
        [--text "Login to begin."
        ]
