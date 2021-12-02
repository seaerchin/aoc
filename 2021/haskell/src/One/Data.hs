module One.Data where

import Flow
import RIO hiding (first, second)
import RIO.List (zip3)
import RIO.List.Partial (init, tail)

solve1 :: [Int] -> Int
solve1 arr =
  let firstArr = init arr
      lastArr = tail arr
   in zip firstArr lastArr <&> (\(x, y) -> if y > x then 1 else 0) |> sum

solve2 :: [Int] -> Int
solve2 first =
  let second = tail first
      third = tail second
   in zip3 first second third <&> sum3 |> solve1
  where
    sum3 :: (Int, Int, Int) -> Int
    sum3 (a, b, c) = a + b + c