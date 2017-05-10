module Navbar.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Navbar.Msg as Msg
import Navbar.Model as Model
import Proto.Account as Account

view : Model.Model -> Html Msg.Msg
view model =
  div [ class "navbar" ]
    [ navdisplay model,
      subnav model
    ]

navdisplay model =
  div [ class "navdisplay" ]
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


userarea : Model.Model -> Html Msg.Msg
userarea model =
  case model.account of
    Just account ->
      usercard account
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

usercard : Account.Account -> Html Msg.Msg
usercard account =
  div []
      [ text account.email,
        div [ onClick Msg.LogoutButton ] [ text "logout" ]
      ]

subnav model =
  case model.account of
    Just account ->
      div [ class "subnav" ]
          [
            div [ class "list" ] [
                div [] [text "Markets"],
                div [] [text "Code"]
              ]
          ]
    Nothing ->
      span [] []
