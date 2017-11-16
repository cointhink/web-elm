module Schedules.View exposing (view)

import Dict
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
import Proto.Account exposing (..)
import Date.Extra
import Date.Format


view : Model -> Html Msg
view model =
    Cointhink.Views.mainView (page model)


page model =
    div []
        [ div [ class "top-notice" ] [ text model.top_notice ]
        , case model.account of
            Just account ->
                case model.mode of
                    Msg.ModeList ->
                        items model.schedule_runs account

                    Msg.ModeAdd ->
                        itemNew model account

                    Msg.ModeUpdate ->
                        itemUpdate model

                    Msg.ModeView ->
                        itemView model

            Nothing ->
                plzlogin
        ]


items schedule_runs account =
    div [ class "" ]
        [ div [ class "centerblock" ] [ text "Your Schedules" ]
        , algoList schedule_runs
        , creditRow account
        ]


algoList : List ScheduleRun -> Html Msg
algoList schedule_runs =
    div [ class "list-schedules" ]
        (if List.isEmpty schedule_runs then
            [ div [ class "empty-schedules" ]
                [ div []
                    [ text "Head over to "
                    , a [ href "/algorithms" ] [ text "Algorithms" ]
                    , text " to choose something. "
                    ]
                ]
            ]
         else
            (List.map algoListRow schedule_runs)
        )


algoListRow : ScheduleRun -> Html Msg
algoListRow sr =
    case sr.schedule of
        Just s ->
            algoListHtml s sr.run

        Nothing ->
            text "list err"


creditRow : Account -> Html Msg
creditRow account =
    div []
        [ div [ class "list-row-back list-schedules-notice" ]
            [ div [ class "list-row list-row-ad" ]
                [ div [ class "list-row-ad-text" ]
                    [ text ("Unused schedule credits: " ++ (toString account.scheduleCredits) ++ ".") ]
                , (if account.scheduleCredits < 6 then
                    div [ class "list-row-ad-pay" ]
                        [ button [ onClick Msg.StripePay ]
                            [ text "Add a schedule credit for $2" ]
                        ]
                   else
                    div [ class "" ]
                        []
                  )
                ]
            ]
        , div [ id "card-container", class "card-inactive" ]
            [ div [ class "stripe-row" ]
                [ text "Add a schedule credit for $2."
                , img [ src "/assets/powered_by_stripe.svg" ] []
                ]
            , div []
                [ text " Most algorithms use up one schedule credit per month."
                ]
            , div [ class "small-print" ]
                [ text "* Schedule credits have no cash value and are non-refundable. Limit 6 credits per account."
                ]
            , div [ id "card-element" ]
                []
            , div [ id "card-note" ]
                [ text "* Payments are in test mode. Your card will not be charged." ]
            ]
        ]


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
                            "stopped"

                        Schedule_Enabled ->
                            "started"

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
                [ amountFormat s.initialState ]
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
            , div [ class "list-enabled-until" ]
                [ (case Date.Extra.fromIsoString s.enabledUntil of
                    Just time ->
                        text ("until " ++ (Date.Format.format "%b-%d" time))

                    Nothing ->
                        text "?"
                  )
                ]
            , div [ class "list-algorithm-admin" ]
                (case s.status of
                    Schedule_Disabled ->
                        [ a
                            [ onClick (Msg.ScheduleDelete s.id)
                            , href "#"
                            , title "Delete this schedule permanently"
                            ]
                            [ text "x" ]
                        ]

                    _ ->
                        []
                )
            ]
        ]


amountFormat state =
    let
        amount =
            pluckField "Amount" state

        label =
            if String.length amount > 0 then
                ("$" ++ amount)
            else
                ""
    in
        text label


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


itemNew : Model -> Account -> Html Msg
itemNew model account =
    div [ class "item-add" ]
        [ Html.form
            [ class ""
            , onWithOptions
                "submit"
                { preventDefault = True, stopPropagation = False }
                (JD.succeed Msg.ScheduleNew)
            ]
            [ div [ class "centerblock" ] [ text "Run an algorithm" ]
            , fieldset [ disabled (False) ] (algoNewFields model)
            , (if account.scheduleCredits > 0 then
                button []
                    [ text
                        (if isFormSent model then
                            "Sending..."
                         else
                            "Submit (uses 1 schedule credit)"
                        )
                    ]
               else
                text "No schedule credits left."
              )
            , div []
                [ text
                    ("Current balance: "
                        ++ (toString account.scheduleCredits)
                        ++ " schedule credit."
                    )
                ]
            ]
        ]


