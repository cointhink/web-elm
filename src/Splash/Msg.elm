module Splash.Msg exposing (..)

type Mode = ModeSplash | ModeSignup

type Msg = ShowSignup
           | SignupDone
           | SignupEmail String
           | Noop
