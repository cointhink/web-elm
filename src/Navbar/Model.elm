module Navbar.Model exposing (..)

import Proto.Account exposing (..)

type alias Model = {
    ws_url: String,
    account: Maybe Account
  }
