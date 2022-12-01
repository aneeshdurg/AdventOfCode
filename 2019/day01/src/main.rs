use std::io::{self, BufRead};

fn get_fuel_for_mass(m: u64) -> u64 {
    m / 3 - 2
}

fn get_fuel_for_component(m: u64) -> u64 {
    let mut total_fuel = get_fuel_for_mass(m);
    let mut fuel_to_lift: u64 = total_fuel;

    while fuel_to_lift >= 8 {
        fuel_to_lift = get_fuel_for_mass(fuel_to_lift);
        total_fuel += fuel_to_lift;
    }
    return total_fuel;
}

fn main() -> io::Result<()>{
    let stdin = io::stdin();
    let mut total_fuel_part_1: u64 = 0;
    let mut total_fuel_part_2: u64 = 0;
    for line in stdin.lock().lines() {
        let mass: u64 = line?.parse().unwrap();
        total_fuel_part_1 += get_fuel_for_mass(mass);
        total_fuel_part_2 += get_fuel_for_component(mass);
    }

    println!(
        "part 1: total fuel required for components {}", total_fuel_part_1);
    println!(
        "part 2: total fuel required for components {}", total_fuel_part_2);

    Ok(())
}
