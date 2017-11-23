module Splash.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode
import Splash.Msg as Msg exposing (..)
import Splash.Model exposing (..)
import Proto.Signup_form_response exposing (..)
import Cointhink.Views exposing (..)


view : Model -> Html Msg
view model =
    Cointhink.Views.mainView (page model)


page model =
    let
        page_parts =
            case model.mode of
                ModeSplash ->
                    [ catchphrase, steps, screencap, signupButton ]

                ModeSignup ->
                    case model.account of
                        Just account ->
                            [ catchphrase, alreadLoggedIn ]

                        Nothing ->
                            [ catchphrase, signup model ]
    in
        div [ class "splash" ] page_parts


catchphrase =
    div [ class "catchphrase" ]
        [ text "Algorithm Buy/Sell Signals for Digital Currency" ]


alreadLoggedIn =
    div [ class "catchphrase" ]
        [ text "Sending you to the next station..." ]


steps =
    div [ class "steps" ]
        [ div [] [ text "1. Create an account" ]
        , div [] [ text "2. Select an alert algorithm" ]
        , div [] [ text "3. Select a coin to watch (BTC or ETH)" ]
        , div [] [ text "4. Get price alerts in email" ]
        ]


signupButton =
    button [ class "signupButton", onClick Msg.ShowSignup ] [ text "Sign up" ]


screencap =
    img [ src "assets/tworows.png" ] []


signup model =
    div [ class "signup" ]
        [ Html.form
            [ class (formClasses model [ "" ])
            , onWithOptions
                "submit"
                { preventDefault = True, stopPropagation = False }
                (Json.Decode.succeed SignupSend)
            ]
            [ div [] [ text "Create a new account" ]
            , fieldset [ disabled (isFormSent model) ]
                [ Html.input
                    [ placeholder "Name"
                    , autofocus True
                    , onInput Msg.SignupFullname
                    ]
                    []
                , Html.input
                    [ id "f_email"
                    , placeholder "Email address"
                    , onInput Msg.SignupEmail
                    ]
                    []
                , label [ for "f_email", class "error" ]
                    (case model.signup_response of
                        Just r ->
                            case r.ok of
                                True ->
                                    []

                                False ->
                                    case r.reason of
                                        SignupFormResponse_EmailAlert ->
                                            [ text r.message ]

                                        _ ->
                                            []

                        Nothing ->
                            []
                    )
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
        ]


formClasses : Model -> List String -> String
formClasses model base_classes =
    let
        in_flight =
            String.length model.signup_req_id > 0

        -- use a Maybe
        classes =
            if in_flight then
                "disabled" :: base_classes
            else
                base_classes
    in
        String.join " " classes
