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
pretty usable. I'd definitely like to revisit Ada and try writing something
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

# Day 14 - ruby

Learning ruby's been on my TODO list for a long time. It's alright - feels like
JS but with looser syntax. I honestly cannot see the hype behind it - maybe the
low barrier of entry and the very forgiving syntax? It feels like theres many
ways to do basic things.

# Day 15 - go

I've done a little go in the past, but I'm always amazed by how easy it is to
parallelize code. Overall, a solid language, with some minor quirks.

# Day 16 - groovy

Part1 was fun, part2 was hard and I couldn't get a fast working solution. Groovy
is cool, but the actors model is a bit complex. go was a lot better at making
multi-threading intuitive.

# Day 21 - C++ (+ python)

Life/work got in the way for the last few days. I stumbled a bit on my "learn
new languages" quest today and just used python/c++. But to make my life hard I
tried to generate a c++ solution with python. My initial goal was to make a
program that evaluates everything as constexprs, but for part2 that proved
difficult, so I gave up and brute forced a solution. The total runtime is under
a second anyway.

# Day 25 - Haskell

It's been a while since I've used haskell. It's always so fun to use. Between
Haskell and F# though, I felt more immediately productive with F# - the lack of
having to worry about introducing side effects for printing was nice. That being
said, functional programming makes it feel so easy to write code that feels
easily testable.

## Conclusion

Overall, this is the end of the road. I probably won't go back and do the days I
missed/didn't finish, but it was a cool experience overall. Here's a brief
summary of things.

* Favorite langauges learned: Julia, Ada - definitely want to try using these
  more.
* Favorite language used overall: go, cypher, python - python is GOATed, cypher
  is really really good at expressing graph traversal intuitively, go's
  multithreading ease is unmatched.
* Most dissapointing languages: scheme, perl - maybe I didn't approach scheme
  correctly, I was editing it in vim afterall. That being said, it felt so
  needlessly painful to write. perl felt overhyped, it was like bash++ IMO.

Some other observations:

* On most days I didn't feel like the choice of language made much of a
  difference. On the days it mattered it REALLY made a difference. Makes me sad
  that integrating multiple languages in a single project is so hard. I'd love
  to write code that does it's threading via go, and then switches over to
  python for less perf critical sections or something.
* Verbosity is not a barrier to entry, but terseness is.
* python is probably the greatest programming language of all time, and
  languages inspired by it, like Julia and Nim, feel like the most likely
  languages to achieve mainstream adoption in the future.
* Functional programming is a really good paradigm for writing code that can be
  well tested.
* AoC problems are nice, but not every problem is equal in that some problems
  made me feel like I really learned the language at hand, and some felt like I
  barely scratched the surface. Also, doing problems in a new language every day
  really made everything take longer - that felt frustrating on some days.
* Languages that were easy to start running with were the best. F# was painful
  in that regard, and I don't know if I followed best practices by commiting the
  full project directory. Languages that have an option to compile or interpret
  were really fun to work with. Having good tools around debugging and IO was
  also crucial.
* Assembly is really painful to work with - I'm glad I'm in this industry at a
  time where our tools are so powerful. I did enjoy feeling like I was seeing
  how the sausage was made.
* The most fun I had was when programming felt like it was about reducing the
  problem to one that's already solved. e.g. using cypher, or the day I used
  python to generate a c++ program to use the compile's call graph reduction
  mechanism instead of implementing some kind of computation graph.

Fun problems, good times, and I hope to do this again next year! (but maybe with
a different twist)
