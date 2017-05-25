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
                    items model.schedules

                Msg.ModeAdd ->
                    itemNew model

                Msg.ModeUpdate ->
                    itemUpdate model

        Nothing ->
            plzlogin


items schedules =
    div [ class "" ]
        [ div [ class "centerblock" ] [ text "Your Schedules" ]
        , algoList schedules
        , algoAddButton
        ]


algoList schedules =
    div [ class "" ]
        [ ul []
            (List.map
                (\s -> li [] [ text s.status ])
                schedules
            )
        ]


algoAddButton =
    div [ class "" ]
        [ button [ onClick Msg.ScheduleAdd ] [ text "Add schedule" ] ]


itemNew model =
    div [ class "item-add" ]
        [ Html.form
            [ class ""
            , onWithOptions
                "submit"
                { preventDefault = True, stopPropagation = False }
                (Json.Decode.succeed Msg.ScheduleNew)
            ]
            [ div [] [ text "Schedule an algorithm" ]
            , fieldset [ disabled (False) ]
                [ algoNewAlgorithm model
                , algoNewExchange
                , algoNewMarket
                , algoNewAmount
                ]
            , button []
                [ text
                    (if isFormSent model then
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
            [ Html.option [ value "simulation" ]
                [ text "Simulation Exchange" ]
            , Html.option [ value "coinbase" ]
                [ text "Coinbase" ]
            , Html.option [ value "poloniex" ]
                [ text "Poloniex" ]
            ]
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
        [ Html.label [ for "f_amount" ] [ text "Amount: $" ]
        , Html.input [ id "f_amount", class "usd", placeholder "USD" ] []
        ]


algoNewAlgorithm model =
    div []
        [ Html.label [ for "f_sched" ] [ text "Algorithm: " ]
        , Html.select
            [ id "f_sched"
            , onInput Msg.ScheduleNewAlgorithm
            ]
            [ Html.option [ selected (model.schedule.algorithmId == "noop") ] [ text "- Select Algorithm -" ]
            , Html.option
                [ selected (model.schedule.algorithmId == "buy-weekly-tue")
                , value "buy-weekly-tue"
                ]
                [ text "BUY Weekly - Tuesday" ]
            , Html.option
                [ selected (model.schedule.algorithmId == "buy-weekly-thur")
                , value "buy-weekly-thur"
                ]
                [ text "BUY Weekly - Thursday" ]
            , Html.option
                [ selected (model.schedule.algorithmId == "buy-monthly")
                , value "buy-monthly"
                ]
                [ text "BUY Monthly" ]
            ]
        ]


itemUpdate model =
    div [ class "item-update" ]
        [ Html.form
            [ class ""
            , onWithOptions
                "submit"
                { preventDefault = True, stopPropagation = False }
                (Json.Decode.succeed Msg.ScheduleUpdate)
            ]
            [ div [] [ text "Update the " ]
            , fieldset [ disabled (False) ]
                []
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
