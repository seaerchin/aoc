module Six.Data where

import RIO
import qualified RIO.Vector as V
import RIO.Vector.Partial ((!), (//))

solve1 :: Int -> [Int] -> Int
solve1 days fishes = sum $ iter days (construct fishes)

-- use dp
-- we store each day in the slot
iter :: Int -> Vector Int -> Vector Int
iter remaining fishes =
  if remaining == 0
    then fishes
    else
      let newFishes = fishes // [(7, fishes ! 0 + fishes ! 7)]
          (breeding, rest) = V.splitAt 1 newFishes
       in iter (remaining - 1) (rest V.++ breeding)

construct :: [Int] -> Vector Int
construct =
  foldr
    ( \day vec ->
        let prev = vec ! day
         in vec // [(day, prev + 1)]
    )
    (V.replicate 9 0)
