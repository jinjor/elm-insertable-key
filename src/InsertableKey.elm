module InsertableKey exposing (Key, after, before, between, init)

{-| -}

import Char


type alias Key =
    String


init : Key
init =
    "1"


before : Key -> Maybe Key
before key =
    between "0" key


after : Key -> Maybe Key
after key =
    between key "{"


between : Key -> Key -> Maybe Key
between a b =
    case compare a b of
        LT ->
            incrementKey (String.toList a) (String.toList b) ""

        _ ->
            Nothing


incrementKey : List Char -> List Char -> String -> Maybe Key
incrementKey small big current =
    case ( small, big ) of
        ( [], rest ) ->
            incrementKeyHelp rest current

        ( s :: sRest, [] ) ->
            incrementKey small [ '{' ] current

        ( s :: sRest, b :: bRest ) ->
            let
                sCode =
                    Char.toCode s

                bCode =
                    Char.toCode b

                sNext =
                    incrementAlphaNum sCode
            in
            if sCode == bCode || sNext == bCode && bRest == [] then
                incrementKey sRest bRest (current ++ String.fromChar s)

            else
                Just (current ++ String.fromChar (Char.fromCode sNext))


incrementKeyHelp : List Char -> String -> Maybe Key
incrementKeyHelp tail current =
    case tail of
        '0' :: [] ->
            Nothing

        '0' :: rest ->
            incrementKeyHelp rest (current ++ "0")

        '1' :: [] ->
            Just (current ++ "01")

        _ ->
            Just (current ++ "1")


incrementAlphaNum : Int -> Int
incrementAlphaNum code =
    if code == 57 then
        65

    else if code == 90 then
        97

    else
        code + 1


decrementAlphaNum : Int -> Int
decrementAlphaNum code =
    if code == 65 then
        57

    else if code == 97 then
        90

    else
        code - 1


isValid : Int -> Bool
isValid n =
    n >= 48 && n <= 57 || n >= 65 && n <= 90 || n >= 97 && n <= 122


minCode : Int
minCode =
    48


maxCode : Int
maxCode =
    122
