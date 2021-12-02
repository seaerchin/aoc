module Main where

import Lib
import One.Data
import RIO
import System.IO (print)

main :: IO ()
main = do
  input <- getInput "src/One/data.txt"
  case input of
    Left ue -> error $ show ue
    Right t -> do
      let ans = solve2 $ inputToInteger t
      print ans