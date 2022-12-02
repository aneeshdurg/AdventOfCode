import sys

def get_score(mine, opponent):
    # r = 0, p = 1, s = 2. Given two moves a, b. a beats b iff a = (b + 1) % 3
    # so we do (mine - opponent) % 3 which gives:
    #   draw: 0
    #   win: 1
    #   loss: 2
    # Then we do _ + 1:
    #   draw: 1
    #   win: 2
    #   loss: 3
    # modulo 3:
    #   draw: 1
    #   win: 2
    #   loss: 0
    # times 3:
    #   draw: 3
    #   win: 6
    #   loss: 0
    # plus points for the selected move (mine + 1)
    return ((mine - opponent) % 3 + 1) % 3 * 3 + (mine + 1)

def part1(input_lines):
    total_score = 0

    for line in input_lines:
        moves = line.split(" ")
        opponent = ord(moves[0]) - ord('A')
        mine = ord(moves[1]) - ord('X')

        total_score += get_score(mine, opponent)

    print(total_score)

def part2(input_lines):
    total_score = 0

    for line in input_lines:
        moves = line.split(" ")
        opponent = ord(moves[0]) - ord('A')
        outcome = ord(moves[1]) - ord('X')
        mine = (opponent + outcome - 1) % 3
        total_score += get_score(mine, opponent)

    print(total_score)

if __name__ == "__main__":
    input_lines = []
    while True:
        try:
            input_lines.append(input())
        except Exception:
            break

    part1(input_lines)
    part2(input_lines)
