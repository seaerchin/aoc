module Seven.Data where

import Data.List (transpose, (!!))
import GHC.List (maximum, minimum)
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

cost2 :: Int -> Int
cost2 cur =
  let n = fromIntegral $ abs cur :: Double
   in round $ (n / 2) * (2 + n - 1)

solve2 :: [Int] -> Int
solve2 pos =
  let positions = M.toList $ foldr (\pos -> M.insertWith (+) pos 1) mempty pos
      maxPos = maximum $ fst <$> positions
   in minimum $ getCosts2 maxPos positions

getCosts2 :: Int -> [(Int, Int)] -> [Int]
getCosts2 maxPos positions =
  let posCosts = getCost2 <$> positions
   in sum <$> transpose posCosts
  where
    allPos = [0 .. maxPos]
    costList = cost2 <$> allPos
    getCost2 (pos, num) =
      let posDiff = (\x -> abs (pos - x)) <$> allPos
       in fmap (* num) $ (costList !!) <$> posDiff