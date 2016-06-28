import Html exposing (..)
import Html.App exposing (beginnerProgram)
import Html.Attributes exposing (..)

main = beginnerProgram{view = view, model = "", update = update}

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

view model = div [ class "main" ]
                 [
                   navbar,
                   div [] [ img [ class "biglogo", src "assets/logo.svg" ] [] ],
                   div [] [ text "Cointhink is being rebuilt." ],
                   div [] [ text "Check back later." ]
                 ]

update msg model = ""
