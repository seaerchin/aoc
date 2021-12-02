module Eleven.Eleven where

import Data.Array
import Debug.Trace
import Utils

data Cell = Floor | Empty | Occupied deriving (Show, Eq)

type Pos = (Int, Int)

type Matrix a = Array Pos Cell

mkPosition :: Char -> Cell
mkPosition '.' = Floor
mkPosition '#' = Occupied
mkPosition 'L' = Empty

updateState :: Matrix Cell -> Matrix Cell
updateState m =
  let items = assocs m
      newList = map update items
   in listArray (bounds m) newList
  where
    update (pos@(x, y), cell) =
      case cell of
        Empty -> if isAdjEmpty cell (getAdj m pos) then Occupied else Empty
        Floor -> Floor
        Occupied -> if numOccupied m pos >= 4 then Empty else Occupied

directions :: [(Int, Int)]
directions = [(i, j) | i <- [-1, 0, 1], j <- [-1, 0, 1], i /= 0 || j /= 0]

isAdjEmpty :: Cell -> [Cell] -> Bool
isAdjEmpty Empty = notElem Occupied

getAdj m p =
  let adj = getAdj' m p
   in trace (show p ++ show adj) adj

getAdj' :: Matrix Cell -> Pos -> [Cell]
getAdj' mat pos =
  let positions = map (~+~ pos) directions
      matElems = assocs mat
      maybePositions = map (`lookup` matElems) positions
      f Nothing prev = prev
      f (Just x) prev = x : prev
   in foldr f [] maybePositions

numOccupied :: Matrix Cell -> Pos -> Int
numOccupied m = sum . map (\x -> if x == Occupied then 1 else 0) . getAdj m

solve :: Matrix Cell -> Int
solve mat =
  let mat' = updateState mat
      mat'' = trace (show $ elems mat') mat'
   in if mat == mat'' then countOccupied mat else solve mat''

-- passes
countOccupied :: Matrix Cell -> Int
countOccupied = sum . map isOccupied . elems
  where
    isOccupied :: Cell -> Int
    isOccupied Occupied = 1
    isOccupied _ = 0

driver =
  getInput "data.txt" >>= \input ->
    let mat = map (map mkPosition) input
        matrix = listArray ((0, 0), (length input - 1, length (head input) - 1)) (concat mat)
        res = solve matrix
     in print res

(~+~) :: (Num a, Num b) => (a, b) -> (a, b) -> (a, b)
(x, y) ~+~ (a, b) = (x + a, y + b)