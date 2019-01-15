module Main exposing (..)

import Browser
import Html.Styled exposing (..)
import Html.Styled.Events exposing (onClick)

import Utils exposing (..)

import Counter
import Widget exposing (Widget)

type Msg = CounterMsg Counter.Msg

type alias Model =
    { counter : Widget Counter.Msg Counter.Model Msg
    }

init : () -> (Model, Cmd Msg)
init _ = pure
    { counter = Widget.new CounterMsg Counter.info
    }

view : Model -> Html Msg
view model = div []
    [ label [] [ text "Widget test" ]
    , Widget.show model.counter
    ]

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = case msg of
    CounterMsg msg_ -> let (m, c) = Widget.update_ msg_ model.counter in ({ model | counter = m }, c)


subs : Model -> Sub Msg
subs model = Widget.subs model.counter

main = Browser.element { init = init, view = toUnstyled << view, update = update, subscriptions = subs }






