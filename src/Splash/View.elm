module Splash.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode

import Splash.Msg exposing (..)
import Splash.Model exposing (..)
import Proto.Signup_form_response exposing (..)

view : Model -> Html Msg
view model =
 let
  page_parts =
    case model.mode of
      ModeSplash ->
         [ catchphrase, steps]
      ModeSignup ->
         [ catchphrase, signup model]
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


signup model =
  div [ class "signup" ]
      [
        Html.form [
                    class (formClasses model [""]),
                    onWithOptions
                      "submit"
                      { preventDefault = True, stopPropagation = False }
                      ( Json.Decode.succeed SignupSend )
                  ]
             [
               div [] [ text "Create a new account" ],
               fieldset [ disabled (isFormSent model) ] [
                 Html.input [
                     placeholder "Full Name",
                     autofocus True,
                     onInput Splash.Msg.SignupFullname
                   ]
                   [],
                 Html.input [
                     id "f_email",
                     placeholder "Email address",
                     onInput Splash.Msg.SignupEmail
                   ]
                   [],
                 label [ for "f_email", class "error"]
                   (case model.signup_response of
                      Just r ->
                        case r.ok of
                          True -> []
                          False ->
                            case r.reason of
                              SignupFormResponse_EmailAlert -> [text r.message]
                              _ -> []
                      Nothing -> []),
                 button [ ] [ text (if isFormSent model then "Sending..." else "Submit") ]
                ]
             ]
      ]

formClasses : Model -> List String-> String
formClasses model base_classes =
  let
    in_flight = String.length model.signup_req_id > 0 -- use a Maybe
    classes = if in_flight then "disabled" :: base_classes else base_classes
  in
    String.join " " classes
