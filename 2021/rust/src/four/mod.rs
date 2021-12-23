use std::collections::HashMap;
pub struct Board {
    bingo: Matrix<(bool, i32)>,
    values: HashMap<i32, (usize, usize)>,
}

type Matrix<T> = Vec<Vec<T>>;

impl Board {
    fn contains(&self, value: i32) -> Option<(usize, usize)> {
        self.values.get(&value).map(|x| x.to_owned())
    }

    pub fn new(values: &Vec<Vec<i32>>) -> Self {
        let bingo = values
            .iter()
            .map(|vec| vec.iter().map(|x| (false, *x)).collect())
            .collect();
        let mut hm = HashMap::default();

        for (x, v) in values.iter().enumerate() {
            for (y, value) in v.iter().enumerate() {
                hm.insert(*value, (x, y));
            }
        }

        Board {
            bingo: bingo,
            values: hm,
        }
    }
}

pub fn part1(input: Vec<i32>, mut boards: Vec<Board>) -> i32 {
    for v in input {
        // mark the locations on the bingo board that have the respective values
        for board in boards.iter_mut() {
            if let Some((x, y)) = board.contains(v) {
                board.bingo[x][y].0 = true;
            }
        }
    }
    boards.iter().fold(None, check).unwrap()
}

fn check(prev: Option<i32>, b: &Board) -> Option<i32> {
    match prev {
        Some(x) => Some(x),
        None => {
            if let Some(x) = check_rows(&b) {
                Some(x)
            } else if let Some(x) = check_cols(&b) {
                Some(x)
            } else {
                None
            }
        }
    }
}

fn check_rows(b: &Board) -> Option<i32> {
    let boards = &b.bingo;

    boards.iter().fold(None, |prev, cur| match prev {
        None => {
            if cur.iter().all(|x| x.0) {
                Some(cur.iter().map(|(_, v)| v).sum())
            } else {
                None
            }
        }
        v => v,
    })
}

fn check_cols(b: &Board) -> Option<i32> {
    // make deep copy cos lazy
    let board = transpose(b.bingo.to_owned());
    let new_b = Board {
        bingo: board,
        values: b.values.to_owned(),
    };
    check_rows(&new_b)
}

fn transpose<T>(v: Vec<Vec<T>>) -> Vec<Vec<T>> {
    assert!(!v.is_empty());
    let len = v[0].len();
    let mut iters: Vec<_> = v.into_iter().map(|n| n.into_iter()).collect();
    (0..len)
        .map(|_| {
            iters
                .iter_mut()
                .map(|n| n.next().unwrap())
                .collect::<Vec<T>>()
        })
        .collect()
}
