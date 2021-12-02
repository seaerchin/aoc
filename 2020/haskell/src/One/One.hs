module One.One where

import Data.Maybe (fromMaybe)
import Utils

driver = do
  input <- getInput "One.txt"
  let parsedInput = inputToInteger input
      matchingNumbers = solve2 (map (fromMaybe 0) parsedInput) 2020
      res = product matchingNumbers
  print matchingNumbers
  print $ sum matchingNumbers
  print res

-- finds 2 numbers that sum to target
solve :: [Int] -> Int -> [Int]
solve ls target = [x | x <- ls, y <- tail ls, x + y == target]

solve2 :: [Int] -> Int -> [Int]
solve2 [x, y] _ = []
solve2 (first : ls) target
  | not $ null sumsToTarget = first : sumsToTarget
  | otherwise = solve2 (second : rest) target
  where
    second = head ls
    rest = tail ls
    sumsToTarget = solve ls (target - first)