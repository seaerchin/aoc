from math import inf

def wait_time(start, bus):
    times = map(lambda x: x - start % x, bus)
    bus_table = sorted(zip(times, bus), key = lambda x: x[0])
    wait, bus_num = bus_table[0]
    return wait, bus_num

def lcm(bus):
    bus = enumerate(bus)
    bus = list(map(lambda x: ((x[0], int(x[1])) if x[1] != 'x' else x), bus))
    rem, val = max(bus, key = lambda x: x[1] if x[1] != 'x' else -inf)
    mul = 1
    bus = list(filter(lambda x: x[1] != 'x', bus))
    print(val, rem)
    while True:
        cur = val * mul - rem
        print(cur)
        if all([(cur + id[0]) % id[1] == 0 for id in bus]):
            return cur
        mul += 1
         
if __name__ == "__main__":
    with open("data.txt", "r") as f:
        input = f.read().splitlines()
        start, bus = input
        print(lcm(bus.split(",")))
        bus = list(filter(lambda x: x != 'x', bus.split(',')))
        start, bus = int(start), list(map(int, bus))
        wait, bus_num = wait_time(start, bus)
        # print(wait * bus_num)