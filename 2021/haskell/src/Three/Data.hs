module Three.Data where

import Data.Foldable (length)
import Data.Text (count, head, index)
import Flow
import RIO hiding (length)
import qualified RIO.List.Partial as List (head)
import RIO.Text (singleton, transpose)
import qualified RIO.Text as Text (foldr, pack)

solve1 :: [Text] -> Integer
solve1 arr =
  let cols = transpose arr
      gamma = extract mostCommon cols
      epsilon = extract leastCommon cols
   in gamma * epsilon

-- returns the most common character in the current col
mostCommon :: Text -> Text
mostCommon cols =
  let ones = singleton '1'
      zeroes = singleton '0'
   in if count ones cols >= count zeroes cols then ones else zeroes

leastCommon :: Text -> Text
leastCommon cols =
  let mcc = mostCommon cols
   in if mcc == singleton '1' then singleton '0' else singleton '1'

extract :: (Text -> Text) -> [Text] -> Integer
extract f ls = foldr g (0, 0) ls |> snd
  where
    g cur (idx, acc) =
      let curChar = f cur |> toInt
          value = 2 ^ (idx * curChar) * curChar
       in (idx + 1, acc + value)

toInt :: Text -> Integer
toInt t = case head t of
  '1' -> 1
  '0' -> 0
  _ -> error "should only receive 0 or 1"

solve2' :: (Text -> Text) -> [Text] -> Integer
solve2' filterFunc arr = recurse filterFunc arr 0 |> calcBin

recurse :: (Text -> Text) -> [Text] -> Integer -> Text
recurse filterFunc sub idx =
  if length sub == 1
    then List.head sub
    else
      let mcc = filterFunc $ extractCols (transpose sub) idx
          filtered = filter (\t -> index t (fromInteger idx) == head mcc) sub
       in recurse filterFunc filtered (idx + 1)

extractCols :: [Text] -> Integer -> Text
extractCols t idx = Text.pack $ flip index (fromInteger idx) <$> transpose t

solve2 :: [Text] -> Integer
solve2 arr =
  let oxy = solve2' mostCommon arr
      co2 = solve2' leastCommon arr
   in oxy * co2

calcBin :: Text -> Integer
calcBin ls = Text.foldr g (0, 0) ls |> snd
  where
    g cur (idx, acc) =
      let curChar = singleton cur |> toInt
          value = 2 ^ (idx * curChar) * curChar
       in (idx + 1, acc + value)
