use std::io::{self, Read};

struct IntCode<'a> {
    data: &'a mut Vec<usize>,
    position: usize,
}

impl<'a> IntCode<'a> {
    fn new(data: &'a mut Vec<usize>) -> Self
    {
        IntCode { data, position: 0 }
    }

    fn advance(self: &mut Self)
    {
        self.position += 4;
    }

    fn execute(self: &mut Self, op: impl Fn(usize, usize)->usize)
    {
        let input_a_reg = self.data[self.position + 1];
        let input_b_reg = self.data[self.position + 2];
        let output_reg = self.data[self.position + 3];
        self.data[output_reg] =
            op(self.data[input_a_reg], self.data[input_b_reg]);

    }

    fn execute_add(self: &mut Self)
    {
        self.execute(|x, y| x + y);
    }

    fn execute_multiply(self: &mut Self)
    {
        self.execute(|x, y| x * y);
    }

    fn run(self: &mut Self, noun: usize, verb: usize) -> Result<usize, ()>
    {
        self.data[1] = noun;
        self.data[2] = verb;
        loop {
            match self.data[self.position] {
                1 => self.execute_add(),
                2 => self.execute_multiply(),
                99 => { return Ok(self.data[0]); },
                _ => { return Err(()); }
            };

            self.advance();
        }
    }

    fn run_with_input(
        data: &mut Vec<usize>, noun: usize, verb: usize) -> io::Result<usize>
    {
        match IntCode::new(data).run(noun, verb) {
            Ok(i) => Ok(i),
            _     => Err(io::Error::new(io::ErrorKind::InvalidInput, "!"))
        }
    }
}

fn main() -> io::Result<()> {
    let mut buffer = String::new();
    io::stdin().read_to_string(&mut buffer)?;
    let data: Vec<usize> = buffer
        .split(",")
        .map(|x| x.trim().parse().unwrap())
        .collect();

    let res = IntCode::run_with_input(&mut data.clone(), 12, 2)?;
    println!("Part 1: {}", res);

    let target = 19690720;
    for noun in 0..100 {
        for verb in 0..100 {
            let res = IntCode::run_with_input(&mut data.clone(), noun, verb)?;
            if res == target {
                println!("Part 2: {}", 100 * noun + verb);
                return Ok(());
            }
        }
    }

    return Err(io::Error::new(io::ErrorKind::NotFound, "No solution found!"));
}
