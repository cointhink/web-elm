module Schedules.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as JD
import Json.Encode as JE
import Schedules.Msg as Msg exposing (..)
import Schedules.Model exposing (..)
import Cointhink.Views exposing (..)
import Proto.Schedule exposing (..)


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


algoList : List Schedule -> Html Msg
algoList schedules =
    div [ class "list-schedules" ]
        (List.map algoListRow schedules)


algoListRow : Schedule -> Html Msg
algoListRow s =
    div [ class ("list-row-back " ++ (algoListClasses s)) ]
        [ li [ class "list-row" ]
            [ div [ class "list-algorithm-algo" ]
                [ text s.algorithmId ]
            , div [ class "list-algorithm-status" ]
                [ text "s.status" ]
            , div [ class "list-algorithm-exchange" ]
                [ text (pluckField "Exchange" s.initialState) ]
            , div [ class "list-algorithm-market" ]
                [ text (pluckField "Market" s.initialState) ]
            , div [ class "list-algorithm-amount" ]
                [ text ("$" ++ (pluckField "Amount" s.initialState)) ]
            , div [ class "list-algorithm-controls" ]
                ((case s.status of
                    Schedule_Stopped ->
                        button [ onClick (Msg.ScheduleStart s.id) ]
                            [ text "start" ]

                    Schedule_Running ->
                        button [ onClick (Msg.ScheduleStop s.id) ]
                            [ text "stop" ]

                    Schedule_Unknown ->
                        text "?"
                 )
                    :: []
                )
            , div [ class "list-algorithm-admin" ]
                [ a [ onClick (Msg.ScheduleStop s.id), href "#" ] [ text "x" ] ]
            ]
        ]


algoListClasses s =
    case s.status of
        Schedule_Unknown ->
            "list-schedules-unknown"

        Schedule_Stopped ->
            "list-schedules-stopped"

        Schedule_Running ->
            "list-schedules-running"


pluckField name object =
    (Result.withDefault
        "?"
        (JD.decodeString (JD.field name JD.string) object)
    )


algoAddButton =
    div [ class "floatAdd" ]
        [ button [ onClick Msg.ScheduleAdd ] [ text "+" ] ]


itemNew : Model -> Html Msg
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
