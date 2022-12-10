all: solution

solution: solution.o
	gcc -no-pie -o solution solution.o

solution.o: solution.asm
	nasm -f elf64 solution.asm

clean:
	rm -f solution solution.o

.PHONY: all clean
