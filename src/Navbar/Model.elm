module Navbar.Model exposing (..)

import Proto.Account exposing (..)
import Random.Pcg exposing (Seed)

type alias Model = {
    ws_url: String,
    hasToken: Bool,
    account: Maybe Account,
    seed: Seed
  }
