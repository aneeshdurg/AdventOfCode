# 2022

This year, I'm going to try to do every day in a new language

# Day 1 - bash

Why solve an AoC problem in pure bash? Because it is there.

...it was so painful. I wanted to do the whole thing in pure bash, no coreutils
but once it got to finding the `k` largest numbers instead of just the largest,
I threw in the towel and pulled out `sort` and `tail`. Not the best code I've
ever written, but I did learn something new: using `local` on the same line as a
subshell call makes it impossible to get the exit status of a subshell.
