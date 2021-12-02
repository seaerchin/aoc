module Main where

import Lib
import RIO
import System.IO (print)
import Text.Parsec (parse)
import qualified Two.Data as Two

main :: IO ()
main = do
  input <- getInput "src/Two/data.txt"
  case input of
    Left ue -> error $ show ue
    Right t -> do
      let parsedInput = rights $ parse Two.parseInst "" <$> t
          ans = Two.solve2 parsedInput
      print ans
