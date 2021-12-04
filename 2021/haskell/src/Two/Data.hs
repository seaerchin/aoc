module Two.Data where

import Data.Char (digitToInt)
import RIO hiding (Down)
import Text.Parsec.Char as P
import Text.Parsec.Text (Parser)

data Inst = Forward Int | Down Int | Up Int

parseInst :: Parser Inst
parseInst = do
  inst <- parse
  _ <- P.space
  d <- digitToInt <$> digit
  pure $ createInst inst d
  where
    parse = P.string "forward" <|> P.string "down" <|> P.string "up"

createInst :: String -> Int -> Inst
createInst "forward" = Forward
createInst "down" = Down
createInst "up" = Up
createInst _ = error "createInstruction failed - got unknown string"

solve1 :: [Inst] -> Int
solve1 arr =
  let (x, y) = foldr f (0, 0) arr
   in x * y
  where
    f :: Inst -> (Int, Int) -> (Int, Int)
    f cur (x, y) = case cur of
      Forward n -> (x + n, y)
      Down n -> (x, y + n)
      Up n -> (x, y - n)

solve2 :: [Inst] -> Int
solve2 arr =
  let (x, y, _) = foldl' f (0, 0, 0) arr
   in x * y
  where
    f :: (Int, Int, Int) -> Inst -> (Int, Int, Int)
    f (x, y, aim) cur = case cur of
      Forward n -> (x + n, y + aim * n, aim)
      Down n -> (x, y, aim + n)
      Up n -> (x, y, aim - n)
