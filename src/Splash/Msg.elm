module Splash.Msg exposing (Msg(..))

type Msg = ShowSignup
           | SignupDone
           | SignupEmail String
           | Noop
