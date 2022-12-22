import subprocess
import os

def part2(send):
    with open("input.txt") as f:
        monkeys = f.readlines()

    send("#include <iostream>")
    send("#include <stdlib.h>")
    send("#include <stdint.h>")

    for m in monkeys:
        send("int64_t {}();".format(m[:4]))
    send("int64_t h_val = 0;")

    root_a = None
    root_b = None

    for m in monkeys:
        name = m[:4]
        op = m[5:]
        if name == "humn":
            op = "h_val"
        op_parts = op.split()
        if name == "root":
            op_a = op_parts[0]
            op_op = op_parts[1]
            op_b = op_parts[2]

            root_a = op_a
            root_b = op_b
            send(f"int64_t {m[:4]}() {{")
            send(f"  return {op_a}() == {op_b}();")
            send(f"}}")
        elif (len(op_parts) > 1):
            op_a = op_parts[0]
            op_op = op_parts[1]
            op_b = op_parts[2]

            send(f"int64_t {m[:4]}() {{")
            send(f"  return {op_a}() {op_op} {op_b}();")
            send(f"}}")
        else:
            send(f"int64_t {m[:4]}() {{ return {op}; }}")

    send("int main() {")
    send("  h_val = 1;")
    send("  int64_t velocity = 1;")
    send(f"  while ({root_a}() > {root_b}()) {{")
    send("     h_val += 1 * velocity;")
    send("     velocity += 1000;")
    send("  }")
    send("  velocity = 1;")
    send(f"  while ({root_a}() < {root_b}()) {{")
    send("     h_val -= 1 * velocity;")
    send("     velocity += 500;")
    send("  }")
    send(f"  while ({root_a}() > {root_b}()) {{")
    send("     h_val += 1;")
    send("  }")
    send("  std::cout << h_val  << ' ' << wvvv() << ' ' << whqc()<< \"\\n\";")
    send("  return 0;")
    send("}")

def send(x):
    p.stdin.write(x.encode())
    p.stdin.write("\n".encode())
p = subprocess.Popen("clang++ -x c++ -O3 -".split(), stdin=subprocess.PIPE)
part2(send)
p.stdin.close()
p.wait()
subprocess.check_call(["./a.out"])
