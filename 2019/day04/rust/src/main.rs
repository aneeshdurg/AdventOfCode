use std::collections::{HashSet, HashMap};
use std::iter::FromIterator;

fn satisfies(x: u64) -> bool {
    let s = x.to_string();
    let digits: Vec<u32> =
        s.chars().map(|c| c.to_digit(10).unwrap()).collect();
    for i in 0..(digits.len() - 1) {
        if digits[i + 1] < digits[i] {
            return false;
        }
    }

    let set: HashSet<u32> = HashSet::from_iter(digits.iter().cloned());
    return set.len() < s.len();
}

fn refine(x: u64) -> bool {
    let mut m = HashMap::new();
    let s = x.to_string();
    for c in s.chars() {
        let d = c.to_digit(10).unwrap();
        m.insert(d, match m.get(&d) {
            Some(v) => v + 1,
            None    => 1,
        });
    }

    match m.values().find(|x| **x == 2) {
        Some(_) => true,
        _       => false,
    }
}

fn main() {
    let mut part_1 = 0;
    let mut part_2 = 0;
    for i in 171309..643603 {
        if satisfies(i) {
            part_1 += 1;
            if refine(i) {
                part_2 += 1;
            }
        }
    }
    println!("part 1: {}", part_1);
    println!("part 2: {}", part_2);
}
