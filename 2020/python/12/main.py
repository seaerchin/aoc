def navigate(inst): 
    DIR = [(0, 1), (-1, 0), (0, -1), (1, 0)]
    x, y = 0, 0
    facing = 0 # eswn; indexed using pos in dir array

    CMD = {
        "N": lambda x, y, units: (x + units, y),
        "S": lambda x, y, units: (x - units, y),
        "E": lambda x, y, units: (x, y + units),
        "W": lambda x, y, units: (x, y - units),
        "L": lambda units, dir: (dir - units // 90) % 4,
        "R": lambda units, dir: (dir + units // 90) % 4,
        "F": lambda x, y, units, dir: (x + DIR[dir][0] * units, y + DIR[dir][1] * units) 
    }

    for i in inst:
        cmd, num = i[0], int(i[1:])
        if cmd in "NSEW":
            x, y = CMD[cmd](x, y, num)
        elif cmd in "LR":
            facing = CMD[cmd](num, facing)
        else:
            x, y = CMD[cmd](x, y, num, facing)
    return abs(x) + abs(y)

def waypoint(inst): 
    ship = complex(0, 0)
    waypoint = complex(10, 1) 

    CMD = {
        "N": lambda waypoint, units: waypoint + complex(0, units),
        "S": lambda waypoint, units: waypoint + complex(0, -units),
        "E": lambda waypoint, units: waypoint + complex(units, 0),
        "W": lambda waypoint, units: waypoint + complex(-units, 0),
        "L": lambda waypoint, units: waypoint * complex(0, 1) ** (units // 90),
        "R": lambda waypoint, units: waypoint * complex(0, -1) ** (units // 90),
        "F": lambda ship, waypoint, units: ship + waypoint * units 
    }

    for i in inst:
        cmd, units = i[0], int(i[1:])
        if cmd in "NSEWLR":
            waypoint = CMD[cmd](waypoint, units)
        else: 
            ship = CMD[cmd](ship, waypoint, units)
    return ship

if __name__ == "__main__":
    with open("data.txt", "r") as f:
        input = f.read().splitlines()
        # print(navigate(input))
        print(waypoint(input))
