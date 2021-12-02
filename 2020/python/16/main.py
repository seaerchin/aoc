from collections import defaultdict
from itertools import takewhile
from typing import Dict
from math import prod

OWN = [83,137,101,73,67,61,103,131,151,127,113,107,109,89,71,139,167,97,59,53]

def parse_rule(rule):
    rule = list(map(lambda x: list(map(lambda y: y.strip(), x.split("-"))), rule.split("or")))
    return lambda x: any(map(lambda y: y(x), list(map(lambda x: within(int(x[0]), int(x[1])), rule))))

def collate_rules(input): 
    rules = dict()
    for i in input:
        name, rule = i[0], parse_rule(i[1])
        rules[name] = rule
    return rules

# this is bad style but ok
within = lambda lower, higher: lambda x: lower <= x <= higher 
create_or = lambda x, y: lambda z: x(z) or y(z)

# first we establish possibilities 
# then we slowly eliminate each 
# returns dict of str -> int (idx of col)
def get_mappings(data, rules: Dict): 
    mappings = defaultdict(list)
    for key, rule in rules.items(): 
        pos = [i for i in range(len(data[0]))]
        for col_idx in pos: 
            subset = list(map(lambda x: x[col_idx], data))
            if all([rule(i) for i in subset]):
                mappings[key].append(col_idx)
    return mappings

if __name__ == "__main__":
    with open("data.txt", "r") as f:
        input = list(map(lambda x: list(map(lambda y: y.strip(), x.split(":"))), f.read().splitlines()))
        collated_rules = takewhile(lambda x: bool(x[0]), input)
        rules = collate_rules(collated_rules)
        nearby = input.index(['nearby tickets', ''])
        rest = list(map(lambda x: list(map(int, x.split(','))), [i[0] for i in input[nearby + 1:]]))
        adheres = lambda x: any([i(x) for i in rules.values()])
        res = list(filter(lambda ticket: all(map(lambda x: adheres(x), ticket)), rest))
        
        # part 2 
        mappings = sorted(get_mappings(res, rules).items(), key = lambda x: len(x[1]))
        biject = []
        seen = defaultdict(bool)
        for name, pos in mappings: 
            ans = list(filter(lambda x: not seen[x], pos)).pop()
            biject.append((name, ans))
            seen[ans] = True
        needed = list(filter(lambda x: "departure" in x[0], biject))
        print(prod(list(OWN[i[1]] for i in needed)))