module Lib where

import Data.Text.Read as Text (decimal)
import RIO
import RIO.ByteString (readFile)
import qualified RIO.Text as Text

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
