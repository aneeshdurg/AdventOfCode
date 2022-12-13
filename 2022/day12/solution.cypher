// Parse the input and create one node per character, encoding it's coordinates
LOAD CSV from "file:///input.csv" as line
WITH linenumber() - 1 as y, line[0] as data
WITH data, y, size(data) as n
UNWIND range(0, n - 1) as x
WITH n, x, y, substring(data, x, 1) as c
WITH *,
  c = 'S' as start,
  c = 'E' as end,
  CASE c
    WHEN 'S' THEN 'a'
    WHEN 'E' THEN 'z'
    ELSE c
  END as value
WITH *, apoc.text.charAt(value, 0) - apoc.text.charAt("a", 0) as value
CREATE (:DATA {c: c, value: value, x: x, y: y, start: start, end: end});

// create edges for all valid moves between nodes
MATCH (a), (b)
  WHERE
    ((abs(a.x - b.x) = 1 AND a.y = b.y) OR
      (abs(a.y - b.y) = 1 AND a.x = b.x))
    AND ((a.value >= b.value) OR ((b.value - a.value) = 1))
CREATE (a)-[:REL]->(b);

// get the shortestPath from start to end
MATCH shortestPath((a {start: true})-[p*]->(e {end: true}))
RETURN a, e, size(p) as part1_solution;

// find the shortest path from any level 0 elevation to the end
MATCH shortestPath((a {value: 0})-[p*]->(e {end: true}))
RETURN a, e, size(p) as part2_solution ORDER BY part2_solution LIMIT 1;
