module Splash.Model exposing (..)

import String

import Splash.Msg exposing (..)
import Signup_form exposing (..)
import Signup_form_response exposing (..)

import Random.Pcg exposing (Seed)

type alias Model = {
  seed: Seed,
  mode: Mode,
  signup: SignupForm,
  signup_req_id: String,
  signup_response: SignupFormResponse,
  signup_response_req_id: String
}

isFormSent : Model -> Bool
isFormSent model = String.length model.signup_req_id > 0