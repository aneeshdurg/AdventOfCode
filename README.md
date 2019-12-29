# Advent Of Code

This repo contains my AoC solutions

## Day 1

Got stuck on part 2 because I was computing the fuel required for the total fuel
required of all components (the part 1 solution) instead of computing the fuel
for every component individually. I learned to read the questions more
carefully.

## Day 2

Pretty straightforward, spent some time trying to cleanup my code and make it
more idiomatic. Using `?` instead of some `match` statements really helped!

## Day 3

I tried to think of a solution better than O(mn) but I couldn't come up with
anything substantially better. I caved and went with the obvious solution in the
end. It wasn't a total loss, because I still got to improve my familiarity with
Rust's datastructures and syntax around iterators in the process.

I did intially mis-interpret the question and assumed that the only possible
intersection points were on the "corners" of the wires, but I caught that pretty
early on.

## Day 4

I ended up with a rust solution that doesn't work that tries to use some
combinatoric logic to figure out the right number. I have a working python
solution that just brute forces its way through. The rust solution aims to work
for any pair of numbers of any length of digits and uses a bunch of recursive
methods to "reason" it's way to the right answer.

Theoretically, the combinatoric way should be way way faster than my python
solution....but I don't really want to debug it... plus the buggy rust solution
is already 100+ lines, but the python is a super clean/readable 24 lines.

For practice I re-implemented the python solution in rust.

Maybe the takeaway here is that I shouldn't over optimize my solutions when I
know I have clear bounds on what's required.

I realize later that using an array instead of a hashmap in my solution would
have sufficied.

## Day 5

The intcode challenges are really fun. I spent some time trying to refactor my
if statement into an array of closures for cleaner syntax, but no dice. Maybe
this could be cleaned up with a macro, but for now I'll leave it alone.
