from collections import defaultdict

def game(start, goal): 
    dp = defaultdict(lambda: [0, 0]) # store int -> (prev, prev_prev)
    seen = defaultdict(int)
    prev = -1 
    # dp[num] = prev
    for i in range(goal):
        if i % 10 ** 6 == 0:
            print(i)
        if i in range(len(start)): 
            seen[start[i]] += 1
            dp[start[i]][0] = i 
            prev = start[i]
        else: 
            if seen[prev] <= 1:
                spoken = 0
            else: 
                spoken = dp[prev][0] - dp[prev][1]
            dp[spoken] = [i, dp[spoken][0]] 
            prev = spoken 
            seen[spoken] += 1 
    return prev



if __name__ == "__main__":
    with open("data.txt", "r") as f:
        input = list(map(int, f.read().split(',')))
        print(input)
        print(game(input, 30000000))