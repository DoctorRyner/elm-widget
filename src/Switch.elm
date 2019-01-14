module Switch exposing (..)

import Html.Styled exposing (..)
import Html.Styled.Events exposing (onClick)
import Widget exposing (WidgetInfo)

type Msg = Switch

type alias Model = Bool

init : Model
init = False

update : Msg -> Model -> (Model, Cmd Msg)
update msg isOn = case msg of Switch -> (not isOn, Cmd.none)

view : Model -> Html Msg
view isOn = label [ onClick Switch ] [ text <| if isOn then "off" else "on" ]

info : WidgetInfo Msg Model
info = WidgetInfo update view init