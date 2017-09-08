module Navbar.Msg exposing (..)

import Proto.Session_create_response exposing (..)
import Proto.Signin_email_response exposing (..)


type Msg
    = Noop
    | SessionCreateResponseMsg SessionCreateResponse
    | TokenReceived String
    | LogoutButton
    | UsercardMenu
    | SigninEmailDone
    | SigninEmailChg String
    | SigninEmailResponseMsg SigninEmailResponse
    | WebsocketFail String
