function contains(range1, range2)
  _contains(range1, range2) =
    range1[1] <= range2[1] && range1[2] >= range2[2]

  _contains(range1, range2) || _contains(range2, range1)
end


function range_contains_element(range, el)
  el >= range[1] && el <= range[2]
end


function overlaps(range1, range2)
  range_contains_element(range2, range1[1]) ||
    range_contains_element(range2, range1[2]) ||
    range_contains_element(range1, range2[1])
end

open("input.txt") do f
  total_contains = 0
  total_overlaps = 0
  while ! eof(f)
    line = readline(f)
    ranges = split(line, ",")

    toInt(s) = parse(Int64, s)

    range1 = map(toInt, split(ranges[1], "-"))
    range2 = map(toInt, split(ranges[2], "-"))

    if contains(range1, range2)
      total_contains += 1
    end

    if overlaps(range1, range2)
      total_overlaps += 1
    end
  end
  println("Total contained ranges = $total_contains")
  println("Total overlapping ranges = $total_overlaps")
end
