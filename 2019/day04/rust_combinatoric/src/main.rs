use std::cmp::{min, max};
// TODO write tests

// A cleverer solution could do the following four functions at once
fn first_digit(n: u64) -> u64 {
    if n < 10 {
        n
    } else {
        first_digit(n / 10)
    }
}

fn num_digits(n: u64) -> u64 {
    if n == 0 {
        0
    } else {
        1 + num_digits(n / 10)
    }
}

fn rest_digits(n: u64) -> u64 {
    if n < 10 {
        n % 10
    } else {
        let to_subtract =
            first_digit(n) * 10_u64.pow((num_digits(n) - 1) as u32);
        println!("  subtracting {} - {}", n, to_subtract);
        n - to_subtract
    }
}

fn max_n(n: u64) -> u64 {
    if n == 0 {
        0
    } else if n == 1 {
        9
    } else {
        10 * max_n(n - 1) + 9
    }
}

fn count_passwords(a: u64, b: u64) -> u64 {
    println!("{} - {}", a, b);

    let n_digits = max(num_digits(a), num_digits(b));
    // assert!(n_digits == num_digits(b));

    let mut res = 0;

    if b < a {
        println!("  basecase");
        return 0;
    } else if (b - a) < 10 {
        for c in a..b {
            if (c / 10) < (c % 10) {
                res += 1;
            }
        }
        println!("  basecase");
        return res;
    }

    let ten_to_the_n_1 = 10_u64.pow((n_digits - 2) as u32);

    let first_a = first_digit(a);
    let rest_a = rest_digits(a);

    let first_b = first_digit(b);
    let rest_b = rest_digits(b);

    let max_n_1 = max_n(n_digits - 1);
    let c = first_a;
    let start = min(rest_a, c * ten_to_the_n_1);
    let end = if c == first_b { rest_b } else { max_n_1 };

    // Count passwords excluding first digit. Any number in these passwords can
    // be repeated.
    res += (n_digits - 1) * count_passwords(start, end);
    println!("  first res ({} - {}) {}", rest_a, end, res);


    // Fix the first digit and find the number of valid passwords for the
    // remaining digits. Note that in this case even the first digit can be
    // repeated.
    for c in (first_a + 1)..(first_b - 1) {
         res += (n_digits - 1) * count_passwords(c * ten_to_the_n_1, max_n_1);
    }

    // Already covered before the for loop
    if first_b != first_a {
        let start = first_b * ten_to_the_n_1;
        res +=
            (n_digits - 1) * count_passwords(start, rest_b);
        println!("  last res ({} - {}) {}", start, rest_b, res);
    }

    return res;
}

fn main() {
    println!("{}", count_passwords(100, 200));
}
