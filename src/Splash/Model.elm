module Splash.Model exposing (Model)

import Signup_form exposing (..)

type alias Model = {
  email : String,
  signup: SignupForm
}

