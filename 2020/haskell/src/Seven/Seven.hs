module Seven.Seven where

import Utils
import Text.Parsec hiding (count, parse, uncons)
import qualified Text.Parsec as Parsec 
import Data.List ( nub, sort )
import Data.Either ( rights )

-- TODO: understand parsec and come back to do part 2

driver = do 
    input <- Utils.getInput "data.txt"
    let parsed = rights $ map (parse p) input
        ans = f parsed
    print ans
    return ()

-- first two are list of colours 
-- first int is a word 

p :: Parser (String, [(Int, String)])
p = do  
    b <- bag
    string " contain "
    bs <- (string "no other bags" >> return []) <|> (bags `sepBy` string ", ")  
    char '.'
    return (b, bs)

bag :: Parser String
bag = do 
    d1 <- many1 letter 
    char ' ' 
    d2 <- many1 letter 
    string " bag"
    optional $ char 's'
    return $ d1 ++ ' ' : d2

bags :: Parser (Int, String)
bags = do 
    n <- read <$> many1 digit 
    char ' ' 
    b <- bag 
    return (n, b)

-- applies a given function until no further change
converge :: Eq a => (a -> a) -> a -> a 
converge f x = let x' = f x in if x' == x then x else converge f x' 

-- check if a bag can contain a shiny gold 
f bs = length (converge containedBy ["shiny gold"]) - 1 
    where 
        containedBy bs' = nub $ sort $ bs' ++ map fst (filter (matchAny bs') bs) 
        matchAny xs (_, ys) = not $ null [undefined | x <- xs, (_, y) <- ys, x == y]



