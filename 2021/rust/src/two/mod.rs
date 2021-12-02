enum Direction {
    Forward(i32),
    Down(i32),
    Up(i32),
}

struct Pos {
    x: i32,
    y: i32,
    aim: i32,
}

impl Direction {
    fn new(s: String) -> Direction {
        let mut i = s.split_ascii_whitespace();
        let d = i.next().unwrap();
        let units: i32 = i.next().unwrap().parse().unwrap();
        match d {
            "forward" => Direction::Forward(units),
            "down" => Direction::Down(units),
            "up" => Direction::Up(units),
            _ => panic!("this is impossible"),
        }
    }

    fn transform(&self, x: i32, y: i32) -> (i32, i32) {
        match self {
            Direction::Forward(a) => (x + a, y),
            Direction::Down(a) => (x, y + a),
            Direction::Up(a) => (x, y - a),
        }
    }

    fn transform_aim(&self, p: Pos) -> Pos {
        match self {
            Direction::Forward(a) => Pos {
                x: p.x + a,
                y: p.y + p.aim * a,
                ..p
            },
            Direction::Down(a) => Pos {
                aim: p.aim + a,
                ..p
            },
            Direction::Up(a) => Pos {
                aim: p.aim - a,
                ..p
            },
        }
    }
}

pub fn part1(input: Vec<String>) -> i32 {
    let (x, y) = input
        .iter()
        .map(|s| Direction::new(s.to_string()))
        .fold((0, 0), |(x, y), cur| cur.transform(x, y));
    return x * y;
}

pub fn part2(input: Vec<String>) -> i32 {
    let p = Pos { x: 0, y: 0, aim: 0 };
    let p = input
        .iter()
        .map(|s| Direction::new(s.to_string()))
        .fold(p, |prev, cur| cur.transform_aim(prev));
    return p.x * p.y;
}
