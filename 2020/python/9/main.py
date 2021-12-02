from collections import defaultdict

def xmas(pre, cur):
    dp = {i: True for i in pre}
    for i in pre: 
        if cur - i in dp:
            return True 
    return False

def contiguous(ls, target):
    l, r = 0, 0 
    s = ls[0]
    while r < len(ls) and l <= r: 
        if s == target: 
            return ls[l: r + 1]
        if s > target: 
            s -= ls[l]
            l += 1 
        elif s < target: 
            r += 1 
            s += ls[r]
    return []

def first_invalid(pre, l = 25): 
    prev = pre[:l]
    nxt = pre[l:]
    cur = nxt.pop(0)
    while nxt and xmas(prev, cur):
        prev, cur = prev[1:] + [cur], nxt.pop(0)
    return cur

if __name__ == "__main__":
    with open("data.txt", "r") as f:
        input = list(map(int, f.read().splitlines()))
        weakness = first_invalid(input, 25)
        print(weakness)
        res = contiguous(input, weakness)
        print(max(res) + min(res))