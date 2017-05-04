module Splash.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode

import Splash.Msg exposing (..)
import Splash.Model exposing (Model)

view : Model -> Html Msg
view model =
 let
  page_parts =
    case model.mode of
      ModeSplash ->
         [ catchphrase, steps]
      ModeSignup ->
         [ catchphrase, signup]
 in
   div [ class "splash" ] page_parts


catchphrase =
  div [ class "catchphrase" ]
      [ text "Buy cryptocoins on your schedule." ]

steps =
  div [ class "steps" ]
      [ div [] [ text "1. Connect your exchange account" ],
        div [] [ text "2. Set a purchasing schedule" ],
        div [] [ text "3. Have Bitcoins and other cryptocoins purchased automatically" ],
        button [ onClick Splash.Msg.ShowSignup ] [ text "Sign up" ]
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
               div [] [text "Signup Form"],
               Html.input [ type_ "email", placeholder "email address", onInput Splash.Msg.SignupEmail] [],
               button [ onClick Splash.Msg.SignupDone ] [ text "Submit" ]
             ]
      ]
