module Navbar.Msg exposing (..)

import Proto.Session_create_response exposing (..)


type Msg
    = Noop
    | SessionCreateResponseMsg SessionCreateResponse
    | TokenReceived String
    | LogoutButton
    | UsercardMenu
    | SigninEmailDone
    | SigninEmailChg String
