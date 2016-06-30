port module Cointhink exposing (navbar, login, view, update)

import Html exposing (..)
import Html.Attributes exposing (..)

port output : () -> Cmd msg

navbar = div [ class "navbar" ]
             [
               span [ class "menuitem" ]
                    [
                      img [ class "littlelogo", src "assets/logo.svg" ] [],
                      text "Cointhink"
                    ],
               span [ class "menuitem" ]
                    [
                      login
                    ]

             ]

login = Html.form []
                  [
                    input [
                            type' "email",
                            placeholder "username"
                          ]
                          [],
                    button [ ] [ text "Signin" ]
                  ]

chart = div [ id "chart" ] []

view model = div [ class "main" ]
                 [
                   navbar,
                   chart,
                   div [] [ img [ class "biglogo", src "assets/logo.svg" ] [] ],
                   div [] [ text "Cointhink is being rebuilt." ],
                   div [] [ text "Check back later." ]
                 ]

update msg model = (model, output () )
