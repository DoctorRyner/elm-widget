module Widget exposing (..)

import Html.Styled exposing (..)
import List.Extra exposing (find)

type alias Info msg model =
    { update : (msg -> model -> (model, Cmd msg))
    , view : model -> Html msg
    , init : model
    }

type alias Widget msg model a =
    { link : (msg -> a)
    , info : Info msg model
    , val  : model
    }

new : (msg -> a) -> Info msg model -> Widget msg model a
new link info = Widget link info info.init 

show : Widget msg model a -> Html a
show widget_ = Html.Styled.map widget_.link <| widget_.info.view widget_.val

update : msg -> Widget msg model a -> (Widget msg model a, Cmd a)
update msg widget_ =
    let (updatedWidget, widgetCmd) = widget_.info.update msg widget_.val
    in ({ widget_ | val = updatedWidget }, Cmd.map widget_.link widgetCmd)

boxUpdate : msg -> Box msg model a -> Int -> (Box msg model a, Cmd a)
boxUpdate subMsg box_ id =
    let toUpdate = case find (\x -> x.id == id) box_.widgets of
            Just w  -> w
            Nothing -> Cell 0 box_.info.init
        (updated, cmd) = box_.info.update subMsg toUpdate.widget
    in
    ({ box_ | widgets = List.map (\x -> if x.id == id then { x | widget = updated } else x) box_.widgets }
    , Cmd.map (\x -> box_.link x id) cmd
    )

type alias Cell model = { id : Int, widget : model }

type alias Box msg model a =
    { link : (msg -> Int -> a)
    , info : Info msg model
    , ratio : Int
    , widgets : List (Cell model)
    }

box : (msg -> Int -> a) -> Info msg model -> Box msg model a
box link info = { link = link, info = info, ratio = 0, widgets = [] }

add : model -> Box msg model a -> Box msg model a
add widget_ box_ = { box_ | widgets = box_.widgets ++ [ Cell box_.ratio widget_ ], ratio = box_.ratio + 1 }

add_ : Box msg model a -> Box msg model a
add_ box_ = { box_ | widgets = box_.widgets ++ [ Cell box_.ratio box_.info.init ], ratio = box_.ratio + 1 }

showBox : Box msg model a -> Html a
showBox box_ = div [] <|
    List.map
        (\x ->
            Html.Styled.map
                (\msg ->
                    box_.link msg x.id
                ) (box_.info.view x.widget)
        ) box_.widgets