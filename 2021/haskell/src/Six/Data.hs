module Six.Data where

import RIO
import RIO.Vector (fromList, singleton)

solve1 :: Int -> [Int] -> Int
solve1 days fishes = length $ iter days (fromList fishes)

iter :: Int -> Vector Int -> Vector Int
iter remaining fishes =
  if remaining == 0
    then fishes
    else
      let newFishes =
            fishes
              >>= \fish -> if fish == 0 then fromList [6, 8] else singleton $ fish - 1
       in iter (remaining - 1) newFishes