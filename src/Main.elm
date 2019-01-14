module Main exposing (..)

import Browser
import Html.Styled exposing (..)

import Utils exposing (..)
import Widget exposing (..)

import Counter
import Switch

type Msg
    = CounterMsg Counter.Msg
    | SwitchMsg Switch.Msg

type alias Model =
    { counter : Widget Counter.Msg Counter.Model Msg
    , switch  : Widget Switch.Msg Switch.Model Msg
    }

init : () -> (Model, Cmd Msg)
init _ = pure
    { counter = widgetNew CounterMsg Counter.info
    , switch  = widgetNew SwitchMsg Switch.info
    }

view : Model -> Html Msg
view model = div []
    [ widget model.counter
    , widget model.switch
    ]

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = case msg of
    CounterMsg subMsg -> let (m, c) = widgetUpdate subMsg model.counter in ({ model | counter = m }, c)
    SwitchMsg  subMsg -> let (m, c) = widgetUpdate subMsg model.switch  in ({ model | switch  = m }, c)

subs : Model -> Sub Msg
subs model = Sub.none

main = Browser.element { init = init, view = toUnstyled << view, update = update, subscriptions = subs }






