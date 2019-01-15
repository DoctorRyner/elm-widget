module Counter exposing (..)

import Html.Styled exposing (..)
import Html.Styled.Events exposing (onClick)
import String exposing (fromInt)
import Widget exposing (WidgetInfo)
import Utils exposing (send)

type alias Model = { count : Int }

init : Model
init = { count = 0 }

type Msg = Inc | Dec

view : Model -> Html Msg
view model =
    div []
        [ div [] [ text <| fromInt model.count ]
        , button [ onClick Inc ] [ text "Click" ]
        , button [ onClick Dec ] [ text "Click minus" ]
        ]

update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        Inc -> ( { model | count = model.count + 1 }, Cmd.none )
        Dec -> ( { model | count = model.count - 1 }, Cmd.none )

info = { update = update, view = view, init = init }