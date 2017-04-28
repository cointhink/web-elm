module Splash.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode

import Splash.Msg exposing (Msg)
import Splash.Model exposing (Model)

view : Model -> Html Msg
view model =
 div [ class "splash" ]
     [ catchphrase,
       steps,
       signup ]

catchphrase =
  div [ class "catchphrase" ]
      [ text "Buy cryptocoins on your schedule." ]

steps =
  div [ class "steps" ]
      [ div [] [ text "1. Connect your exchange account" ],
        div [] [ text "2. Set a purchasing schedule" ],
        div [] [ text "3. Have Bitcoins and other cryptocoins purchased automatically" ]
      ]

signup =
  div [ class "signup" ]
      [
        Html.form [ action "javascript:void(0);"
                    --onWithOptions
                    --  "submit"
                    --  { preventDefault = True, stopPropagation = False }
                    --  ( Json.Decode.succeed Nothing )
                  ]
             [
               text "Get started by signing up.",
               Html.input [ type_ "email", placeholder "email address"] [],
               button [ onClick Splash.Msg.Signup ] [ text "Sign up" ]
             ]
      ]
