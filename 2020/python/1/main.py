from collections import defaultdict
from operator import mul

# find some (i, j) that sum to 2020 
def summed(target, dp): 
    for pos in range(target // 2 + 1):
        if dp[pos] and dp[target-pos]:
            return (pos, target-pos)
    raise AssertionError

if __name__ == "__main__":
    with open("data.txt", "r") as f:
        input = list(map(int, f.readlines()))
        dp = defaultdict(bool, {i: True for i in input})
        for i in input:
            try:
                j, k = summed(2020 - i, dp)
                print(i * j * k)
            except AssertionError:
                pass