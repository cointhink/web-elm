import Html exposing (div, span, text)
import Html.App exposing (beginnerProgram)
import Html.Attributes exposing (..)

main = beginnerProgram{view = view, model = "", update = update}

view model = div [ class "bob" ] [ text "hi" ]

update msg model = ""
