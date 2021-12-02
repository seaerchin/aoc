module Ten.Ten where

import Data.Array
import Data.List
import Debug.Trace
import Utils

driver :: IO ()
driver =
  getInput "data.txt"
    >>= \input ->
      let x = map (\x -> read x :: Int) input
          res = solve2 x
       in print res

solve :: [Int] -> Int
solve = extract . findDiff . sort

solve2 :: [Int] -> Int
solve2 = calcWays . sort

findDiff :: [Int] -> [Int]
findDiff ls =
  let new = 0 : ls ++ [maximum ls + 3]
   in zipWith (-) (tail new) (init new)

extract :: [Int] -> Int
extract ls =
  let count = \x -> sum [1 | i <- ls, i == x]
      ones = count 1
      threes = count 3
   in trace (show ls) ones * threes

-- calcWays will calculate the number of ways to get from 0 to the end
-- we establish a proof by the following
-- for any number in range [n + 1, n + 3] where n is the number of interest
-- n + 1 must include n + 2 and n + 3 by definition
calcWays :: [Int] -> Int
calcWays = go [(0, 1)]
  where
    go :: [(Int, Int)] -> [Int] -> Int
    go memo (x : xs) =
      case xs of
        [] -> i
        _ -> go ((x, i) : memo) xs
      where
        i = sum . map snd $ takeWhile (\(y, _) -> x - y <= 3) memo
