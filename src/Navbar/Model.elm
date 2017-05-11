module Navbar.Model exposing (..)

import Proto.Account exposing (..)
import Random.Pcg exposing (Seed)


type alias Model =
    { ws_url : String
    , hasToken : Bool
    , account : Maybe Account
    , seed : Seed
    , showUsercardMenu : Bool
    }


defaultModel ws_url hasToken seed =
    Model ws_url hasToken Nothing seed False
