module Four.Four where

import Utils ( getInput, readTill ) 
import qualified Data.Map as M 
import Data.List.Split ( splitWhen )

requiredFields = ["byr", "iyr", "eyr", "hgt", "ecl", "pid", "cid"]

data Field = BYR Int | IYR Int | EYR Int | HGT Int Unit | ECL String | CID | PID String | HCL String 
    deriving (Show, Eq)

data Unit = CM | IN deriving (Show, Eq)

isValidDigit :: String -> Bool
isValidDigit = all (`elem` "0123456789")
isValidLetter :: String -> Bool
isValidLetter = all (`elem` "abcdef")
isValidHCL :: String -> Bool
isValidHCL = all (`elem` "0123456789abcdef")

validate :: Field -> Bool 
validate (BYR year) = year >= 1920 && year <= 2002
validate (IYR year) = year >= 2010 && year <= 2020 
validate (EYR year) = year >= 2020 && year <= 2030 
validate (HGT height isCm) 
    | isCm == CM = height >= 150 && height <= 193
    | otherwise = height >= 59 && height <= 76
validate (HCL (x: xs)) = x == '#' && isValidHCL xs && length xs == 6
validate (ECL colour) = colour `elem` ["amb",  "blu" , "brn", "gry", "grn", "hzl", "oth"]
validate (PID s) = length s == 9 && isValidDigit s
validate CID = True
validate _ = True

mkField :: (String, String) -> Field
mkField (key, value) 
    | key == "byr" = BYR (read value :: Int)
    | key == "iyr" = IYR (read value :: Int)
    | key == "eyr" = EYR (read value :: Int)
    | key == "hgt" = 
        let height = takeWhile (`elem` "1234567890") value 
            kind = dropWhile (`elem` "1234567890") value
        in if kind == "cm" then HGT (read height :: Int) CM else HGT (read height :: Int) IN 
    | key == "ecl" = ECL value 
    | key == "pid" = PID value 
    | key == "hcl" = HCL value
    | key == "cid" = CID
    | otherwise  = error "fk"

validatePassport :: [Field] -> Bool 
validatePassport = all validate

driver = do 
    input <- getInput "data.txt"
    let parsedInput = map words input 
        splitter = splitWhen (== [])
        list = splitter parsedInput
        flatList = map concat list
        items = map (map $ readTill ':') flatList
        filtered = filter (checkValidity . toString) items
        fieldItems = map (map mkField) filtered
        validated = filter validatePassport fieldItems
    print filtered
    print $ length validated
    return ()

toString :: [(String, String)] -> [String]
toString = foldr (\(x, y) ls -> x : ls) []

checkValidity :: [String] -> Bool 
checkValidity m = allValid && (length m == 7 && "cid" `notElem` m) || (length m == 8)
    where 
        allValid = foldr (\key prev -> (key `elem` requiredFields || key == "cid") && prev) True requiredFields

toBool Nothing = False 
toBool _ = True 
