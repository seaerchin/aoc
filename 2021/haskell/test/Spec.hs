import Data.List (head)
import Data.Text (splitOn, unpack)
import qualified Five.Data as Five
import Lib
import qualified One.Data as One
import RIO
import qualified Six.Data as Six
import Test.Hspec
import Text.Parsec (parse)
import Text.Read (read)
import qualified Three.Data as Three
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

testTwoTwo :: [Two.Inst] -> IO ()
testTwoTwo arr =
  let expected = 900
      actual = Two.solve2 arr
   in actual `shouldBe` expected

testThree :: [Text] -> IO ()
testThree arr =
  let expected = 198
      actual = Three.solve1 arr
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
      it "should return 900" $ do
        input <- getInput "src/Two/test.txt"
        case input of
          Left ue -> error $ show ue
          Right t -> do
            let parsedInput = rights $ parse Two.parseInst "" <$> t
            testTwoTwo parsedInput
    describe "Day 3" do
      it "should return 198" $ do
        input <- getInput "src/Three/test.txt"
        case input of
          Left ue -> error $ show ue
          Right txt -> do
            testThree txt
      it "should return 230" $ do
        input <- getInput "src/Three/test.txt"
        case input of
          Left ue -> error $ show ue
          Right txt -> do
            let expected = 230
                actual = Three.solve2 txt
            actual `shouldBe` expected
    describe "Day 5" do
      it "should return 5" $ do
        input <- getInput "src/Five/test.txt"
        case input of
          Left ue -> error $ show ue
          Right txt -> do
            let expected = 5
                parsed = Five.parseInst (fmap unpack txt)
                actual = Five.solve1 parsed
            actual `shouldBe` expected
      it "should return 12" $ do
        input <- getInput "src/Five/test.txt"
        case input of
          Left ue -> error $ show ue
          Right txt -> do
            let expected = 12
                parsed = Five.parseInst (fmap unpack txt)
                actual = Five.solve2 parsed
            actual `shouldBe` expected
    describe "Day 6" do
      it "should return 5934" $ do
        let expected = 5934
            actual = Six.solve1 80 [3, 4, 3, 1, 2]
        actual `shouldBe` expected
      it "should return 26984457539" $ do
        let expected = 26984457539
            actual = Six.solve1 256 [3, 4, 3, 1, 2]
        actual `shouldBe` expected