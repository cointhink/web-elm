module Splash.Model exposing (Model)

import Signup_form exposing (..)
import Signup_form_response exposing (..)

type alias Model = {
  signup: SignupForm,
  signup_req_id: String,
  signup_response: SignupFormResponse,
  signup_response_req_id: String
}

