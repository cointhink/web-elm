module Exchanges.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode
import Exchanges.Msg as Msg
import Exchanges.Model exposing (..)
import Cointhink.Views exposing (..)


view : Model -> Html Msg.Msg
view model =
    Cointhink.Views.mainView (page model)


page model =
    case model.account of
        Just account ->
            case model.mode of
                Msg.ModeList ->
                    exchanges

                Msg.ModeAdd ->
                    exchangeNew model

        Nothing ->
            plzlogin


exchanges =
    div [ class "" ]
        [ div [ class "centerblock" ] [ text "Connected Exchanges" ]
        , exchangeList

        --, exchangeAddButton
        ]


exchangeList =
    div [ class "" ]
        [ ul []
            [ li [] [ text "simulation exchange" ]
            ]
        ]


exchangeAddButton =
    div [ class "" ]
        [ button [ onClick Msg.ExchangeNew ] [ text "Connect an exchange" ] ]


exchangeNew model =
    div [ class "exchange-add" ]
        [ Html.form
            [ class ""
            , onWithOptions
                "submit"
                { preventDefault = True, stopPropagation = False }
                (Json.Decode.succeed Msg.ExchangeSend)
            ]
            [ div [] [ text "Connect to an exchange" ]
            , fieldset [ disabled (False) ]
                [ Html.select []
                    [ Html.option []
                        [ text "Coinbase" ]
                    , Html.option []
                        [ text "Poloniex" ]
                    ]
                , Html.input
                    [ id "f_apikey"
                    , placeholder "API Key"
                    , onInput Msg.ExchangeNewApiKey
                    ]
                    []
                ]
            ]
        , button []
            [ text
                (if False then
                    "Sending..."
                 else
                    "Save"
                )
            ]
        ]


plzlogin =
    div [ class "catchphrase" ]
        [ text "Login to begin." ]