algoNewFields : Model -> List (Html Msg)
algoNewFields model =
    case model.schedule_new_algorithm of
        Just algo ->
            schemaToFields model algo.schema

        Nothing ->
            [ text "loading" ]


schemaToFields model json =
    case JD.decodeString (JD.dict schemaDecoder) json of
        Ok items ->
            Dict.values (Dict.map (schemaTypeToHtml model) items)

        Err err ->
            [ text ("json err Z" ++ json ++ "Z" ++ err) ]


schemaDecoder =
    JD.map3 SchemaRecord
        (JD.field "type" JD.string)
        (JD.field "default" JD.string)
        (JD.field "display" JD.string)


type alias SchemaRecord =
    { type_ : String
    , default : String
    , display : String
    }


schemaTypeToHtml model fieldName record =
    case record.type_ of
        "exchange" ->
            algoNewExchange model fieldName record

        "market" ->
            algoNewMarket model fieldName record

        "currency" ->
            algoNewCurrency fieldName record

        "percent" ->
            algoNewPercent fieldName record

        "float" ->
            algoNewFloat fieldName record

        _ ->
            text "?"


algoNewExchange model storageFieldName schemaRecord =
    let
        storageValue =
            case Dict.get storageFieldName model.schedule_new_initial_values of
                Just value ->
                    value

                Nothing ->
                    ""
    in
        div []
            [ Html.label [ for "f_exchange" ] [ text (schemaRecord.display ++ ": ") ]
            , Html.select
                [ for "f_exchange"
                , onInput (Msg.ScheduleSelectField storageFieldName)
                ]
                [ Html.option [ selected (storageValue == ""), value "" ]
                    [ text "- Select Exchange -" ]
                , Html.option
                    [ selected (storageValue == "coinmarketcap")
                    , value "coinmarketcap"
                    , selected True
                    ]
                    [ text "CoinMarketCap (Data Feed)" ]
                ]
            ]


algoNewMarket model storageFieldName schemaRecord =
    let
        storageValue =
            case Dict.get storageFieldName model.schedule_new_initial_values of
                Just value ->
                    value

                Nothing ->
                    ""
    in
        div []
            [ Html.label [ for "f_market" ] [ text (schemaRecord.display ++ ": ") ]
            , Html.select
                [ for "f_market"
                , onInput (Msg.ScheduleSelectField storageFieldName)
                ]
                [ Html.option
                    [ selected (storageValue == "")
                    , value ""
                    ]
                    [ text "- Select Market -" ]
                , Html.option
                    [ selected (storageValue == "btc/usd")
                    , value "btc/usd"
                    ]
                    [ text "BTC/USD" ]
                , Html.option
                    [ selected (storageValue == "eth/usd")
                    , value "eth/usd"
                    ]
                    [ text "ETH/USD" ]
                ]
            ]


algoNewCurrency storageFieldName schemaRecord =
    div
        [ for "f_market"
        , onInput (Msg.ScheduleSelectField storageFieldName)
        ]
        [ Html.label [ for "f_amount" ] [ text (schemaRecord.display ++ ": $") ]
        , Html.input [ id "f_amount", class "usd", placeholder "USD" ] []
        ]


algoNewPercent storageFieldName schemaRecord =
    div
        [ for "f_market"
        , onInput (Msg.ScheduleSelectField storageFieldName)
        ]
        [ Html.label [ for "f_amount" ] [ text (schemaRecord.display ++ ": ") ]
        , Html.input [ id "f_amount", class "usd", placeholder "" ] []
        , text "%"
        ]


algoNewFloat storageFieldName schemaRecord =
    div
        [ for "f_float"
        , onInput (Msg.ScheduleSelectField storageFieldName)
        ]
        [ Html.label [ for "f_amount" ] [ text (schemaRecord.display ++ ": ") ]
        , Html.input [ id "f_amount", class "usd", placeholder "" ] []
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
                [ (case Date.Extra.fromIsoString log.createdAt of
                    Just time ->
                        text (Date.Format.format "%b-%d %l:%M%P" time)

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
