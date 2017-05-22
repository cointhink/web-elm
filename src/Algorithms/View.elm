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
        , algoAddButton
        ]


algoList =
    div [ class "" ]
        [ ul []
            [ li [] [ text "one" ]
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
            [ div [] [ text "Setup a new algorithm" ]
            , fieldset [ disabled (False) ]
                [ Html.label [ for "f_exchange" ] [ text "Exchange: " ]
                , Html.select [ for "f_exchange" ]
                    [ Html.option []
                        [ text "Coinbase" ]
                    , Html.option []
                        [ text "Poloniex" ]
                    ]
                , Html.input
                    [ id "f_apikey"
                    , placeholder "API Key"
                    ]
                    []
                , div []
                    [ Html.label [ for "f_market" ] [ text "Market: " ]
                    , Html.select [ for "f_market" ]
                        [ Html.option []
                            [ text "BTC/USD" ]
                        , Html.option []
                            [ text "ETH/USD" ]
                        ]
                    ]
                , div []
                    [ Html.label [ for "f_sched" ] [ text "Amount: " ]
                    , Html.input [ id "f_apikey", placeholder "USD" ] []
                    ]
                , div []
                    [ Html.label [ for "f_sched" ] [ text "Schedule: " ]
                    , Html.select [ id "f_sched" ]
                        [ Html.option []
                            [ text "Weekly" ]
                        , Html.option []
                            [ text "Monthly" ]
                        ]
                    ]
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
