import Html exposing (div, span, text, img)
import Html.App exposing (beginnerProgram)
import Html.Attributes exposing (..)

main = beginnerProgram{view = view, model = "", update = update}

navbar = div [ class "navbar" ]
             [
               span [] [ text "abc" ]
             ]

view model = div [ class "main" ]
                 [
                   navbar,
                   div [] [ img [ class "biglogo", src "assets/logo.svg" ] [] ],
                   div [] [ text "Cointhink is being rebuilt." ],
                   div [] [ text "Check back later." ]
                 ]

update msg model = ""
