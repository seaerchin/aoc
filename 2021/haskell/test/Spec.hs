import Lib
import One.Data
import RIO
import Test.Hspec

-- | Test for part 1, to ensure that the test case provided is correct
testOneOne :: [Int] -> IO ()
testOneOne input = do
  solve1 input `shouldBe` 7

testOneTwo :: [Int] -> IO ()
testOneTwo input = do
  solve2 input `shouldBe` 5

main :: IO ()
main = hspec do
  describe "Utility Tests" do
    it "should return the file's contents" $ do
      input <- getInput "test/test.txt"
      case input of
        Left ue -> error (show ue)
        Right t -> t `shouldBe` ["some", "data"]
  describe "AOC 2021 Tests" do
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