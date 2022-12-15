#!/usr/bin/ruby

class Point
   def initialize(x, y)
      @x = x
      @y = y
   end

   def x
     @x
   end

   def y
     @y
   end
end

lines = Array.new
File.readlines('input.txt').each do |line|
  points = line.split(" -> ")
  thisline = Array.new
  points.each do |point|
    coords = point.split(",")
    thisline.append(Point.new(coords[0].to_i, coords[1].to_i))
  end

  lines.append(thisline)
end

$x_min = 500
$x_max = 500
y_max = 0
for i in 0..(lines.length - 1) do
  n = lines[i].length - 1
  for j in 0..n do
    if lines[i][j].x < $x_min then
      $x_min = lines[i][j].x
    end
    if lines[i][j].x > $x_max then
      $x_max = lines[i][j].x
    end
    if lines[i][j].y > y_max then
      y_max = lines[i][j].y
    end
  end
end

$x_max += 1
y_max += 1

puts "%d - %d" % [$x_min, $x_max]
puts y_max


# state is a 2-D array of the cave. 0 = air, 1 = rock, 2 = sand
state = Array.new(y_max)
for i in 0..(y_max - 1) do
  state[i] = Array.new($x_max - $x_min, 0)
end


for i in 0..(lines.length - 1) do
  n = lines[i].length - 1
  current_x = lines[i][0].x
  current_y = lines[i][0].y
  for j in 1..n do
    target_x = lines[i][j].x
    target_y = lines[i][j].y

    delta_x = (target_x - current_x) <=> 0
    delta_y = (target_y - current_y) <=> 0

    state[current_y][current_x - $x_min] = 1
    while ((current_x != target_x) || (current_y != target_y)) do
      current_x += delta_x
      current_y += delta_y

      state[current_y][current_x - $x_min] = 1
    end
  end
end

def print_state(state)
  for i in 0..(state.length - 1) do
    p state[i]
  end
end

# print_state(state)

p ""

def simulate_sand(state, sand_x, sand_y)
  if (sand_y + 1) >= state.length then
    return false
  end
  if state[sand_y + 1][sand_x] == 0 then
    return simulate_sand(state, sand_x, sand_y + 1)
  end

  if (sand_x - 1) < 0 then
    return false
  end
  if state[sand_y + 1][sand_x - 1] == 0 then
    return simulate_sand(state, sand_x - 1, sand_y + 1)
  end

  if (sand_x + 1) >= state[0].length then
    return false
  end
  if state[sand_y + 1][sand_x + 1] == 0 then
    return simulate_sand(state, sand_x + 1, sand_y + 1)
  end

  state[sand_y][sand_x] = 2
  return true
end

# part 1
# counter = 0
# while simulate_sand(state, 500 - $x_min, 0)
#   counter += 1
#   # puts ""
#   # print_state(state)
# end
# puts counter

# Part 2

def fix_floor(state)
  for i in 0..(state[state.length - 1].length - 1) do
    state[state.length - 1][i] = 1
  end
end

def grow_state(state)
  state.each do |row|
    row.unshift(0)
    row.append(0)
  end

  $x_min -= 1
  $x_max += 1

  fix_floor(state)
end

state.append(Array.new($x_max - $x_min, 0))
state.append(Array.new($x_max - $x_min, 0))
fix_floor(state)

def simulate_sand_2(state, sand_x, sand_y)
  if (sand_y + 1) >= state.length then
    return false
  end
  if state[sand_y + 1][sand_x] == 0 then
    return simulate_sand_2(state, sand_x, sand_y + 1)
  end

  if (sand_x - 1) < 0 then
    grow_state(state)
    sand_x += 1
  end
  if state[sand_y + 1][sand_x - 1] == 0 then
    return simulate_sand_2(state, sand_x - 1, sand_y + 1)
  end

  if (sand_x + 1) >= state[0].length then
    grow_state(state)
    sand_x += 1
  end
  if state[sand_y + 1][sand_x + 1] == 0 then
    return simulate_sand_2(state, sand_x + 1, sand_y + 1)
  end

  state[sand_y][sand_x] = 2
  return true
end

counter = 0
while state[0][500 - $x_min] == 0
  simulate_sand_2(state, 500 - $x_min, 0)
  counter += 1
  # puts ""
  # print_state(state)
end
puts counter

