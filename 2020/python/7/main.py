from collections import defaultdict
from functools import lru_cache

# this is lousy but gets the job done ._.
def parse(line):
    line = line.split(" ")
    outer = " ".join(line[:2])
    inner = [] # we will construct a tuple of (num, colour)
    # this is always of the form 
    # (colour) bags contain (number) (colour) bag(s), (number) (colour) bag(s)
    for i in range(4, len(line), 4):
        if line[i] == 'no':
            break 
        else:
            inner.append((line[i], " ".join(line[i + 1: i + 3])))
    return {"outer": outer, "inner": inner}

# constructs a graph from the given to/from mappings
def construct(mappings): 
    graph = defaultdict(list) # slow but nice to work with
    for mapping in mappings:
        outer = mapping["outer"]
        inner = mapping["inner"]
        for num, colour in inner:
            graph[colour].append((num, outer))
    return graph

# above constructs inner -> outer; this is in reverse direction
def construct2(mappings):
    graph = defaultdict(list) # slow but nice to work with
    for mapping in mappings:
        outer = mapping["outer"]
        inner = mapping["inner"]
        for num, colour in inner:
            graph[outer].append((num, colour))
    return graph

def bfs(graph, target = "shiny gold"): 
    res = 0 
    q = [(0, target)]
    seen = defaultdict(bool)
    while q:
        num, cur = q.pop(0) 
        if not seen[cur]:
            res += 1 
            seen[cur] = True
        for outer in graph[cur]:
            q.append(outer)
    return res - 1

def contains(graph, target = "shiny gold"):
    if target not in graph:
        return 1 
    res = 1
    for inner in graph[target]:
        res = res + int(inner[0]) * contains(graph, inner[1]) 
    return res

if __name__ == "__main__":
    with open("data.txt", "r") as f:
        input = f.read().splitlines()
        res = list(map(parse, input))
        graph = construct(res)
        print(graph)
        print(bfs(graph))
        graph2 = construct2(res)
        print(graph2)
        print(contains(graph2) - 1)