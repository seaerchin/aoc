module Eight.Eight where

import Data.Either (rights)
import Data.Map ((!))
import qualified Data.Map as M
import Text.Parsec hiding (count, getInput, parse, uncons)
import qualified Text.Parsec as Parsec
import Utils

data Sign = Negative | Positive deriving (Show)

data Instruction = NOP Int | ACC Int | JMP Int deriving (Show)

type Executable = [Instruction]

type Ptr = Int

type Acc = Int

driver = do
  input <- getInput "data.txt"
  let parsed = rights $ map (parse instruction) input
      point = wrapped (0, 0) M.empty (map toInstructions parsed)
  print point

  return ()

generate :: Executable -> [Executable]
generate = foldl foldingFunction []

-- if the current instruction is a NOP/JMP we can change it
foldingFunction :: [Executable] -> Instruction -> [Executable]
foldingFunction = undefined

-- acc -> ptr -> ...
exec :: Acc -> Ptr -> Instruction -> (Acc, Ptr)
exec x ptr (NOP _) = (x, ptr + 1)
exec x ptr (ACC y) = (x + y, ptr + 1)
exec x ptr (JMP y) = (x, ptr + y)

-- we wrap exec in a map
-- for every ptr value, we will check if it is executed before
-- if yes nvm
-- otherwise, return that value
wrapped :: (Acc, Ptr) -> M.Map Int Bool -> [Instruction] -> (Ptr, Bool)
wrapped (acc, ptr) m input
  | ptr `M.member` m = (acc, False) -- already seen
  | ptr >= length input = (acc, True) -- not seen and exceeds # of instructions
  | otherwise = wrapped (acc', ptr') m' input
  where
    (acc', ptr') = exec acc ptr curIns
    curIns = input !! ptr
    m' = M.insert ptr True m

toInstructions :: (String, String) -> Instruction
toInstructions ("nop", '-' : x) = NOP (negate $ read x :: Int)
toInstructions ("nop", '+' : x) = NOP (read x :: Int)
toInstructions ("acc", '-' : x) = ACC (negate $ read x :: Int)
toInstructions ("acc", '+' : x) = ACC (read x :: Int)
toInstructions ("jmp", '-' : x) = JMP (negate $ read x :: Int)
toInstructions ("jmp", '+' : x) = JMP (read x :: Int)

-- toInstructions _ = undefined

-- an instruction is a series of words then an instruction followed by a sign
instruction :: Parser (String, String)
instruction = do
  instruction <- many1 letter
  char ' '
  sign <- char '+' <|> char '-'
  nums <- many1 digit
  return (instruction, sign : nums)