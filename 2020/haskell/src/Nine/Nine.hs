module Nine.Nine where

import Control.Monad
import Debug.Trace
import Utils

-- see if last n got any 2 that sum to target
solve :: Int -> Int -> [Int] -> Bool
solve lastN target numbers = verify target (take lastN numbers)

-- checks if there are 2 numbers that sum to target in last n
verify :: Int -> [Int] -> Bool
verify target nums = (not . null) [a + b | a <- nums, b <- nums, a + b == target]

driver :: IO ()
driver =
  getInput "./data.txt"
    >>= \input ->
      let parsedInput = inputToInteger input
          result = f 25 parsedInput []
       in print result

f :: Int -> [Maybe Int] -> [Int] -> Int
f _ [] _ = error "kek"
f lastN (Just x : xs) prev
  | length prev < lastN = f lastN xs (prev ++ [x])
  | not (solve lastN x prev) = x
  | otherwise = f lastN xs (mkNew prev x)

mkNew :: [Int] -> Int -> [Int]
mkNew [] y = [y]
mkNew (x : xs) y = xs ++ [y]
