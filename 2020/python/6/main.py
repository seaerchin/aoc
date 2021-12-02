from collections import Counter

def splitby(char, string):
    res = []
    idx = 0
    inner = []
    print(string)
    while idx < len(string):
        if string[idx] != char:
            inner.append(string[idx])
        else:
            res.append(inner)
            inner = []
        idx += 1 
    if inner:
        res.append(inner)
    return res

def check(questions): 
    required = len(questions) # how many people in this group
    c = Counter()
    for i in questions:
        c += Counter(i)
    return len(list(filter(lambda x: x[1] == required, c.most_common())))

if __name__ == "__main__":
    with open("data.txt", "r") as f:
        input = f.read().splitlines()
        res = splitby('', input)
        print(res)
        # part 1 
        part1 = list(map(lambda x: len(set([i for j in x for i in j])), res))
        print(sum(part1))
        # part 2 
        print(sum(map(check, res)))
