module Main exposing (..)

import Browser
import Html.Styled exposing (..)
import Html.Styled.Events exposing (onClick)

import Utils exposing (..)

import Counter
import Widget exposing (Widget)

type Msg = CounterMsg Counter.Msg Int | AddCounter

type alias Model =
    { counters : Widget.Box Counter.Msg Counter.Model Msg
    }

init : () -> (Model, Cmd Msg)
init _ = pure
    { counters = Widget.newBox CounterMsg Counter.info
    }

view : Model -> Html Msg
view model = div []
    [ label [] [ text "Widget test" ]
    , button [ onClick AddCounter ] [ text "Add counter" ]
    , Widget.showBox model.counters
    ]

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = case msg of
    CounterMsg msg_ id -> let (m, c) = Widget.updateBox_ msg_ id model.counters in ({ model | counters = m }, c)
    AddCounter         -> pure { model | counters = Widget.add_ model.counters }


subs : Model -> Sub Msg
subs model = Widget.subsBox model.counters

main = Browser.element { init = init, view = toUnstyled << view, update = update, subscriptions = subs }






