module InsertableKey exposing (Key, after, before, between, init, isValid)

{-| -}

import Char


type alias Key =
    String


init : Key
init =
    "1"


before : Key -> Maybe Key
before key =
    if isValid key then
        betweenHelp "0" key

    else
        Nothing


after : Key -> Maybe Key
after key =
    if isValid key then
        betweenHelp key "{"

    else
        Nothing


between : Key -> Key -> Maybe Key
between a b =
    if isValid a && isValid b then
        betweenHelp a b

    else
        Nothing


betweenHelp : Key -> Key -> Maybe Key
betweenHelp a b =
    if a < b then
        incrementKey (String.toList a) (String.toList b) ""

    else
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
                next =
                    s
                        |> Char.toCode
                        |> incrementAlphaNum
                        |> Char.fromCode
            in
            if s == b || next == b && bRest == [] then
                incrementKey sRest bRest (current ++ String.fromChar s)

            else
                Just (current ++ String.fromChar next)


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


isValid : Key -> Bool
isValid key =
    (key /= "")
        && (key > "0")
        && (key < "{")
        && (String.right 1 key /= "0")
        && List.all isAlphaNum (String.toList key)


isAlphaNum : Char -> Bool
isAlphaNum c =
    let
        n =
            Char.toCode c
    in
    n >= 48 && n <= 57 || n >= 65 && n <= 90 || n >= 97 && n <= 122


minCode : Int
minCode =
    48


maxCode : Int
maxCode =
    122
