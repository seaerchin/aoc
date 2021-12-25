module Lib where

import Data.Text.Read as Text (decimal)
import RIO
import RIO.ByteString (readFile)
import qualified RIO.Text as Text
import qualified Text.Parsec as P
import Text.Parsec.Text (Parser)

type Matrix a = [[a]]

type Point a = (a, a)

-- getInput reads from a file path and returns the output as a list of strings
getInput :: FilePath -> IO (Either UnicodeException [Text])
getInput path =
  do
    contents <- readFile path
    -- return $ Text.lines
    pure $
      Text.decodeUtf8' contents
        >>= \text -> pure $ Text.lines text

inputToInteger :: [Text] -> [Int]
inputToInteger ls = rights $ fmap fst . decimal <$> ls

-- guarantees that the result is successful
unsafeUnwrap :: Show a => Either a b -> b
unsafeUnwrap (Left a) = error ("you done goofed: " ++ show a)
unsafeUnwrap (Right b) = b

withParser :: Parser a -> [Text] -> [a]
withParser p = fmap (unsafeUnwrap . P.parse p "input stream")

todo :: [Char] -> a
todo = error