use std::io::{self, Read};

type InputFn = Box<dyn Fn() -> i64>;
type OutputFn = Box<dyn Fn(i64)>;

struct IntCode<'a> {
    data: &'a mut Vec<i64>,
    position: usize,
    input_fn: InputFn,
    output_fn: OutputFn,
}

enum ParamMode {
    Immediate,
    Position,
}

impl<'a> IntCode<'a> {
    fn get_mode(param_idx: u32, instruction: i64) -> ParamMode
    {
        if (instruction / (100 * 10_i64.pow(param_idx)) % 10) == 0 {
            ParamMode::Position
        } else {
            ParamMode::Immediate
        }
    }

    fn new(
        data: &'a mut Vec<i64>, input_fn: InputFn, output_fn: OutputFn) -> Self
    {
        IntCode { data, position: 0, input_fn, output_fn }
    }

    fn get_input_with_mode(
        self: &Self, input_val: i64, mode: ParamMode) -> i64
    {
        match mode {
            ParamMode::Immediate => input_val,
            ParamMode::Position  => self.data[input_val as usize]
        }
    }

    fn execute_math(self: &mut Self, op: impl Fn(i64, i64)->i64)
    {
        let instruction = self.data[self.position];

        let input_a_mode = IntCode::get_mode(0, instruction);
        let input_a = self.get_input_with_mode(
            self.data[self.position as usize + 1], input_a_mode);

        let input_b_mode = IntCode::get_mode(1, instruction);
        let input_b = self.get_input_with_mode(
            self.data[self.position as usize + 2], input_b_mode);

        let output_reg = self.data[self.position as usize + 3];
        self.data[output_reg as usize] = op(input_a, input_b);

        self.position += 4;
    }

    fn execute_add(self: &mut Self)
    {
        self.execute_math(|x, y| x + y);
    }

    fn execute_multiply(self: &mut Self)
    {
        self.execute_math(|x, y| x * y);
    }

    fn execute_lt(self: &mut Self)
    {
        self.execute_math(|x, y| if x < y { 1 } else { 0 });
    }

    fn execute_eq(self: &mut Self)
    {
        self.execute_math(|x, y| if x == y { 1 } else { 0 });
    }

    fn execute_input(self: &mut Self)
    {
        let output_reg = self.data[self.position + 1];
        self.data[output_reg as usize] = (self.input_fn)();

        self.position += 2;
    }

    fn execute_output(self: &mut Self)
    {
        let input_mode = IntCode::get_mode(0, self.data[self.position]);
        let input_val = self.data[self.position + 1];
        let input_val = self.get_input_with_mode(input_val, input_mode);
        (self.output_fn)(input_val);

        self.position += 2;
    }

    fn execute_jump_if(self: &mut Self, expect_true: bool)
    {
        let input_mode = IntCode::get_mode(0, self.data[self.position]);
        let input_val = self.get_input_with_mode(
            self.data[self.position + 1], input_mode);
        let input_val = input_val != 0;

        let target_mode = IntCode::get_mode(1, self.data[self.position]);
        let target_val = self.get_input_with_mode(
            self.data[self.position + 2], target_mode) as usize;

        if input_val == expect_true {
            self.position = target_val;
        } else {
            self.position += 3;
        }
    }

    fn execute_jump_if_true(self: &mut Self)
    {
        self.execute_jump_if(true);
    }

    fn execute_jump_if_false(self: &mut Self)
    {
        self.execute_jump_if(false);
    }


    fn run(self: &mut Self) -> Result<i64, ()>
    {
        loop {
            let instruction = self.data[self.position];
            let opcode = instruction % 100;
            if opcode == 1 {
                self.execute_add();
            } else if opcode == 2 {
                self.execute_multiply();
            } else if opcode == 3 {
                self.execute_input();
            } else if opcode == 4 {
                self.execute_output();
            } else if opcode == 5 {
                self.execute_jump_if_true();
            } else if opcode == 6 {
                self.execute_jump_if_false();
            } else if opcode == 7 {
                self.execute_lt();
            } else if opcode == 8 {
                self.execute_eq();
            } else if opcode == 99 {
                return Ok(self.data[0]);
            } else {
                return Err(());
            }
        }
    }

    fn run_with_input(
        data: &mut Vec<i64>,
        input_fn: InputFn,
        output_fn: OutputFn) -> io::Result<i64>
    {
        let mut machine = IntCode::new(data, input_fn, output_fn);
        match machine.run() {
            Ok(i) => Ok(i),
            _     => Err(io::Error::new(io::ErrorKind::InvalidInput, "!"))
        }
    }
}

fn main() -> io::Result<()> {
    let mut buffer = String::new();
    io::stdin().read_to_string(&mut buffer)?;
    let data: Vec<i64> = buffer
        .split(",")
        .map(|x| x.trim().parse().unwrap())
        .collect();

    IntCode::run_with_input(
        &mut data.clone(),
        Box::new(|| 1),
        Box::new(|x| { println!("Part 1: {}", x); }))?;

    println!("===");

    IntCode::run_with_input(
        &mut data.clone(),
        Box::new(|| 5),
        Box::new(|x| { println!("Part 2: {}", x); }))?;


    Ok(())
}
