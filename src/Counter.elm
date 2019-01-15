module Counter exposing (..)

import Html.Styled exposing (..)
import Html.Styled.Events exposing (onClick)
import Time

import Utils exposing (pure, send)

type Msg = Inc | Dec | Tick Time.Posix

type alias Model = Int

init : Model
init = 0

update : Msg -> Model -> (Model, Cmd Msg)
update msg val = case msg of
    Inc    -> pure <| val + 1
    Dec    -> pure <| val - 1
    Tick _ -> (val, send Inc)

view : Model -> Html Msg
view val = div []
    [ button [ onClick Inc ] [ text "+" ]
    , text <| String.fromInt val
    , button [ onClick Dec ] [ text "-" ]
    ]

subs : Sub Msg
subs = Time.every 1000 Tick

info = { update = update, view = view, init = init, subs = subs }