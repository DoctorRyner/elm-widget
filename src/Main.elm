module Main exposing (..)

import Browser
import Html.Styled exposing (..)
import Html.Styled.Events exposing (onClick)

import Utils exposing (..)

import Counter
import Widget exposing (Widget)

type Msg
    = CounterMsg        Counter.Msg | CountersMsg        Counter.Msg Int
    | CounterMsgWithCmd Counter.Msg | CountersMsgWithCmd Counter.Msg Int
    | AddCounter

type alias Model =
    { counter  : Widget     Counter.Msg Counter.Model Msg
    , counters : Widget.Box Counter.Msg Counter.Model Msg
    }

init : () -> (Model, Cmd Msg)
init _ = pure
    { counter  = Widget.new    CounterMsg  Counter.info
    , counters = Widget.newBox CountersMsg Counter.info
    }

view : Model -> Html Msg
view model = div []
    [ Widget.show    model.counter
    , button [ onClick AddCounter ] [ text "Add Counter" ]
    , Widget.showBox model.counters
    ]

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = case msg of
    CounterMsg         msg_    -> pure { model | counter = Widget.update msg_ model.counter }
    CounterMsgWithCmd  msg_    -> let (m, c) = Widget.update_ msg_ model.counter in ({ model | counter = m }, c)
    CountersMsg        msg_ id -> pure { model | counters = Widget.updateBox msg_ id model.counters }
    CountersMsgWithCmd msg_ id -> let (m, c) = Widget.updateBox_ msg_ id model.counters in ({ model | counters = m}, c)
    AddCounter                 -> pure { model | counters = Widget.add_ model.counters }

subs : Model -> Sub Msg
subs model = Sub.none

main = Browser.element { init = init, view = toUnstyled << view, update = update, subscriptions = subs }






