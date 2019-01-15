module Widget exposing (..)

import Html.Styled exposing (..)
import List.Extra exposing (find)

type alias Info msg model =
    { update : (msg -> model -> (model, Cmd msg))
    , view : model -> Html msg
    , init : model
    , subs : (model -> Sub msg)
    }

type alias Widget msg model a =
    { link : (msg -> a)
    , info : Info msg model
    , model  : model
    , subs : (model -> Sub msg)
    }

new : (msg -> a) -> Info msg model -> Widget msg model a
new link info = Widget link info info.init info.subs

show : Widget msg model a -> Html a
show widget_ = Html.Styled.map widget_.link <| widget_.info.view widget_.model

update_ : msg -> Widget msg model a -> (Widget msg model a, Cmd a)
update_ msg widget_ =
    let (updatedWidget, widgetCmd) = widget_.info.update msg widget_.model
    in ({ widget_ | model = updatedWidget }, Cmd.map widget_.link widgetCmd)

update : msg -> Widget msg model a -> Widget msg model a
update msg widget_ =
    let (updatedWidget, _) = widget_.info.update msg widget_.model in { widget_ | model = updatedWidget }

type alias Cell model = { id : Int, model : model }

type alias Box msg model a =
    { link : (msg -> Int -> a)
    , info : Info msg model
    , ratio : Int
    , widgets : List (Cell model)
    }

updateBox_ : msg -> Int -> Box msg model a -> (Box msg model a, Cmd a)
updateBox_ subMsg id box_ =
    let toUpdate = case find (\x -> x.id == id) box_.widgets of
            Just w  -> w
            Nothing -> Cell 0 box_.info.init
        (updated, cmd) = box_.info.update subMsg toUpdate.model
    in
    ({ box_ | widgets = List.map (\x -> if x.id == id then { x | model = updated } else x) box_.widgets }
    , Cmd.map (\x -> box_.link x id) cmd
    )

updateBox : msg -> Int -> Box msg model a -> Box msg model a
updateBox subMsg id box_ =
    let toUpdate = case find (\x -> x.id == id) box_.widgets of
            Just w  -> w
            Nothing -> Cell 0 box_.info.init
        (updated, _) = box_.info.update subMsg toUpdate.model
    in { box_ | widgets = List.map (\x -> if x.id == id then { x | model = updated } else x) box_.widgets }

showBox : Box msg model a -> Html a
showBox box_ = div [] <| List.map
    (\x -> Html.Styled.map (\msg -> box_.link msg x.id) (box_.info.view x.model)) box_.widgets

newBox : (msg -> Int -> a) -> Info msg model -> Box msg model a
newBox link info = { link = link, info = info, ratio = 0, widgets = [] }

add : model -> Box msg model a -> Box msg model a
add widget_ box_ = { box_ | widgets = box_.widgets ++ [ Cell box_.ratio widget_ ], ratio = box_.ratio + 1 }

add_ : Box msg model a -> Box msg model a
add_ box_ = { box_ | widgets = box_.widgets ++ [ Cell box_.ratio box_.info.init ], ratio = box_.ratio + 1 }

subs : Widget msg model a -> Sub a
subs widget = Sub.map widget.link <| widget.info.subs widget.model

subsBox : Box msg model a -> Sub a
subsBox box_ = Sub.batch <| List.map (\w -> Sub.map (\msg -> box_.link msg w.id) <| box_.info.subs w.model) box_.widgets