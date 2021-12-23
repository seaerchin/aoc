module Five.Data where

import Data.List (unfoldr)
import Flow
import RIO
import RIO.Map ((!?))
import qualified RIO.Map as M
import RIO.Partial (read)
import qualified Text.Parsec as P
import Text.Parsec.String (Parser)

type Matrix a = [[a]]

type Point a = (a, a)

-- parse instructions into a nested list of points that require updating
-- take only horizontal/vertical lines
-- we need to update all these points

solve1 :: [(Point Int, Point Int)] -> Int
solve1 = sum . toList . fmap (const 1) . M.filter (> 1) . foldr (flip updateMapWithList) mempty . expandMatrix . filter (\(a, b) -> not $ isDiagonalLine a b)


isDiagonalLine :: Point Int -> Point Int -> Bool
isDiagonalLine (x1, y1) (x2, y2) = x1 /= x2 && y1 /= y2

unsafeUnwrap :: Show a => Either a b -> b
unsafeUnwrap (Left a) = error ("you done goofed: " ++ show a)
unsafeUnwrap (Right b) = b

parseInst :: [String] -> [(Point Int, Point Int)]
parseInst s =
  let x = fmap (P.parse parseSingle "input stream") s
   in unsafeUnwrap <$> x
  where
    parseSingle :: Parser (Point Int, Point Int)
    parseSingle = do
      p <- parsePoint
      _ <- P.string " -> "
      p2 <- parsePoint
      pure (p, p2)

parsePoint :: Parser (Point Int)
parsePoint = do
  d <- read <$> P.many1 P.digit
  _ <- P.char ','
  d2 <- read <$> P.many1 P.digit
  pure (d, d2)

updateMapWithList :: Map (Point Int) Int -> [Point Int] -> Map (Point Int) Int
updateMapWithList = foldl' updateMap

updateMap :: Map (Point Int) Int -> Point Int -> Map (Point Int) Int
updateMap m point =
  case m !? point of
    Nothing -> M.insert point 1 m
    Just n -> M.insert point (n + 1) m

expandMatrix :: [(Point Int, Point Int)] -> Matrix (Point Int)
expandMatrix = fmap expandPoints
  where
    -- this has to be general enough to apply to diagonal
    expandPoints :: (Point Int, Point Int) -> [Point Int]
    expandPoints (x@(x1, y1), y@(x2, y2)) = unfoldr f seed
      where
        isHorizontal = x1 /= x2 -- implies y1 == y2
        seed
          -- if it's diagonal, this will still work
          | not isHorizontal = if y1 > y2 then y else x
          | otherwise = if x1 > x2 then y else x
        other = if x == seed then y else x
        f (x, y)
          | not isHorizontal = if y == snd other + 1 then Nothing else Just ((x, y), (x, y + 1))
          | otherwise = if x == fst other + 1 then Nothing else Just ((x, y), (x + 1, y))
