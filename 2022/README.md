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

# Day 6 - Nim

Trying nim has been on my todo list for years. I have mixed feelings about it.
It feels like c and python combined, but the type system actually seems pretty
cool. I did not appreciate that they didn't just call sequence "vector". Maybe a
sequence is not the same as a vector under the hood? Easy day overall.

# Day 7 - Ada

Pretty cool. The type system is very neat, and totally not what I expected. For
some reason, I thought Ada was C but fancier, but this is much much nicer than
C. Some of it feels more verbose than necessary, but overall, I think it seems
pretty usable. I'd definitely like to revisit Ada and try rwriting something
more complex in the future.

# Day 8 - x86_64

I've been unable to complete this one. Maybe learning assembly in 1hr isn't as
easy as I thought. Dissapointing, but I guess I have to move on.

So I spent some extra time and got part 1 working! It was quite the struggle and
I definitely learned a lot about how to approach learning something like
assembly. I think I'll skip part 2 though - I think I know how I would do it,
but I've spent far too much time on this already. I'm a full 2 days behind!

# Day 9 - Zig

I've used zig before and found it to be underwhelming. But the allocator stuff
is pretty cool (though rust's lifetimes is a much better approach). The standard
library has come a long way since when I first tried it, and the stdlib is
pretty easy to work with. The problem itself was also fun - my design for the
first half made the second half pretty easy.

# Day 10 - F\#

F# is a weird language. I'm not sure what the intended usecase really is. It's
got some cool syntax, but it just feels like haskell for dotnet, but not quite.
Either way, it was still fun to use, and felt quick to learn.

# Day 11 - perl

Cool problem today. Got to flex some math skills with the realization that we
can just do all caluclations % the LCM of all the divisibility tests (but just
taking the product of the all the divisibility tests was good enough). Perl as a
language was somewhat lame - I can see why python is more prevalent in this day
and age. That being said, it has cool ideas, and I see why it was an important
historical stepping stone.

# Day 12 - cypher

Today's problem seemed like it could be solved by graphs. As someone who works
on implementing openCypher professionally, using cypher seemed like a
no-brainer. I can't say I learned anything super new in this process, but
implementing the data ingest in cypher itself was a fun excercise. The graph
creation queries were a little slow, but the `shortestPath` queries were really
fast!

# Day 13 - lua

I've always wanted to learn lua so I can start moving my neovim config from
vimscript to lua. Pretty cool language, I guess the main advantage of lua vs
python is the lighterweight runtime + less complexity?

As far as scripting in general goes, it was fine. I don't think I could have
solved this significantly faster in python or something.
