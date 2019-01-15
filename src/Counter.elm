module Counter exposing (..)

import Html.Styled exposing (..)
import Html.Styled.Events exposing (onClick)
import Time

import Utils exposing (pure, send)

type Msg = Inc | Dec | Tick Time.Posix | Switch

type alias Model = { val : Int, isOn : Bool }

init : Model
init = { val = 0, isOn = True }

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = case msg of
    Inc    -> pure <| { model | val = model.val + 1 }
    Dec    -> pure <| { model | val = model.val - 1 }
    Tick _ -> (model, send Inc)
    Switch -> pure { model | isOn = not model.isOn }

view : Model -> Html Msg
view model = div []
    [ button [ onClick Inc ] [ text "+" ]
    , text <| String.fromInt model.val
    , button [ onClick Dec ] [ text "-" ]
    , button [ onClick Switch ] [ text <| if model.isOn then "off" else "on" ]
    ]

subs : Model -> Sub Msg
subs model = if model.isOn then Time.every 2000 Tick else Sub.none

info = { update = update, view = view, init = init, subs = subs }