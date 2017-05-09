module Splash.Model exposing (..)

import String

import Splash.Msg exposing (..)
import Proto.Signup_form exposing (..)
import Proto.Signup_form_response exposing (..)

import Random.Pcg exposing (Seed)

type alias Model = {
  seed: Seed,
  mode: Mode,
  signup: SignupForm,
  signup_req_id: String,
  signup_response: Maybe SignupFormResponse
}

isFormSent : Model -> Bool
isFormSent model = String.length model.signup_req_id > 0

isMaybeThere : Maybe a -> Bool
isMaybeThere maybe =
  case maybe of
    Nothing -> False
    Just a -> True

modelFormTweak : { b | x : a } -> { b | x : a } -> String
modelFormTweak form field  =
  let
    the_form = form
  in
    "a"
