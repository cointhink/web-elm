module Navbar.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Navbar.Msg as Msg
import Navbar.Model as Model
import Proto.Account as Account


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
            , a [ href "/" ]
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
            if model.hasToken then
                text "-signing in-"
            else
                loginForm


loginForm =
    Html.form []
        [ Html.input [ placeholder "email" ] []
        , button [] [ text "Sign in" ]
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
                    [ div [] [ text "Markets" ]
                    , div [] [ text "Code" ]
                    ]
                ]

        Nothing ->
            span [] []
