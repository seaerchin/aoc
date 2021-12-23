module Seven.Data where

import Flow
import GHC.List (minimum)
import RIO
import qualified RIO.Map as M

-- adopt naive approach first
-- we can track the # at each position also to optimize
solve1 :: [Int] -> Int
solve1 pos =
  let positions = M.toList $ foldr (\pos -> M.insertWith (+) pos 1) mempty pos
   in minimum $ getCosts positions

cost :: (Int, Int) -> Int -> Int
cost (a, num) b = abs (a - b) * num

getCosts :: [(Int, Int)] -> [Int]
getCosts ls = getCost <$> (fst <$> ls)
  where
    getCost :: Int -> Int
    getCost target = sum $ (`cost` target) <$> ls