# elm-insertable-key

[![Build Status](https://travis-ci.org/jinjor/elm-insertable-key.svg?branch=master)](https://travis-ci.org/jinjor/elm-insertable-key)

Generates a new key between two keys

## What is this?

If you want to insert new record between B and C,

|id|sort_key|
|:--|:--|
|A|1|
|B|2|
|C|3|
|D|4|

This library gives you a new key `21`.

|id|sort_key|
|:--|:--|
|A|1|
|B|2|
|E|21|
|C|3|
|D|4|

This can be useful, when you use RDB and change the order without rearranging all of the rows.

## Example

```elm
import InsertableKey exposing (Key, after, before, between, init)

generateThreeKeys : Maybe ( Key, Key, Key )
generateThreeKeys =
    let
        left =
            init
    in
    after left
        |> Maybe.andThen
            (\right ->
                between first right
                    |> Maybe.map
                        (\center ->
                            ( left, center, right )
                        )
            )
```

## LICENSE

BSD-3-Clause