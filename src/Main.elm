module Main exposing (..)

import Browser
import Html.Styled exposing (..)

import Utils exposing (..)
import Widget exposing (..)

import Counter
import Switch

type Msg = CounterMsg Counter.Msg Int

type alias Model =
    { counterBox : WidgetBox Counter.Msg Counter.Model Msg
    }

-- init : () -> (Model, Cmd Msg)
-- init _ = pure
--     { counterBox = widgetNewBox CounterMsg Counter.info
--     }

view : Model -> Html Msg
view model = div []
    [
    ]

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = pure model
    -- case msg of
    -- CounterMsg boxMsg ->
    --     let widgetToChange = List.filter (\cell -> cell.id == boxMsg.id) model.counterBox.widgets
    --         updatedWidgets = List.map (\x -> x) 
        -- in
    -- case msg of
    -- CounterMsg subMsg -> let (m, c) = widgetUpdate subMsg model.counter in ({ model | counter = m }, c)

subs : Model -> Sub Msg
subs model = Sub.none

-- main = Browser.element { init = init, view = toUnstyled << view, update = update, subscriptions = subs }






