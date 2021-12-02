from collections import defaultdict

class MemoryBus:
    def __init__(self):
        self.mask = ""
        self.memory = defaultdict(int)
    
    def write(self, index, value): 
        index = self.with_mask(index)
        # print(index)
        addr = self.parse_addr(index, [""])
        print(addr)
        for i in addr: 
            self.memory[i] = value

    # this is a recursive call
    def parse_addr(self, addr, cur):
        if not addr:
            return cur
        res = []
        x = addr[0]
        if x == "X": 
            for i in cur:
                res.append(i + '1')
                res.append(i + '0')
        else:
            for i in cur:
                res.append(i + x)
        return self.parse_addr(addr[1:], res)

    # value is a str
    def with_mask(self, value): 
        value = bin(int(value))[2:]
        padded = self.pad(value)
        masked = ''
        for i in range(len(padded)): 
            # if self.mask[i] == 'X':
            #     masked += padded[i]
            # else:
            #     masked += self.mask[i]
            if self.mask[i] == 'X': 
                masked += 'X'
            else: 
                if self.mask[i] == '1':
                    masked += self.mask[i] 
                else: 
                    masked += padded[i]
        return masked
    
    def pad(self, value):
        return '0' * (len(self.mask) - len(value)) + value

if __name__ == "__main__":
    with open("data.txt", "r") as f:
        input = list(map(lambda x: x.split(' '), f.read().splitlines()))
        mem = MemoryBus()
        for line in input:
            inst = line[0]
            if inst == 'mask': 
                mem.mask = line[-1]
            else: 
                index, value = inst[4:-1], line[-1]
                mem.write(index, value)
        print(sum([int(x) for x in mem.memory.values()]))
        