module Main exposing (..)

import Browser
import Html.Styled exposing (..)

import Utils exposing (..)
import Widget exposing (..)

import Counter
import Switch

type Msg = NoEff

type alias Model =
    {
    }

init : () -> (Model, Cmd Msg)
init _ = pure
    { 
    }

view : Model -> Html Msg
view model = div []
    [ 
    ]

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = pure model

subs : Model -> Sub Msg
subs model = Sub.none

main = Browser.element { init = init, view = toUnstyled << view, update = update, subscriptions = subs }






