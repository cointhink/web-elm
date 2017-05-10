module Navbar.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Navbar.Msg as Msg

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
               userarea model
             ]
      ]

userarea model =
  case model.account of
    Just account ->
      text account.email
    Nothing ->
      if model.hasToken then
        text "logging in"
      else
        Html.form []
                [
                  Html.input [
                          type_ "email",
                          placeholder "email"
                        ]
                        [],
                  button [ ] [ text "Sign in" ]
                ]

usercard account =
  div []
      [ account.email,
        span [ onClick Msg.LogoutButton ] [ text "logout" ]
      ]
