module Widget exposing (..)

import Html.Styled exposing (..)

type alias WidgetInfo msg model =
    { update : (msg -> model -> (model, Cmd msg))
    , view : model -> Html msg
    , init : model
    }

type alias Widget msg model a =
    { link : (msg -> a)
    , info : WidgetInfo msg model
    , val  : model
    }

widgetNew : (msg -> a) -> WidgetInfo msg model -> Widget msg model a
widgetNew link info = Widget link info info.init 

widget : Widget msg model a -> Html a
widget widget_ = Html.Styled.map widget_.link <| widget_.info.view widget_.val

widgetUpdate : msg -> Widget msg model a -> (Widget msg model a, Cmd a)
widgetUpdate msg widget_ =
    let (updatedWidget, widgetCmd) = widget_.info.update msg widget_.val
    in ({ widget_ | val = updatedWidget }, Cmd.map widget_.link widgetCmd)

type alias WidgetMsg msg = { msg : msg, id : Int }

type alias WidgetCell msg model a = { id : Int, widget : Widget msg model a }

type alias WidgetBox msg model a = { widgets : List (WidgetCell msg model a), ratio : Int }

widgetNewBox : WidgetBox msg model a
widgetNewBox = { widgets = [], ratio = 0 }

widgetAdd : Widget msg model a -> WidgetBox msg model a -> WidgetBox msg model a
widgetAdd widget_ box = { box | widgets = box.widgets ++ [ WidgetCell box.ratio widget_ ], ratio = box.ratio + 1 }