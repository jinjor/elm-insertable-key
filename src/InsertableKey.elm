module InsertableKey exposing (after, before, between, init, Key)

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
            betweenHelp a b

        _ ->
            Nothing


betweenHelp : Key -> Key -> Maybe Key
betweenHelp small big =
    incrementKey small
        |> Maybe.andThen
            (\afterSmall ->
                case compare afterSmall big of
                    LT ->
                        Just afterSmall

                    EQ ->
                        if small ++ "1" == big then
                            betweenHelp (small ++ "0") big

                        else
                            Just (small ++ "1")

                    GT ->
                        if small ++ "0" == big then
                            Nothing

                        else
                            betweenHelp (small ++ "0") big
            )


incrementKey : Key -> Maybe Key
incrementKey key =
    String.uncons (String.right 1 key)
        |> Maybe.andThen
            (\( c, _ ) ->
                let
                    code =
                        Char.toCode c

                    next =
                        incrementAlphaNum code
                in
                if code == maxCode then
                    Just (String.fromChar c ++ "1")

                else if isValid next then
                    Just (String.fromChar (Char.fromCode next))

                else
                    Nothing
            )
        |> Maybe.map
            (\tail ->
                String.dropRight 1 key ++ tail
            )


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
