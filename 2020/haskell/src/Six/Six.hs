module Six.Six where 

import Data.List
import Utils
import qualified Data.Map as M

driver = do 
    input <- getInput "data.txt"
    let splitted = splitByLines input
        -- lengthUnique = map (length . nub) splitted
        -- uniq = map (\(count, str) -> (count, nub str)) splitted 
        -- filtered = filter (\(count, str) -> length str == count) uniq
        mapped = map (\(x, y) -> (x, formMap y)) splitted
        ans = sum $ map (uncurry withValue) mapped
    -- print $ sum lengthUnique
    print ans
    -- print filtered
    -- print mapped
    return () 
    
-- read until a new line
splitByLines :: [String] -> [(Int, String)]
splitByLines = foldr appendIfNewline []

appendIfNewline :: String -> [(Int, String)] -> [(Int, String)]
appendIfNewline x [] = [(1, x)] 
appendIfNewline x y@(first: rest) 
    | x == "" = (0, ""): y 
    | otherwise = (fst first + 1, x ++ snd first) : rest

-- first foldr across the string and return a map of chars: counts 
-- then convert to counts: char 
insertMap :: Char -> M.Map Char Int -> M.Map Char Int
insertMap c = M.insertWith (+) c 1

formMap :: String -> M.Map Char Int 
formMap = foldr insertMap M.empty 

withValue n = foldr (\mapValue counts -> if mapValue == n then counts + 1 else counts) 0