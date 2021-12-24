module Eight.Data where

import Data.Text (pack, splitOn)
import qualified Data.Text as T (length)
import Lib
import RIO
import qualified Text.Parsec as P
import Text.Parsec.Text (Parser)

solve1 :: Matrix Text -> Int
solve1 = sum . fmap go
  where
    go = length . filter f
    f t = T.length t == 2 || T.length t == 3 || T.length t == 4 || T.length t == 7

-- returns a single line
-- ignores everything before '|'
parseInst :: Parser [Text]
parseInst = do
  _ <- P.manyTill P.anyToken $ P.char '|'
  _ <- P.space
  splitOn " " . pack <$> P.many P.anyChar

parseInput :: [Text] -> Matrix Text
parseInput s = unsafeUnwrap <$> fmap (P.parse parseInst "input stream") s