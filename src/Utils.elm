module Utils exposing (..)

import Task exposing (succeed, perform)

id : a -> a
id a = a

pure : a -> (a, Cmd b)
pure a = (a, Cmd.none)

send : msg -> Cmd msg
send = perform id << succeed