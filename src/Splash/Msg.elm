module Splash.Msg exposing (..)

import Proto.Signup_form_response exposing (..)
import Proto.Session_create_response exposing (..)

type Mode = ModeSplash | ModeSignup

type Msg = Noop
           | SignupSend
           | SignupEmail String
           | SignupFullname String
           | SignupNickname String
           | SignupResponse SignupFormResponse
           | SessionCreateResponseMsg SessionCreateResponse
           | ShowSignup
