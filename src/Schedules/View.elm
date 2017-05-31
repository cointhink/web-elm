module Schedules.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as JD
import Schedules.Msg as Msg exposing (..)
import Schedules.Model exposing (..)
import Cointhink.Views exposing (..)


view : Model -> Html Msg
view model =
    Cointhink.Views.mainView (page model)


page model =
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
        [ algoAddButton
        , div [ class "centerblock" ] [ text "Your Schedules" ]
        , algoList schedules
        ]


algoList schedules =
    div [ class "list-schedules" ]
        [ ul []
            (List.map
                (\s ->
                    li [ class "list-row" ]
                        [ div [ class "list-algorithm-algo" ] [ text s.algorithmId ]
                        , div [ class "list-algorithm-status" ] [ text s.status ]
                        , div [ class "list-algorithm-exchange" ]
                            [ text
                                (Result.withDefault
                                    "?"
                                    (JD.decodeString (JD.field "Exchange" JD.string) s.initialState)
                                )
                            ]
                        ]
                )
                schedules
            )
        ]


algoAddButton =
    div [ class "floatAdd" ]
        [ button [ onClick Msg.ScheduleAdd ] [ text "+" ] ]


itemNew model =
    div [ class "item-add" ]
        [ Html.form
            [ class ""
            , onWithOptions
                "submit"
                { preventDefault = True, stopPropagation = False }
                (JD.succeed Msg.ScheduleNew)
            ]
            [ div [] [ text "Schedule an algorithm" ]
            , fieldset [ disabled (False) ]
                [ algoNewAlgorithm model
                , algoNewExchange model
                , algoNewMarket model
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


algoNewExchange model =
    div []
        [ Html.label [ for "f_exchange" ] [ text "Exchange: " ]
        , Html.select
            [ for "f_exchange"
            , onInput Msg.ScheduleSelectExchange
            ]
            [ Html.option [ selected (model.schedule_state.exchange == ""), value "" ]
                [ text "- Select Exchange -" ]
            , Html.option
                [ selected (model.schedule_state.exchange == "simulation")
                , value "simulation"
                ]
                [ text "Simulation Exchange" ]
            , Html.option
                [ selected (model.schedule_state.exchange == "coinbase")
                , value "coinbase"
                ]
                [ text "Coinbase" ]
            , Html.option
                [ selected (model.schedule_state.exchange == "poloniex")
                , value "poloniex"
                ]
                [ text "Poloniex" ]
            ]
        ]


algoNewMarket model =
    div []
        [ Html.label [ for "f_market" ] [ text "Market: " ]
        , Html.select
            [ for "f_market"
            , onInput Msg.ScheduleSelectMarket
            ]
            [ Html.option
                [ selected (model.schedule_state.market == "")
                , value ""
                ]
                [ text "- Select Market -" ]
            , Html.option
                [ selected (model.schedule_state.market == "btc/usd")
                , value "btc/usd"
                ]
                [ text "BTC/USD" ]
            , Html.option
                [ selected (model.schedule_state.market == "eth/usd")
                , value "eth/usd"
                ]
                [ text "ETH/USD" ]
            ]
        ]


algoNewAmount =
    div
        [ for "f_market"
        , onInput Msg.ScheduleSelectAmount
        ]
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
                (JD.succeed Msg.ScheduleUpdate)
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
