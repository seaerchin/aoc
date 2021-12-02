from copy import deepcopy

EMPTY = "L"
FLOOR = "."
OCCUPIED = "#"

def change_state(state): 
    # we encode the rules here because to have it as a separate rules dict seems troublesome
    ADJ = [(i, j) for i in range(-1, 2) for j in range(-1, 2) if not (i == 0 and j == 0)]
    rows, cols = len(state), len(state[0])
    new = deepcopy(state)
    for i in range(rows): 
        for j in range(cols): 
            if state[i][j] == EMPTY:
                adj = [state[i + x][j + y] for (x, y) in ADJ if 0 <= i + x <= rows - 1 and 0 <= j + y <= cols - 1]
                can_flip = all(map(lambda x: x != OCCUPIED, adj))
                if can_flip:
                    new[i][j] = OCCUPIED
            elif state[i][j] == OCCUPIED: 
                adj = [state[i + x][j + y] for (x, y) in ADJ if 0 <= i + x <= rows - 1 and 0 <= j + y <= cols - 1]
                can_flip = sum(map(lambda x: x == OCCUPIED, adj)) >= 4
                if can_flip: 
                    new[i][j] = EMPTY
    return new 

def change_state2(state): 
    ADJ = [(i, j) for i in range(-1, 2) for j in range(-1, 2) if not (i == 0 and j == 0)]
    rows, cols = len(state), len(state[0])
    new = deepcopy(state)
    for i in range(rows): 
        for j in range(cols): 
            adj = []
            for r, c in ADJ:
                m, n = i, j 
                while m in range(rows) and n in range(cols) and (state[m][n] == FLOOR or (m, n) == (i, j)): 
                    m, n = m + r, n + c
                if m in range(rows) and n in range(cols): 
                    adj.append(state[m][n])
            print(adj, i, j)
            if state[i][j] == EMPTY:
                can_flip = all(map(lambda x: x != OCCUPIED, adj))
                if can_flip:
                    new[i][j] = OCCUPIED
            elif state[i][j] == OCCUPIED: 
                can_flip = sum(map(lambda x: x == OCCUPIED, adj)) > 4
                if can_flip: 
                    new[i][j] = EMPTY
    return new 

if __name__ == "__main__":
    with open("data.txt", "r") as f:
        input = f.read().splitlines()
        input = list(map(list, input))
        cur = change_state(input)
        prev = input
        while cur != prev: 
            cur, prev = change_state2(cur), cur
        print(sum(map(lambda x: sum(map(lambda y: y == OCCUPIED, x)), cur)))