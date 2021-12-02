from collections import defaultdict 
from math import inf
from copy import deepcopy

# we define instructions of the form: arg -> (next inst, acc value)
INSTRUCTIONS = {
    "nop": lambda arg, inst, acc: (inst + 1, acc),
    "acc": lambda arg, inst, acc: (inst + 1, acc + arg),
    "jmp": lambda arg, inst, acc: (inst + arg, acc)   
}

def parse_signed(num: str) -> int: 
    if num[0] == '+':
        return int(num[1:])
    return -int(num[1:])

def memo_inst(ls_inst):
    seen = defaultdict(bool)
    acc = 0
    inst = 0
    while not seen[inst] and inst < len(ls_inst):
        op, val = ls_inst[inst].split(" ") 
        seen[inst] = True
        inst, acc = INSTRUCTIONS[op](parse_signed(val), inst, acc)
    if inst < len(ls_inst):
        return acc, False
    return acc, True 

if __name__ == "__main__":
    with open("data.txt", "r") as f:
        input = f.read().splitlines()
        ls = [input]
        for k, v in enumerate(input):
            if v[:3] == "nop":
                tmp = deepcopy(input)
                tmp[k] = "jmp" + v[3:]
                ls.append(tmp)
            elif v[:3] == "jmp":
                tmp = deepcopy(input)
                tmp[k] = "nop" + v[3:]
                ls.append(tmp)
        for i in ls:
            acc, is_ans = memo_inst(i)
            if is_ans:
                print(acc)