def default_flow = [:]
def tunnels = [:]
def current_flow = [:]
def next_flow = [:]
def next_next_flow = [:]

def graph_nodes = [:]

class Flow {
  int rate;
  List<String> open_valves;
  public Flow() {
    rate = 0
    open_valves = []
  }
}

new File("input.txt").eachLine { line ->
    parts = line.split(';')
    valve_details = parts[0].split(' ')
    name = valve_details[1]
    rate = valve_details[valve_details.size() - 1].split('=')[1] as int

    if (rate > 0) {
      default_flow[name] = rate
    }
    current_flow[name] = new Flow()
    next_flow[name] = new Flow()
    next_next_flow[name] = new Flow()

    links = parts[1].split("valve")[1]
    if (links[0] == 's') {
      links = links.substring(2)
    } else { links = links.substring(1)
    }
    links = links.replaceAll(" ", "")
    tunnels[name] = links.split(',')

    graph_nodes[name] = [name: name, edges: [:]]
}

def exploreLinks(graph_nodes, src, visited, current, tunnels, default_flow, weight) {
  for (link in tunnels[current]) {
    if (visited[link]) {
      continue
    }

    visited[link] = true
    resolveEdges(graph_nodes, src, visited, link, tunnels, default_flow, weight + 1)
    visited[link] = false
  }
}

def resolveEdges(graph_nodes, src, visited, current, tunnels, default_flow, weight) {
  if (default_flow.containsKey(current)) {
    w = graph_nodes[src].edges.get(current, weight + 1)
    if (weight < w) {
      w = weight
    }
    graph_nodes[src].edges[current] = w
    // return
  }

  exploreLinks(graph_nodes, src, visited, current, tunnels, default_flow, weight)
  return
}

def visited = [:]
graph_nodes.each { node ->
  visited[node.key] = false
}
graph_nodes.each { node ->
  visited[node.key] = true
  exploreLinks(graph_nodes, node.key, visited, node.key, tunnels, default_flow, 0)
  visited[node.key] = false
}

println graph_nodes
println default_flow

def inFlow(node, flow) {
  for (i = 0; i < flow.open_valves.size(); i++) {
    if (flow.open_valves[i] == node) {
      return true
    }
  }
  return false
}

def copyFlow(flow) {
  f = new Flow();
  for (i = 0; i < flow.open_valves.size(); i++) {
    f.open_valves.add(flow.open_valves[i])
  }
  f.rate = flow.rate
  return f
}

def noFuture(world, flow) {
  return flow.open_valves.size() == world.default_flow.size()
}

def maxFlow(world, node, flow, time) {
  def best_flow = copyFlow(flow)

  if (time <= 1 || noFuture(world, flow)) {
    return best_flow
  }

  // attempt to open valve
  if (world.default_flow.containsKey(node) && !inFlow(node, flow)) {
    def open_node_flow = copyFlow(flow)
    open_node_flow.open_valves.add(node)
    open_node_flow.rate += (time - 1) * world.default_flow.get(node, 0)
    return maxFlow(world, node, open_node_flow, time - 1)
  }

  world.graph_nodes[node].edges.each { entry ->
    next_node = entry.key
    next_cost = entry.value
    if (!inFlow(next_node, flow) && (time > (next_cost + 1))) {
      def next_flow = maxFlow(world, next_node, flow, time - next_cost)
      if (next_flow.rate > best_flow.rate) {
        best_flow = next_flow
      }
    }
  }

  if (world.lvl < time) {
    println time
    world.lvl = time
  }
  return best_flow
}

world = [
  default_flow: default_flow,
  tunnels: tunnels,
  graph_nodes: graph_nodes,
  lvl: 0
]
m = maxFlow(world, "AA", new Flow(), 30)
println "!"
println m.rate
println m.open_valves


def maxFlow2(world, nodea, nodeb, flow_, timea_, timeb_) {
  def flow = copyFlow(flow_)
  def timea = timea_
  def timeb = timeb_

  // def keya = nodea + " " + nodeb + " " + timea + " " + timeb + " " + flow.open_valves.join(" ") + (flow.rate as String)
  // if (world.cache.containsKey(keya)) {
  //   println "C HIT A"
  //   return world.cache[keya]
  // }
  // def keyb = nodeb + " " + nodea + " " + timeb + " " + timea + " " + flow.open_valves.join(" ") + (flow.rate as String)
  // if (world.cache.containsKey(keyb)) {
  //   return world.cache[keyb]
  // }
  // printf("%d %d\n", timea, timeb)
  // if (nodea == "DD" && nodeb == "BB") {
  // println "HI"
  // println flow.rate
  // println flow.open_valves
  // println timea
  // println timeb
  // exit
  // }

  if ((timea <= 1 && timeb <= 1) || noFuture(world, flow)) {
    // world.cache[keya] = flow
    return flow
  }

  // attempt to open valves
  if (timea >= 2 && world.default_flow.containsKey(nodea) && !inFlow(nodea, flow)) {
    timea -= 1
    flow.open_valves.add(nodea)
    flow.rate += timea * world.default_flow.get(nodea, 0)
  }
  if (timeb >= 2 && world.default_flow.containsKey(nodeb) && !inFlow(nodeb, flow)) {
    timeb -= 1
    flow.open_valves.add(nodeb)
    flow.rate += timeb * world.default_flow.get(nodeb, 0)
  }

  def best_flow = copyFlow(flow)
  world.graph_nodes[nodea].edges.each { entrya ->
    def next_nodea = entrya.key
    def next_costa = entrya.value
    if (!inFlow(next_nodea, flow)) {
      if (timea > (next_costa + 1)) {
        def next_flow = maxFlow2(world, next_nodea, nodeb, flow, timea - next_costa, timeb)
        if (next_flow.rate > best_flow.rate) {
          best_flow = next_flow
        }
      }
    }
  }

  world.graph_nodes[nodeb].edges.each { entryb ->
    def next_nodeb = entryb.key
    def next_costb = entryb.value
    if (!inFlow(next_nodeb, flow)) {
      if (timeb > (next_costb + 1)) {
        def next_flow = maxFlow2(world, nodea, next_nodeb, flow, timea, timeb - next_costb)
        if (next_flow.rate > best_flow.rate) {
          best_flow = next_flow
        }
      }
    }
  }

  if (world.lvla < timea && world.lvlb < timeb) {
    printf("b %d %d\n", timea, timeb)
    world.lvla = timea
    world.lvlb = timeb
  }
  // world.cache[keya] = best_flow
  return best_flow
}

world["lvla"] = 0
world["lvlb"] = 0
world["cache"] = [:]
m = maxFlow2(world, "AA", "AA", new Flow(), 26, 26)
println "!"
println m.rate
println m.open_valves

