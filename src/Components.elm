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

chartLegend =
  ul [ class "legend" ] []

chartZone model =
  div [ id "chartZone" ]
      [
        chartLegend,
        chartWithTitle model
      ]

chartWithTitle model =
  div [ id "chartStuff" ]
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

marketList markets =
  div []
      [ select [ id "markets"]
               (List.map marketOptionHtml markets)
      ]

marketOptionHtml market =
  option []
         [ text market.base ]

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
       marketList model.markets,
       centerBlock,
       footer model
     ]
