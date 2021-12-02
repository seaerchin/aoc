def upper(high, low): 
    return (high + low) // 2 + 1, high 

def lower(high, low):
    return low, (high + low) // 2

def parse(input, high, low, lh, ll): 
    for i in input: 
        if i == lh:
            low, high = upper(high, low)
        else:
            low, high = lower(high, low)
    assert low == high
    return low

def form_id(tup):
    row, col = tup
    return row * 8 + col

if __name__ == "__main__":
    with open("data.txt", "r") as f:
        input = f.read().splitlines()
        input = list(map(lambda x: (parse(x[:-3], 127, 0, "B", "F"), parse(x[-3:], 7, 0, "R", "L")), input))
        print(input)
        print(max(list(map(form_id, input))))
        dp = [[False for i in range(8)] for j in range(128)]
        for row, col in input: 
            dp[row][col] = True
        res = []
        for idx, row in enumerate(dp):
            for i, col in enumerate(row): 
                if not col:
                    res.append((idx, i))
        print(res)