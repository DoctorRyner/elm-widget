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

type alias WidgetCell msg model a = { id : Int, widget : Widget msg model a }

type alias WidgetBox msg model a =
    { link : (msg -> a)
    , info : WidgetInfo msg model
    , ratio : Int
    , widgets : List (WidgetCell msg model a)
    }

widgetNewBox : (msg -> a) -> WidgetInfo msg model -> WidgetBox msg model a
widgetNewBox link info = { link = link, info = info, ratio = 0, widgets = [] }

widgetAdd : Widget msg model a -> WidgetBox msg model a -> WidgetBox msg model a
widgetAdd widget_ box = { box | widgets = box.widgets ++ [ WidgetCell box.ratio widget_ ], ratio = box.ratio + 1 }