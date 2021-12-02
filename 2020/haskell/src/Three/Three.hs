module Three.Three where
{-# OPTIONS_GHC -fwarn-incomplete-patterns #-}
import Prelude hiding (Right)
import Utils

data Square = Tree | Open deriving Eq 

makeSquare :: String -> Square 
makeSquare "#" = Tree 
makeSquare "." = Open 
makeSquare _ = error "fk"

dirs :: [(Int, Int)]
dirs = [(1, 1), (3, 1), (5, 1), (7, 1), (1, 2)]

driver :: IO ()
driver = do 
    input <- getInput "data.txt"
    -- first map [string] -> [square]
    -- then pass it in
    let grid = map (cycle . stringToSquare) input 
        count = countTrees grid
        treeCounts = map (\(x, y) -> count (Right x) (Down y)) dirs
        res = product treeCounts
    print res
    return ()

data Direction = Right Int | Down Int
data Coord = Coord Int Int

-- given a particular value, traverses the grid and returns 
countTrees :: Num a => [[Square]] -> Direction -> Direction -> a
countTrees grid right down = 
    let path = traverseSlope right down grid
        treeValues = map (\(x, y) -> grid !! y !! x) path 
    in foldr (\tree count -> if tree == Tree then count + 1 else count) 0 treeValues

-- takes right -> down -> list
traverseSlope :: Direction -> Direction -> [[Square]] -> [(Int, Int)]
traverseSlope _ _ [] = [(0, 0)]
traverseSlope (Right dx) (Down dy) grid = traverseSlope' (Coord 0 0)
    where 
        traverseSlope' :: Coord -> [(Int, Int)]
        traverseSlope' (Coord x y)
            | y >= length grid = []
            | otherwise = (x, y) : traverseSlope' (Coord (x + dx) (y + dy))
traverseSlope _ _ _ = [(0, 0)]

stringToSquare :: String -> [Square] 
stringToSquare = map (\c -> makeSquare [c]) 