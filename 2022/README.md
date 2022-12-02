# 2022

This year, I'm going to try to do every day in a new language

# Day 1 - bash

Why solve an AoC problem in pure bash? Because it is there.

...it was so painful. I wanted to do the whole thing in pure bash, no coreutils
but once it got to finding the `k` largest numbers instead of just the largest,
I threw in the towel and pulled out `sort` and `tail`. Not the best code I've
ever written, but I did learn something new: using `local` on the same line as a
subshell call makes it impossible to get the exit status of a subshell.

# Day 2 - python

Wanted to get python out of the way so that I couldn't fall back on it for one
of the harder days. I initially thought about doing today's in haskell, but I
thought it would be fun to save languages I'm less familiar with for harder
problems.

To make it more interesting today, I abandonded good practices and instead
focused on making the most clever solution possible - trying to solve the
problem with no if statements.
