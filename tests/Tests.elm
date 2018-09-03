module Tests exposing (suite)

import Expect exposing (Expectation)
import InsertableKey exposing (Key)
import Test exposing (Test, describe, test)


testAfter : Key -> Maybe Key -> Test
testAfter small result =
    test ("can generate correct key after " ++ small) <|
        \_ ->
            Expect.equal result (InsertableKey.after small)


testBefore : Key -> Maybe Key -> Test
testBefore big result =
    test ("can generate correct key before " ++ big) <|
        \_ ->
            Expect.equal result (InsertableKey.before big)


testBewtween : Key -> Key -> Maybe Key -> Test
testBewtween small big result =
    test ("can generate correct key between " ++ small ++ " and " ++ big) <|
        \_ ->
            Expect.equal result (InsertableKey.between small big)


suite : Test
suite =
    describe "InsertableKey"
        [ testBefore "2" (Just "1")
        , testBefore "1" (Just "01")
        , testBefore "11" (Just "1")
        , testBefore "01" (Just "001")
        , testBefore "z" (Just "1")
        , testBefore "0" Nothing
        , testBefore "/" Nothing
        , testAfter "1" (Just "2")
        , testAfter "9" (Just "A")
        , testAfter "Z" (Just "a")
        , testAfter "z" (Just "z1")
        , testAfter "z1" (Just "z2")
        , testAfter "zy" (Just "zz")
        , testAfter "zz" (Just "zz1")
        , testAfter "zz1" (Just "zz2")

        -- , testAfter "a1" (Just "b")
        -- , testAfter "az" (Just "b")
        , testAfter "{" Nothing
        , testAfter "|" Nothing
        , testBewtween "1" "3" (Just "2")
        , testBewtween "1" "2" (Just "11")
        , testBewtween "1" "11" (Just "101")
        , testBewtween "1" "12" (Just "11")
        , testBewtween "1" "101" (Just "1001")
        , testBewtween "1" "1001" (Just "10001")
        , testBewtween "11" "2" (Just "12")

        -- , testBewtween "11" "3" (Just "2")
        , testBewtween "19" "2" (Just "1A")
        , testBewtween "1Z" "2" (Just "1a")
        , testBewtween "11" "12" (Just "111")
        , testBewtween "11" "111" (Just "1101")
        , testBewtween "11" "112" (Just "111")
        , testBewtween "11" "1111" (Just "111")
        , testBewtween "11" "13" (Just "12")
        , testBewtween "19" "1A" (Just "191")
        , testBewtween "1Z" "1a" (Just "1Z1")

        -- , testBewtween "1a" "2a" (Just "2")
        , testBewtween "1z" "2" (Just "1z1")
        , testBewtween "z" "z1" (Just "z01")
        , testBewtween "zy" "zz" (Just "zy1")
        , testBewtween "zz" "zz1" (Just "zz01")
        , testBewtween "zz" "zz01" (Just "zz001")
        ]
