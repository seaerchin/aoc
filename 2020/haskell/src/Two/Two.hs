module Two.Two where
{-# OPTIONS_GHC -fwarn-incomplete-patterns #-}
import Utils ( getInput, readTill )
import Data.Maybe ( fromMaybe )

driver = do 
    input <- getInput "Two.txt"
    let chunkedInput = map words input 
        res = length $ filter validateRow2 chunkedInput
    -- print $ map (readTill '-' . head) chunkedInput
    print res 

validateRow :: [String] -> Bool 
validateRow row = 
    let rawRanges = readTill '-' (head row)
        (lower, upper) = ((read $ fst rawRanges :: Int), (read $ snd rawRanges :: Int))
        requiredChar = head $ fst $ readTill ':' (row !! 1) -- this is correct
        numChar = countChar requiredChar (row !! 2)
    in lower <= numChar && numChar <= upper

validateRow2 :: [String] -> Bool 
validateRow2 row = 
    let rawRanges = readTill '-' (head row)
        (lower, upper) = ((read $ fst rawRanges :: Int), (read $ snd rawRanges :: Int))
        requiredChar = head $ fst $ readTill ':' (row !! 1) -- this is correct
        stringToCheck = last row
    in (stringToCheck !! (lower - 1) == requiredChar) /= (stringToCheck !! (upper - 1) == requiredChar)

countChar :: Char -> String -> Int 
countChar c "" = 0 
countChar c (x: xs)
    | c == x = 1 + rest
    | otherwise = rest
    where rest = countChar c xs