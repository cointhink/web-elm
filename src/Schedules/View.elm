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
import Proto.Schedule_run exposing (..)
import Proto.Algorun exposing (..)
import Proto.Algolog exposing (..)
import Date.Extra as Date


view : Model -> Html Msg
view model =
    Cointhink.Views.mainView (page model)


page model =
    case model.account of
        Just account ->
            case model.mode of
                Msg.ModeList ->
                    items model.schedule_runs

                Msg.ModeAdd ->
                    itemNew model

                Msg.ModeUpdate ->
                    itemUpdate model

                Msg.ModeView ->
                    itemView model

        Nothing ->
            plzlogin


items schedule_runs =
    div [ class "" ]
        [ algoAddButton
        , div [ class "centerblock" ] [ text "Your Schedules" ]
        , algoList schedule_runs
        ]


algoList : List ScheduleRun -> Html Msg
algoList schedule_runs =
    div [ class "list-schedules" ]
        (List.map algoListRow schedule_runs)


algoListRow : ScheduleRun -> Html Msg
algoListRow sr =
    case sr.schedule of
        Just s ->
            algoListHtml s sr.run

        Nothing ->
            text "list err"


algoListHtml s runMaybe =
    div [ class ("list-row-back " ++ (algoListClasses s.status runMaybe)) ]
        [ li [ class "list-row" ]
            [ div [ class "list-algorithm-algo" ]
                [ a
                    [ onClick
                        (Msg.AlgorunView
                            (case runMaybe of
                                Just run ->
                                    run.id

                                Nothing ->
                                    ""
                            )
                        )
                    , class
                        (case runMaybe of
                            Just run ->
                                "href"

                            Nothing ->
                                ""
                        )
                    ]
                    [ text s.algorithmId ]
                ]
            , div [ class "list-algorithm-status" ]
                [ text
                    ((case s.status of
                        Schedule_Disabled ->
                            "disabled"

                        Schedule_Enabled ->
                            "enabled"

                        Schedule_Deleted ->
                            "deleted"

                        Schedule_Unknown ->
                            "unknown"
                     )
                        ++ (case runMaybe of
                                Just run ->
                                    "/" ++ run.status

                                Nothing ->
                                    ""
                           )
                    )
                ]
            , div [ class "list-algorithm-exchange" ]
                [ text (pluckField "Exchange" s.initialState) ]
            , div [ class "list-algorithm-market" ]
                [ text (pluckField "Market" s.initialState) ]
            , div [ class "list-algorithm-amount" ]
                [ text ("$" ++ (pluckField "Amount" s.initialState)) ]
            , div [ class "list-algorithm-controls" ]
                ((case s.status of
                    Schedule_Disabled ->
                        button [ onClick (Msg.ScheduleStart s.id) ]
                            [ text "start" ]

                    Schedule_Enabled ->
                        button [ onClick (Msg.ScheduleStop s.id) ]
                            [ text "stop" ]

                    Schedule_Deleted ->
                        text "?"

                    Schedule_Unknown ->
                        text "?"
                 )
                    :: []
                )
            , div [ class "list-algorithm-admin" ]
                (case s.status of
                    Schedule_Disabled ->
                        [ a [ onClick (Msg.ScheduleDelete s.id), href "#" ] [ text "x" ] ]

                    _ ->
                        []
                )
            ]
        ]


algoListClasses : Schedule_States -> Maybe Algorun -> String
algoListClasses status runMaybe =
    let
        runName =
            case runMaybe of
                Just run ->
                    run.status

                Nothing ->
                    ""

        statusName =
            case status of
                Schedule_Unknown ->
                    "list-schedules-unknown"

                Schedule_Deleted ->
                    "list-schedules-unknown"

                Schedule_Disabled ->
                    "list-schedules-disabled"

                Schedule_Enabled ->
                    "list-schedules-enabled"
    in
        statusName ++ "-" ++ runName


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
            [ div [ class "centerblock" ] [ text "Run an algorithm" ]
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
                , selected True
                ]
                [ text "Simulation Exchange" ]

            --, Html.option
            --    [ selected (model.schedule_state.exchange == "coinbase")
            --    , value "coinbase"
            --    ]
            --    [ text "Coinbase" ]
            --, Html.option
            --    [ selected (model.schedule_state.exchange == "poloniex")
            --    , value "poloniex"
            --    ]
            --    [ text "Poloniex" ]
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
        , text model.schedule.algorithmId
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


itemView : Model -> Html Msg
itemView model =
    div [ class "item-view" ]
        [ div [ class "algolog-list-head" ]
            [ text
                model.algorun.id
            ]
        , div [ class "algolog-list" ]
            (div [] [ text "Log" ]
                :: (List.map
                        algologRow
                        model.algorun_logs
                   )
            )
        ]


algologRow : Algolog -> Html Msg
algologRow log =
    div [ class "algolog-row" ]
        [ div [ class "algolog-createdat" ]
            [ time [ datetime log.createdAt ]
                [ (case Date.fromIsoString log.createdAt of
                    Just time ->
                        text (Date.toFormattedString "M-d h:m" time)

                    Nothing ->
                        text "?"
                  )
                ]
            ]
        , div [ class "algolog-level" ] [ text log.level ]
        , div [] [ text log.message ]
        ]


plzlogin =
    div [ class "catchphrase" ]
        [-- text "Login to begin."
        ]
