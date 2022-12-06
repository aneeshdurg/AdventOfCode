import std/strformat
import std/sets

proc all_different(char_seq: seq[char]): bool =
  len(toOrderedSet(char_seq)) == len(char_seq)

proc main() =
  let contents = readFile("input.txt")
  let contentslen = len(contents)

  let seq_len = 14

  var char_seq = newSeq[char](seq_len);
  for i in 0..(len(char_seq) - 1):
    char_seq[i] = '\0'

  var i = 0
  for c in contents:
    char_seq[i mod seq_len] = c
    i = i + 1
    if i == contentslen:
      break
    if i >= seq_len and all_different(char_seq):
      echo i
      echo fmt"{char_seq}"
      break


main()
