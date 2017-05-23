module Schedules.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode
import Schedules.Msg as Msg exposing (..)
import Schedules.Model exposing (..)


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
        [ div [ class "centerblock" ] [ text "Your Schedules" ]
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
        [ button [ onClick Msg.ScheduleNewButton ] [ text "Add schedule" ] ]


algoNew model =
    div [ class "algorithm-add" ]
        [ Html.form
            [ class ""
            , onWithOptions
                "submit"
                { preventDefault = True, stopPropagation = False }
                (Json.Decode.succeed Msg.ScheduleNew)
            ]
            [ div [] [ text "Schedule an algorithm" ]
            , fieldset [ disabled (False) ]
                [ algoNewAlgorithm
                , algoNewExchange
                , algoNewMarket
                , algoNewAmount
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
        ]


algoNewExchange =
    div []
        [ Html.label [ for "f_exchange" ] [ text "Exchange: " ]
        , Html.select
            [ for "f_exchange"
            , onInput Msg.ScheduleNewExchange
            ]
            [ Html.option []
                [ text "Testing" ]
            , Html.option []
                [ text "Coinbase" ]
            , Html.option []
                [ text "Poloniex" ]
            ]
        , Html.input
            [ id "f_apikey"
            , placeholder "API Key"
            ]
            []
        ]


algoNewMarket =
    div []
        [ Html.label [ for "f_market" ] [ text "Market: " ]
        , Html.select [ for "f_market" ]
            [ Html.option []
                [ text "BTC/USD" ]
            , Html.option []
                [ text "ETH/USD" ]
            ]
        ]


algoNewAmount =
    div []
        [ Html.label [ for "f_sched" ] [ text "Amount: " ]
        , Html.input [ id "f_apikey", placeholder "USD" ] []
        ]


algoNewAlgorithm =
    div []
        [ Html.label [ for "f_sched" ] [ text "Algorithm: " ]
        , Html.select
            [ id "f_sched"
            , onInput Msg.ScheduleNewAlgorithm
            ]
            [ Html.option []
                [ text "BUY Weekly - Tuesday" ]
            , Html.option []
                [ text "BUY Weekly - Thursday" ]
            , Html.option []
                [ text "BUY Monthly" ]
            ]
        ]


algoUpdate model =
    div [ class "algorithm-add" ]
        [ Html.form
            [ class ""
            , onWithOptions
                "submit"
                { preventDefault = True, stopPropagation = False }
                (Json.Decode.succeed Msg.ScheduleUpdate)
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
