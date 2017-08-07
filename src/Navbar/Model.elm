module Navbar.Model exposing (..)

import Proto.Account exposing (..)
import Proto.Signin_email exposing (..)
import Random.Pcg exposing (Seed)


type alias Model =
    { ws_url : String
    , netFail : Bool
    , hasToken : Bool
    , account : Maybe Account
    , seed : Seed
    , showUsercardMenu : Bool
    , signinEmail : SigninEmail
    , signinEmailMessage : String
    }


defaultModel ws_url hasToken seed =
    Model ws_url False hasToken Nothing seed False (SigninEmail "") ""
