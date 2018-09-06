# elm-insertable-key

[![Build Status](https://travis-ci.org/jinjor/elm-insertable-key.svg?branch=master)](https://travis-ci.org/jinjor/elm-insertable-key)

Generates a new key between two keys.

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
                between left right
                    |> Maybe.map
                        (\center ->
                            ( left, center, right )
                        )
            )
```

## How it works?

- Each charactor in the keys is one of `0-9A-Za-z` (62 chars), but the last charactor must not be `0`.
- The first key is `1`.
- After that, one of the following will be generated:
  - A key which is *after* the existing key
  - A key which is *before* the existing key
  - A key which is *between* the existing two keys in a row
- It tries to increment the first char, but in case the new key is not smaller than the next one, tries the next char... and so on.
- i.e.
  - `between "1" "3" == Just "2"`
  - `between "1" "2" == Just "11"`
  - `between "1" "11" == Just "101"`
  - `after "1" == Just "2"`
  - `after "z" == Just "z1"`
  - [Others](https://github.com/jinjor/elm-insertable-key/blob/fa3f47692490d77ac603e4f6284e68d4681e2678/tests/Tests.elm#L91-L154)


## Help wanted!

This works well at least *for my use case*, but there should be better algorithm to do this.

- Key may be too long as row increases. The key after `z` is `z1`, and the key after `zz` is `zz1`. This means simply incrementing key until `N` results in the key length `N / 62`. So the length is `16` when we have 1000 rows but `160` when we have 1000. Considering UUID is 36 chars, `N = 2000` would be a good limit.
- Key may be also too long when continuousely generating key between an integer and the next one, like `11`, `101`, `1001`, `10001` ... `100000000001`. I think this should be fixed if a key is chosen which is placed near the center of two keys.

If you have some information about this problem, please let me know. Forking and publishing your own is also welcome!

## LICENSE

BSD-3-Clause