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
               login
             ]
      ]

login =
  Html.form []
            [
              Html.input [
                      type_ "email",
                      placeholder "email"
                    ]
                    [],
              button [ ] [ text "Sign in" ]
            ]
