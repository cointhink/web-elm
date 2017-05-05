module Splash.Msg exposing (..)

type Mode = ModeSplash | ModeSignup

type Msg = ShowSignup
           | SignupSend
           | SignupEmail String
           | SignupResponse
           | Noop
