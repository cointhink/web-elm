import Html exposing (div, span, text, img)
import Html.App exposing (beginnerProgram)
import Html.Attributes exposing (..)

main = beginnerProgram{view = view, model = "", update = update}

view model = div [ class "main" ]
                 [
                   div [] [ img [ class "biglogo", src "assets/logo-256.png" ] [] ],
                   div [] [ text "Cointhink is being rebuilt." ],
                   div [] [ text "Check back later." ]
                 ]

update msg model = ""
