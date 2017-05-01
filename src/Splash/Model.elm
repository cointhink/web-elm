module Splash.Model exposing (Model, toJson)

import Json.Encode exposing (Value, encode, object, string)

type alias Model = {
  email : String
}

toJson: Model -> String
toJson model =
  encode 0 (toObject model)

toObject: Model -> Value
toObject model =
  object
    [
      ("email", string model.email)
    ]