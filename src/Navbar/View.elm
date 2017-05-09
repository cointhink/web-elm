module Navbar.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)

view model =
  div [ class "navbar" ]
      [
        span [ class "menuitem" ]
             [
               img [ class "littlelogo", src "assets/logo.svg" ] [],
               a [ href "/" ]
                 [ text "Cointhink" ]
             ],
        span [ class "menuitem" ]
             [
               login model
             ]
      ]

login model =
  case model.account of
    Just account ->
      text account.email
    Nothing ->
      Html.form []
                [
                  Html.input [
                          type_ "email",
                          placeholder "email"
                        ]
                        [],
                  button [ ] [ text "Sign in" ]
                ]
