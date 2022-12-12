open System.IO

let rec print_list (ls: int list) =
  if not ls.IsEmpty then
    printf "%d " ls.Head
    print_list ls.Tail

// let rec all_zero (ls: int list) =
//   if ls.IsEmpty then
//     true
//   else if ls.Head <> 0 then
//     false
//   else
//     all_zero ls.Tail
// let has_updates (ls: int list, reg, pc, signal_strength) =
//   not (ls.IsEmpty || (all_zero ls))

let finished_n_cycles (ls: int list, reg, pc, signal_strength) n =
  pc >= n

let print_state (ls: int list, reg, pc, signal_strength) =
  printf "X=%d pc=%d ss=%d updates=( " reg pc signal_strength
  print_list ls
  printfn ")"

let get_update (ls: int list) =
  if ls.IsEmpty then
    0
  else
    ls.Head

let pop_if_non_empty (ls: int list) =
  if ls.IsEmpty then
    ls
  else
    ls.Tail

let process_action line (ls: int list, reg, pc, signal_strength) =
  let mutable update: int list = [0]
  let mutable ss_update = 0
  if line <> "noop" then
    update <- update @ [line["addx ".Length..line.Length] |> int]

  if pc = 20 || ((pc - 20) % 40) = 0 then
    ss_update <- pc * reg
  ((pop_if_non_empty ls) @ update, reg + get_update ls, pc + 1, signal_strength + ss_update)

let print_pixel (ls: int list, reg, pc, signal_strength) =
  let xpos = (pc - 1) % 40
  if xpos = 0 then
    printfn ""
  if (abs (reg - xpos)) <= 1 then
    printf "#"
  else
    printf " "

let stream = new StreamReader "./input.txt"
// Continue reading while valid lines.
let mutable valid = true
let mutable state = ([], 1, 0, 0)

while (valid) do
    let line = stream.ReadLine()
    if (line = null) then
        valid <- false
    else
        state <- process_action line state
        print_pixel state

while (not (finished_n_cycles state (40 * 6))) do
    state <- process_action "noop" state
    print_pixel state

printfn ""
  // part1
  // print_state state
