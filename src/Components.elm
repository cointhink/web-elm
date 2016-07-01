module Components exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)

navbar model = div [ class "navbar" ]
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
                    Html.input [
                            type' "email",
                            placeholder "username"
                          ]
                          [],
                    button [ ] [ text "Signin" ]
                  ]

chart = div [ id "chart" ] []

footer model = div [ class "footer" ]
                   [ text model.ws_url ]

view model = div [ class "main" ]
                 [
                   navbar model,
                   chart,
                   div [] [ img [ class "biglogo", src "assets/logo.svg" ] [] ],
                   div [] [ text "Cointhink is being rebuilt." ],
                   div [] [ text "Check back later." ],
                   footer model
                 ]
