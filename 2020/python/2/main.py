from collections import Counter

def get_range(ls):
    return list(map(int, ls.split("-")))

def is_valid(low, high, letter, pw):
    return high >= Counter(pw)[letter] >= low

def is_valid2(low, high, letter, pw): 
    low, high = low - 1, high - 1 
    return Counter([pw[low], pw[high]])[letter] == 1
 
if __name__ == "__main__":
    with open("data.txt", "r") as f:
        input = f.readlines()
        count = 0   
        for line in input:
            ranges, letter, pw = line.split(" ")
            ranges = get_range(ranges)
            letter = letter[:-1]
            count += 1 if is_valid2(ranges[0], ranges[1], letter, pw) else 0
        print(count)
