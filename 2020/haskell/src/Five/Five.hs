module Five.Five where

import Utils
import Data.List

driver = do 
    input <- getInput "data.txt"
    let rows = map splitStrings input 
        seated = map (\(x, y) -> (fst $ getSeating x, fst $ getSeating y)) rows 
        seatIDs = sort $ map getSeatID seated
        withSeats = f seatIDs
    -- print (maximum seatIDs)
    print $ filter withSeats [0..935]
    return ()

splitStrings :: String -> (Seating, Seating)
splitStrings ls = (rows, cols)
    where 
        rows = RowSeats $ map mkRow $ take 7 ls
        cols = ColSeats $ map mkCol $ take 3 $ drop 7 ls
        test = take 7 ls

getSeating :: Seating -> (Int, Int)
getSeating (RowSeats x) = foldl' seated (0, 127) x
getSeating (ColSeats x) = foldl' seated (0, 7) x

getSeatID (x, y) = x * 8 + y

data Row = F | B deriving Show
data Col = L | R deriving Show

data Seating = RowSeats [Row] | ColSeats [Col] deriving Show

class Seats seat where
    seated :: (Int, Int) -> seat -> (Int, Int)

instance Seats Row where 
    seated (low, high) F = (low, (low + high) `div` 2)
    seated (low, high) B = ((low + high) `div` 2 + 1, high)
instance Seats Col where 
    seated (low, high) L = (low, (low + high) `div` 2)
    seated (low, high) R = ((low + high)`div` 2 + 1, high)

f seats id = id + 1 `elem` seats && id - 1 `elem` seats && id `notElem` seats

mkRow 'F' = F 
mkRow 'B' = B
mkRow _ = error ""

mkCol 'L' = L
mkCol 'R' = R
mkCol _ = error ""


