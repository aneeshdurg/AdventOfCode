use std::io::{self, ErrorKind, Read};
use std::str::FromStr;
use std::cmp::{min, max};

// IDEA: create two vectors for each string, one of all horzt moves one of all vert moves
//    for sort the horzt moves by vert idx and then horzt idx and vice versa (flipping vert/horzt)
//    then for each move in the other string, we can query all horzt moves that are in the right
//    y-range for a given vert move and vice versa (flipping vert/horzt) using bsearch on start and
//    end idx to get valid candidates (use k-d tree to find closest candidate to end of vert line
//    closer to origin)
//
//    runtime:
//      O(nlog n) for sorting
//      O(mlog n) for queries

#[derive(Copy, Clone, Debug, Eq, Hash, PartialEq)]
struct Point {
    x: i64,
    y: i64,
    steps: usize,
}

impl FromStr for Point {
    type Err = io::Error;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let value: i64 = match s[1..].parse() {
            Ok(v)  => v,
            Err(_) => {
                return Err(io::Error::new(ErrorKind::InvalidData, "!"));
            },
        };

        match s.chars().next() {
            Some('R') => Ok(Point::new(value, 0)),
            Some('L') => Ok(Point::new(-1 * value, 0)),
            Some('U') => Ok(Point::new(0, value)),
            Some('D') => Ok(Point::new(0, -1 * value)),
            _         => Err(io::Error::new(ErrorKind::InvalidData, "!")),
        }
    }
}

type Line = [Point; 2];

impl Point {
    fn new(x: i64, y: i64) -> Self {
        Point { x: x, y: y, steps: 0 }
    }

    // A delta is a point with one of the fields set to 0
    fn add_delta(self: Self, other: Self) -> Self {
        let mut pt = Point::new(self.x + other.x, self.y + other.y);
        pt.steps = self.steps + other.x.abs() as usize + other.y.abs() as usize;
        pt
    }

    fn dist(self) -> i64 {
        self.x.abs() + self.y.abs()
    }

    fn is_horzt(line: Line) -> bool {
        return line[0].y == line[1].y;
    }

    fn range_x(line: Line) -> [i64; 2] {
        [min(line[0].x, line[1].x), max(line[0].x, line[1].x)]
    }


    fn range_y(line: Line) -> [i64; 2] {
        [min(line[0].y, line[1].y), max(line[0].y, line[1].y)]
    }

    fn in_range(range: [i64; 2], val: i64) -> bool {
        range[0] <= val && val <= range[1]
    }

    fn intersects_h_v(line_horzt: Line, line_vert: Line) -> Option<Point> {
        let x_range = Point::range_x(line_horzt);
        let y_range = Point::range_y(line_vert);
        if Point::in_range(x_range, line_vert[0].x) &&
                Point::in_range(y_range, line_horzt[0].y) {
            let mut pt = Point::new(line_vert[0].x, line_horzt[0].y);
            pt.steps = line_vert[0].steps +
                (line_vert[0].y - line_horzt[0].y).abs() as usize +
                line_horzt[0].steps +
                (line_horzt[0].x - line_vert[0].x).abs() as usize;
            Some(pt)
        } else {
            None
        }
    }

    fn intersects(line_a: Line, line_b: Line) -> Option<Point> {
        let a_horzt = Point::is_horzt(line_a);
        if a_horzt && Point::is_horzt(line_b) {
            return None;
        }

        if a_horzt {
            Point::intersects_h_v(line_a, line_b)
        } else {
            Point::intersects_h_v(line_b, line_a)
        }
    }
}

fn get_points(s: &str) -> Vec<Point> {
    let mut sum = Point::new(0, 0);
    s.split(',').map(|x| {
        let delta = x.trim().parse().unwrap();
        let acc = sum.add_delta(delta);
        sum = acc;
        acc
    }).collect()

}

fn main() -> io::Result<()> {
    let mut buffer = String::new();
    io::stdin().read_to_string(&mut buffer)?;
    let mut strings = buffer.split('\n').into_iter();
    let points_a = get_points(strings.next().unwrap());
    let points_b = get_points(strings.next().unwrap());
    println!("{:?}", points_a);
    println!("{:?}", points_b);

    let mut first_intersection: Option<Point> = None;
    let mut intersection: Option<Point> = None;

    for idx_a in 0..(points_a.len() - 1) {
        let line_a = [points_a[idx_a], points_a[idx_a + 1]];
        for idx_b in 0..(points_b.len() - 1) {
            let line_b = [points_b[idx_b], points_b[idx_b + 1]];
            match Point::intersects(line_a, line_b) {
                Some(pt) => {
                    match intersection {
                        Some(old_pt) => {
                            if old_pt.dist() > pt.dist() {
                                intersection = Some(pt);
                            }
                        },
                        None         => {
                            intersection = Some(pt);
                            first_intersection = Some(pt);
                        }
                    };
                },
                None     => { continue; },
            };
        }
    }
    println!(
        "Part1: {:?}, {}",
        intersection,
        intersection.unwrap_or(Point::new(0, 0)).dist());

    println!(
        "Part2: {:?}, {}",
        first_intersection,
        first_intersection.unwrap_or(Point::new(0, 0)).steps);

    Ok(())
}
