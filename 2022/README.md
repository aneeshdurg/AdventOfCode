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

# Day 3 - Javascript

time constrained today - going to use JS since I know it well. Not a lot to say,
if I had more time, I might've tried to use nodeJS or something so I could've
used the native fs API, but my janky readfile function I've been carrying around
will have to do.

# Day 4 - Julia

I have a bit more time today, so let's learn a new lang! Julia seems super cool
and I've always lowkey wanted to learn it, so this might be a fun time to test
it out a bit.

Overall - it was pretty easy! I loved julia's approach to defining lambdas, and
all in all, it felt like becoming productive with it was a very fast experience.
In terms of ease, it felt reminiscent of python. I could even see myself using
it as a scripting language in general, though I'm still not sure if it's better
than python for that.

# Day 5 - Scheme

The first time I tried to learn a lisp was in my first year of undergrad, and I
honestly did not understand anything. I briefly became interested in lisps again
when I took PL, but I never really wrote a "real" program with it. Now, having
used it for real (albeit, probably not completely idomatically), I'm not a fan.

As a language - it's super cool and elegant. As a tool to solve problems, parts
of it felt painful. That being said, I think it might be fun to revisit the lisp
family later in this challenge.
