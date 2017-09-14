module Cointhink.Views exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


mainView mainDiv =
    div []
        [ mainDiv
        , pageFoot
        ]


pageFoot =
    footer []
        [ div [] [ text "Cointhink (C) 2017" ]
        , div [ class "spacer" ] [ text " • " ]
        , div []
            [ a [ href "/terms" ] [ text "Terms" ]
            ]
        ]
