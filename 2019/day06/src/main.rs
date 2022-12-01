use std::io::{self, Read};
use std::collections::{HashSet, HashMap};

#[derive(Debug)]
struct Node<'a> {
    children: Vec<&'a str>,
    parent: Option<&'a str>,
}

impl<'a> Node<'a> {
    fn new() -> Node<'a> {
        Node { children: vec!(), parent: None }
    }

    fn insert_child(self: &mut Self, child: &'a str) {
        self.children.push(child);
    }
}

type OrbitMap<'a> = HashMap<&'a str, Node<'a>>;

fn count_paths(src: &str, dist_from_origin: usize, map: &OrbitMap ) -> usize {
    match map.get(src) {
        Some(node) => {
            let n_child = node.children.len();

            // for each child theres 1 direct path to the parent
            let direct_paths = n_child;

            // Children have an indirect path to every ancestor of their parent,
            // the number of ancestors == distance from origin
            let child_indirect_paths = n_child * dist_from_origin;

            let mut paths = direct_paths + child_indirect_paths;
            for c in &node.children {
                paths += count_paths(c, dist_from_origin + 1, map);
            }
            paths
        },
        None           => 0
    }
}

fn shortest_path(src: &str, dst: &str, map: &OrbitMap) -> Option<usize> {
    // storing (Node, dist from src)
    let mut unvisited = vec!((src, 0));
    let mut visited: HashSet<&str> = HashSet::new();

    while unvisited.len() > 0 {
        let element = unvisited.remove(0);
        visited.insert(element.0);

        match map.get(&element.0) {
            Some(node) => {
                // println!("Visiting {:?} ({})", node, element.0);
                let dist = element.1 + 1;
                let mut process_neighbor = |c| {
                    // println!("  Processing Neighbor {}", c);
                    if visited.contains(c) {
                        None
                    } else if c == dst {
                        Some(dist)
                    } else {
                        unvisited.push((c, dist));
                        None
                    }
                };

                if let Some(p) = node.parent {
                    if let Some(d) = process_neighbor(p) {
                        return Some(d);
                    };
                };

                for c in &node.children {
                    if let Some(d) = process_neighbor(c) {
                        return Some(d);
                    };
                }
            },
            None           => { continue; }
        };
    }

    return None;
}

fn main() -> io::Result<()> {
    let mut orbits: OrbitMap = HashMap::new();
    let mut buffer = String::new();
    io::stdin().read_to_string(&mut buffer)?;
    for line in buffer.split("\n") {
        if line.len() == 0 {
            continue;
        }
        let mut parts = line.split(')');
        let src = parts.next().unwrap();
        let dst = parts.next().unwrap();
        match orbits.get_mut(&src) {
            Some(v) => { v.insert_child(dst); },
            None    => {
                let mut n = Node::new();
                n.insert_child(dst);
                orbits.insert(src, n);
            },
        };

        match orbits.get_mut(&dst) {
            Some(v) => { v.parent = Some(src); },
            None    => {
                let mut n = Node::new();
                n.parent = Some(src);
                orbits.insert(dst, n);
            },
        };

    }
    println!("{}", count_paths("COM", 0, &orbits));

    // Number of moves is dist - 2 since we only care about the parents
    println!("{:?}", shortest_path("YOU", "SAN", &orbits).unwrap() - 2);

    Ok(())
}
