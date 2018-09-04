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


testBetween : Key -> Key -> Maybe Key -> Test
testBetween small big result =
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
        , testBefore "{" Nothing
        , testAfter "1" (Just "2")
        , testAfter "9" (Just "A")
        , testAfter "Z" (Just "a")
        , testAfter "z" (Just "z1")
        , testAfter "z1" (Just "z2")
        , testAfter "zy" (Just "zz")
        , testAfter "zz" (Just "zz1")
        , testAfter "zz1" (Just "zz2")
        , testAfter "a1" (Just "b")
        , testAfter "az" (Just "b")
        , testAfter "{" Nothing
        , testAfter "|" Nothing
        , testAfter "0" Nothing
        , testBetween "1" "3" (Just "2")
        , testBetween "1" "2" (Just "11")
        , testBetween "1" "11" (Just "101")
        , testBetween "1" "12" (Just "11")
        , testBetween "1" "101" (Just "1001")
        , testBetween "1" "1001" (Just "10001")
        , testBetween "11" "2" (Just "12")
        , testBetween "11" "3" (Just "2")
        , testBetween "19" "2" (Just "1A")
        , testBetween "1Z" "2" (Just "1a")
        , testBetween "11" "12" (Just "111")
        , testBetween "11" "111" (Just "1101")
        , testBetween "11" "112" (Just "111")
        , testBetween "11" "1111" (Just "111")
        , testBetween "11" "1101" (Just "11001")
        , testBetween "11" "13" (Just "12")
        , testBetween "19" "1A" (Just "191")
        , testBetween "1Z" "1a" (Just "1Z1")
        , testBetween "1a" "2a" (Just "2")
        , testBetween "1z" "2" (Just "1z1")
        , testBetween "z" "z1" (Just "z01")
        , testBetween "zy" "zz" (Just "zy1")
        , testBetween "zz" "zz1" (Just "zz01")
        , testBetween "zz" "zz01" (Just "zz001")
        , testBetween "" "" Nothing
        , testBetween "" "1" Nothing
        , testBetween "1" "" Nothing
        , testBetween "1" "1" Nothing
        , testBetween "2" "1" Nothing
        , testBetween "0" "1" Nothing
        , testBetween "1" "{" Nothing
        ]
