module Splash.Msg exposing (..)

import Proto.Signup_form_response exposing (..)

type Mode = ModeSplash | ModeSignup

type Msg = ShowSignup
           | SignupSend
           | SignupEmail String
           | SignupFullname String
           | SignupNickname String
           | SignupResponse SignupFormResponse
           | Noop
