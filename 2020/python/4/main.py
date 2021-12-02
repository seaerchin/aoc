FIELDS = set(["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"])

def hcl(h):
    # wtf this is damn annoying
    return h[0] == "#" and all(map(lambda x: x in set("0123456789abcdef"), h[1:])) and len(h) == 7

RULES = {
    "byr": lambda x: len(x) == 4 and 2002 >= int(x) >= 1920,
    "iyr": lambda x: len(x) == 4 and 2020 >= int(x) >= 2010,
    "eyr": lambda x: len(x) == 4 and 2030 >= int(x) >= 2020,
    "hgt": lambda x: x[-2:] == "cm" and 193 >= int(x[:-2]) >= 150 or x[-2:] == "in" and 76 >= int(x[:-2]) >= 59, 
    "hcl": lambda x: hcl(x), 
    "ecl": lambda x: x in {"amb", "blu", "brn", "gry", "grn", "hzl", "oth"},
    "pid": lambda x: len(x) == 9 and x.isdigit(),
}
def validate(passport, RULES):
    d = dict(passport)
    return set(d) & FIELDS == FIELDS and all([v(d[k]) for k, v in RULES.items()])

def form_dict(fields):
    return {k: v for k, v in fields}

def parse(input):
    res = [] 
    while input:
        inner = [] 
        while input and input[-1]:
            inner.append(input.pop())
        if input: input.pop()
        # i want the flatmap structure here :/
        inner = [j.split(":") for i in map(lambda x: x.split(), inner) for j in i]
        res.append(inner)
    return res

if __name__ == "__main__":
    with open("data.txt", "r") as f:
        input = f.read().splitlines()
        input = parse(input)
        input = map(form_dict, input)
        print(sum(map(lambda x: validate(x, RULES), input)))