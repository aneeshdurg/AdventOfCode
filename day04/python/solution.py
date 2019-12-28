#!/usr/bin/env python3

# Hacky solution that works....
def satisfies(x):
    x = [int(c) for c in str(x)]
    for i in range(len(x) - 1):
        if x[i + 1] < x[i]:
            return False
    return len(set(x)) < len(x)

solutions = list(filter(
    satisfies, range(171309, 643603)))
print("Part 1", len(solutions))

def refine(x):
    d = {}
    for c in str(x):
        c = int(c)
        d[c] = d.get(c, 0) + 1
    return 2 in d.values()

print("Part 2", len(list(filter(refine, solutions))))
