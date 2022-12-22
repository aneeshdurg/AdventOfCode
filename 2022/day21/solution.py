import subprocess

def part1(send):
    with open("input.txt") as f:
        monkeys = f.readlines()

    send("#include <iostream>")
    send("#include <stdlib.h>")

    for m in monkeys:
        send("constexpr size_t {}();".format(m[:4]))

    for m in monkeys:
        name = m[:4]
        op = ''.join([x + ('()' if len(x) == 4 else '') for x in m[5:].split()])

        send(f"constexpr size_t {m[:4]}() {{ return {op}; }}")

        if name == "root":
            op_parts = m[5:].split()
            op_a = op_parts[0]
            op_op = op_parts[1]
            op_b = op_parts[2]
            send(f"int main() {{ std::cout << root() << std::endl; return 0; }}")

p = subprocess.Popen("clang++ -x c++ -".split(), stdin=subprocess.PIPE)
def send(x):
    p.stdin.write(x.encode())
    p.stdin.write("\n".encode())
part1(send)
p.stdin.close()
p.wait()
subprocess.check_call(["./a.out"])
