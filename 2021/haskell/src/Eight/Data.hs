module Eight.Data where

import Data.List (groupBy, head, intersect, sort, splitAt, tail, union, (!!), (\\))
import Data.Text (init, pack, splitOn, unpack)
import qualified Data.Text as T (length)
import qualified Debug.Trace as Debug
import Flow
import Lib
import RIO
import qualified Text.Parsec as P
import Text.Parsec.Text (Parser)

-- | Parsing functions begin here

-- returns a single line
-- ignores everything before '|'
parseInst :: Parser [Text]
parseInst = do
  _ <- P.manyTill P.anyToken $ P.char '|'
  _ <- P.space
  splitOn " " . pack <$> P.many P.anyChar

parseInput :: [Text] -> Matrix Text
parseInput = withParser parseInst

parseFullInst :: Parser ([Text], [Text])
parseFullInst = do
  _txt1 <- P.manyTill P.anyToken $ P.char '|'
  let txt1 = splitOn " " $ init $ pack _txt1 -- take all but last char as last char is a space
  _ <- P.space
  txt2 <- splitOn " " . pack <$> P.many P.anyChar
  pure (txt1, txt2)

parseFullInput :: [Text] -> [([Text], [Text])]
parseFullInput = withParser parseFullInst

-- | Type defs and typeclasses here
data Letter = A | B | C | D | E | F | G deriving (Show, Eq, Ord, Enum)

{-
 __ <- 0
|__| <- (1, 2, 3) where the middle _ is 2
|__| <- (4, 5, 6), where the middle _ is 5
-}

-- this holds either the letter itself or the possibilities at the position
newtype Segment = Segment [Maybe Letter] deriving (Show, Eq)

-- this should accept generic type parameters but we'll see about them later
newtype And = And Segment deriving (Show, Eq)

newtype Or = Or Segment deriving (Show, Eq)

-- | Actual code solving the problem

-- | Warning: this function checks at runtime that
-- if the two values are Justs, that the values contained within the Justs
-- are identical. Otherwise, this crashes as a required assertion has failed.
narrow :: (Eq a, Show a) => Maybe a -> Maybe a -> Maybe a
narrow (Just a) (Just b) = if a == b then Just b else error $ "expected equal numbers but got: " ++ show a ++ "and : " ++ show b
narrow _ Nothing = Nothing
narrow Nothing _ = Nothing

overlap :: (Eq a, Show a) => Maybe a -> Maybe a -> Maybe a
overlap (Just a) (Just b) = if a == b then Just b else error $ "expected equal numbers but got: " ++ show a ++ "and : " ++ show b
overlap (Just a) Nothing = Just a
overlap Nothing (Just a) = Just a
overlap Nothing Nothing = Nothing

extractList :: Segment -> [Maybe Letter]
extractList (Segment a) = a

instance Semigroup And where
  (And a) <> (And b) = And $ Segment $ uncurry narrow <$> zip (extractList a) (extractList b)

instance Semigroup Or where
  (Or a) <> (Or b) = Or $ Segment $ uncurry overlap <$> zip (extractList a) (extractList b)

emptySegment :: Segment
emptySegment = Segment (replicate 7 Nothing)

solve1 :: Matrix Text -> Int
solve1 = sum . fmap go
  where
    go = length . filter isUnique

isUnique :: Text -> Bool
isUnique t = T.length t == 2 || T.length t == 3 || T.length t == 4 || T.length t == 7

solve2 :: [([Text], [Text])] -> Int
solve2 input' =
  let answer = sum $ (uncurry . uncurry) solveSub <$> zip splitted (snd <$> input)
      splitted = extract . fst <$> input -- extract only the instanced numbers
   in answer
  where
    input = Debug.trace (show input') input'
    -- extracts into (unique, repeated)
    extract :: [Text] -> ([Text], [Text])
    extract = foldr f ([], [])
      where
        f cur (unique, rep)
          | isUnique cur = (cur : unique, rep)
          | otherwise = (unique, cur : rep)
    solveSub :: [Text] -> [Text] -> [Text] -> Int
    solveSub unique repeated required = solve required $ getMapping unique repeated
    -- given the puzzle + the segment, returns the int representing the segments
    solve :: [Text] -> Segment -> Int
    solve output mapping =
      let x = sum $ fromSegment mapping <$> output
       in todo "this should return the solution given the output and the mapping; this utilizes fromSegment"

fromSegment :: Segment -> Text -> Int
fromSegment = undefined

fromRaw :: Int -> Text -> Segment
fromRaw = todo "this converts a raw textual input like dag/7 into its segment representation"

fromText :: Text -> Letter
fromText = undefined

getNumber :: Text -> Either [Int] Int
getNumber t
  | T.length t == 2 = Right 1
  | T.length t == 4 = Right 4
  | T.length t == 3 = Right 7
  | T.length t == 7 = Right 8
  | T.length t == 5 = Left [2, 3, 5]
  | otherwise = Left [6, 9]

updateSegment :: Int -> Maybe Letter -> Segment -> Segment
updateSegment index value segment =
  let (pre, suf) = splitAt index (extractList segment)
   in Segment $ pre ++ (value : if null suf then suf else tail suf)

-- TODO: change signatures to Unique -> Repeated -> Segment -> Segment
-- all the info we have now can be extracted from there

zero :: Text -> Text -> Segment -> Segment
zero one seven = updateSegment 0 (Just $ fromText $ seven \\\ one)

oneThree :: Text -> Text -> Segment -> Segment
oneThree seven weird segment =
  -- let weird = foldr (.*.) (head sixes) (tail sixes)
  updateSegment 1 (Just . fromText $ (weird \\\ seven)) segment
    |> updateSegment 3 (Just . fromText $ (seven \\\ weird))

six :: Text -> Text -> Segment -> Segment
six seven cap = updateSegment 6 (Just $ fromText (seven \\\ cap))

-- to get position 4,
-- we just fold across the texts with length 5 using an intersection (call this A)
-- next, obtain sections 1, 3, 5 and concat them (call this B)
-- union A and B (call this C)
-- use 8 \\\ C

-- returns the actual segment itself
getMapping :: [Text] -> [Text] -> Segment
getMapping unique repeated =
  let sortedUnique = sort unique
      sortedRep = sort repeated
      (fives, sixes) = span (\x -> T.length x == 5) sortedRep
      segmentOne = head sortedUnique
      segmentSeven = sortedUnique !! 1
      segmentFour = sortedUnique !! 2
      segmentEight = sortedUnique !! 3
   in todo "given the unique and repeated segments, this returns the full segment mapping (ie, which letter belongs where)"

(.+.) :: Text -> Text -> Text
a .+. b = pack $ unpack a `union` unpack b

(.*.) :: Text -> Text -> Text
a .*. b = pack $ unpack a `intersect` unpack b

(\\\) :: Text -> Text -> Text
a \\\ b = pack $ unpack a \\ unpack b