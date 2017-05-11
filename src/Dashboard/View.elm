module Dashboard.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode
import Dashboard.Msg exposing (..)
import Dashboard.Model exposing (..)


view : Model -> Html Msg
view model =
    case model.account of
        Just account ->
            welcome

        Nothing ->
            plzlogin


welcome =
    div [ class "catchphrase" ]
        [ text "Welcome to cointhink." ]


plzlogin =
    div [ class "catchphrase" ]
        [ text "Login to begin." ]
