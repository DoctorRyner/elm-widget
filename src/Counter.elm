module Counter exposing (..)

import Html.Styled exposing (..)
import Html.Styled.Events exposing (onClick)

import Utils exposing (pure)

type Msg = Inc | Dec

type alias Model = Int

init : Model
init = 0

update : Msg -> Model -> (Model, Cmd Msg)
update msg val = case msg of
    Inc -> pure <| val + 1
    Dec -> pure <| val - 1

view : Model -> Html Msg
view val = div []
    [ button [ onClick Inc ] [ text "+" ]
    , text <| String.fromInt val
    , button [ onClick Dec ] [ text "-" ]
    ]

info = { update = update, view = view, init = init }