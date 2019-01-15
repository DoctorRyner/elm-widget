module Widget exposing (..)

import Html.Styled exposing (..)
import List.Extra exposing (find)

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

widgetBoxUpdate : msg -> WidgetBox msg model a -> Int -> (WidgetBox msg model a, Cmd a)
widgetBoxUpdate subMsg box id =
    let toUpdate = case find (\x -> x.id == id) box.widgets of
            Just w  -> w
            Nothing -> WidgetCell 0 box.info.init
        (updated, cmd) = box.info.update subMsg toUpdate.widget
    in
    ({ box | widgets = List.map (\x -> if x.id == id then { x | widget = updated } else x) box.widgets }
    , Cmd.map (\x -> box.link x id) cmd
    )

type alias WidgetCell model = { id : Int, widget : model }

-- type alias WidgetMsg msg a = (msg -> Int -> a)
type WidgetMsg msg = WidgetMsg msg Int

type alias WidgetBox msg model a =
    { link : (msg -> Int -> a)
    , info : WidgetInfo msg model
    , ratio : Int
    , widgets : List (WidgetCell model)
    }

widgetBoxNew : (msg -> Int -> a) -> WidgetInfo msg model -> WidgetBox msg model a
widgetBoxNew link info = { link = link, info = info, ratio = 0, widgets = [] }

widgetAdd : model -> WidgetBox msg model a -> WidgetBox msg model a
widgetAdd widget_ box = { box | widgets = box.widgets ++ [ WidgetCell box.ratio widget_ ], ratio = box.ratio + 1 }

widgetAddNew : WidgetBox msg model a -> WidgetBox msg model a
widgetAddNew box = { box | widgets = box.widgets ++ [ WidgetCell box.ratio box.info.init ], ratio = box.ratio + 1 }

widgetBox : WidgetBox msg model a -> Html a
widgetBox box = div [] <|
    List.map
        (\x ->
            Html.Styled.map
                (\msg ->
                    box.link msg x.id
                ) (box.info.view x.widget)
        ) box.widgets