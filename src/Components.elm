module Components exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import String exposing (toUpper)

navbar model =
  div [ class "navbar" ]
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

login =
  Html.form []
            [
              Html.input [
                      type' "email",
                      placeholder "username"
                    ]
                    [],
              button [ ] [ text "Signin" ]
            ]

chartZone model =
  div [ id "chartZone" ]
      [
        span [ class "pairtitle" ]
             [
                text (toUpper model.base),
                text "/",
                text (toUpper model.quote)
             ],
        chart
      ]

chart =
  div [ id "chart" ] []

centerBlock =
  div [ id "centerblock" ]
      [
        div [] [ img [ class "biglogo", src "assets/logo.svg" ] [] ],
        div [] [ text "Cointhink is being rebuilt." ],
        div [] [ text "Check back later." ]
      ]

footer model =
  div [ class "footer" ]
      [  ]

view model =
 div [ class "main" ]
     [
       navbar model,
       chartZone model,
       centerBlock,
       footer model
     ]
