module Components exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import String exposing (toUpper)

navbar model =
  div [ class "navbar" ]
      [
        span [ class "menuitem" ]
             [
               img [ class "littlelogo", src "assets/logo.svg" ] [],
               a [ href "/" ]
                 [ text "Cointhink" ]
             ],
        span [ class "menuitem" ]
             [
               login
             ]
      ]

login =
  Html.form []
            [
              Html.input [
                      type' "email",
                      placeholder "username"
                    ]
                    [],
              button [ ] [ text "Signin" ]
            ]

pairTitle model =
  span [ class "pairtitle" ]
       [
          text (toUpper model.base),
          text "/",
          text (toUpper model.quote)
       ]

exchangeListLive =
  div [ id "exchangeListLive" ]
      [ text "Exchanges" ]

chartZone model =
  div [ id "chartZone" ]
      [
        exchangeListLive,
        chartWithTitle model
      ]

chartWithTitle model =
  div []
      [
        pairTitle model,
        chart
      ]

chart =
  div [ id "chart" ] []

marketHtml market =
  li []
     [ a [ href ( "?m=" ++ market.base ++ ":" ++ market.quote) ]
         [ text ( market.base ++ "/" ++ market.quote ) ]
     ]

exchangeHtml exchange =
  li []
      [ span [] [text exchange.id],
        text " ",
        span [] [text (toString (List.length exchange.markets)) ],
        text " markets",
        ul [ id "marketList" ]
           (List.map marketHtml exchange.markets)
     ]

exchangeList exchanges =
  div []
      [ text "Exchanges",
        ul [ id "exchangeList" ]
            (List.map exchangeHtml exchanges)
      ]

centerBlock =
  div [ id "centerblock" ]
      [
        div [] [ img [ class "biglogo", src "assets/logo.svg" ] [] ],
        div [] [ text "Cointhink is being rebuilt." ],
        div [] [ text "Check back later." ]
      ]

footer model =
  div [ class "footer" ]
      [  ]

view model =
 div [ class "main" ]
     [
       navbar model,
       chartZone model,
       exchangeList model.exchanges,
       centerBlock,
       footer model
     ]
