import Lib
import qualified One.Data as One
import RIO
import Test.Hspec
import Text.Parsec (parse)
import qualified Two.Data as Two

-- | Test for part 1, to ensure that the test case provided is correct
testOneOne :: [Int] -> IO ()
testOneOne input = do
  One.solve1 input `shouldBe` 7

testOneTwo :: [Int] -> IO ()
testOneTwo input = do
  One.solve2 input `shouldBe` 5

testTwo :: [Two.Inst] -> IO ()
testTwo arr =
  let expected = 150
      actual = Two.solve1 arr
   in actual `shouldBe` expected

main :: IO ()
main = hspec do
  describe "Utility Tests" do
    it "should return the file's contents" $ do
      input <- getInput "test/test.txt"
      case input of
        Left ue -> error (show ue)
        Right t -> t `shouldBe` ["some", "data"]
  describe "AOC 2021 Tests" do
    describe "Day 1" do
      it "should return the number of times the count decreased" $ do
        input <- getInput "src/One/test.txt"
        case input of
          Left ue -> error $ show ue
          Right t -> testOneOne $ inputToInteger t
      it "should have the sliding window correct" $ do
        input <- getInput "src/One/test.txt"
        case input of
          Left ue -> error $ show ue
          Right t -> testOneTwo $ inputToInteger t
    describe "Day 2" do
      it "should return 150" $ do
        input <- getInput "src/Two/test.txt"
        case input of
          Left ue -> error $ show ue
          Right t -> do
            let parsedInput = rights $ parse Two.parseInst "" <$> t
            testTwo parsedInput
