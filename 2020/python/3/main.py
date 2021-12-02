from collections import defaultdict
from operator import mul
from functools import reduce

TREE = '#'
OPEN = "."

def traverse(ls): 
    res = 0
    l = len(ls[0]) - 1
    for k, i in enumerate(ls):
        j = k * 3
        print(k, j, j%l)
        if i[j%l] == TREE:
            res += 1 
    return res

def extract_rows(input, amount):
    return [input[i] for i in range(0, len(input), amount)]

def check_elements(input, amount): 
    l = len(input[0]) - 1
    res = 0 
    for k, i in enumerate(input):
        j = k * amount
        if i[j%l] == TREE:
            res += 1 
    return res


if __name__ == "__main__":
    with open("data.txt", "r") as f:
        input = f.readlines()
        tuples = [(1, 1), (3, 1), (5, 1), (7, 1), (1, 2)]
        get_count = lambda x: check_elements(extract_rows(input, x[1]), x[0])
        count = list(map(get_count, tuples))
        print(reduce(mul, count))
        