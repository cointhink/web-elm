module Navbar.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode
import Navbar.Msg as Msg
import Navbar.Model as Model
import Proto.Account as Account
import Proto.Signin_email exposing (..)


view : Model.Model -> Html Msg.Msg
view model =
    div [ class "navarea" ]
        [ navbanner model
        , subnav model
        ]


navbanner model =
    div [ class "navbanner" ]
        [ span []
            [ img [ class "littlelogo", src "assets/logo.svg" ] []
            , a [ class "logolink", href "/" ]
                [ text "Cointhink" ]
            ]
        , span []
            [ userarea model
            ]
        ]


userarea : Model.Model -> Html Msg.Msg
userarea model =
    case model.account of
        Just account ->
            usercard account model.showUsercardMenu

        Nothing ->
            if model.netFail then
                text "-network fail-"
            else if model.hasToken then
                text "-signing in-"
            else
                loginForm model


loginForm : Model.Model -> Html Msg.Msg
loginForm model =
    Html.form
        [ onWithOptions
            "submit"
            { preventDefault = True, stopPropagation = False }
            (Json.Decode.succeed Msg.SigninEmailDone)
        ]
        [ Html.input [ placeholder "email", onInput Msg.SigninEmailChg ] []
        , button [] [ text "Sign in" ]
        , text model.signinEmailMessage
        ]


usercard : Account.Account -> Bool -> Html Msg.Msg
usercard account showMenu =
    div [ class "usercard" ]
        [ div [] [ text account.email ]
        , div [ class "arrowbox", onClick Msg.UsercardMenu ] [ span [ class "arrow-down" ] [] ]
        , div
            [ class
                (if showMenu then
                    "menu"
                 else
                    "menu-gone"
                )
            ]
            (usercardMenu showMenu)
        ]


usercardMenu show =
    case show of
        True ->
            [ div [ onClick Msg.LogoutButton ] [ text "sign out" ]
            ]

        False ->
            []


subnav model =
    case model.account of
        Just account ->
            div [ class "navbar" ]
                [ div [ class "list" ]
                    [ div []
                        [ a [ href "/schedules" ]
                            [ text "Schedules" ]
                        ]
                    , div []
                        [ a [ href "/algorithms" ]
                            [ text "Algorithms" ]
                        ]
                    , div []
                        [ a [ href "/exchanges" ]
                            [ text "Exchanges" ]
                        ]
                    ]
                ]

        Nothing ->
            span [] []
