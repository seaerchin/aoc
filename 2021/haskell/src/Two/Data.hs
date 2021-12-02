module Two.Data where

import Data.Char (digitToInt)
import Flow
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