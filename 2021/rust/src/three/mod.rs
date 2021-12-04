struct Summary {
    bits: Vec<bool>,
}

type Matrix<T> = Vec<Vec<T>>;

impl Summary {
    // don't really like the imperative way of doing this but unsure how also
    // ideally this is actually just a transpose, sum and then map
    fn new(v: Vec<Vec<bool>>) -> Self {
        let num_iter = v[0].len();
        let l = v.len() as i32;
        let mut bits = Vec::new();
        for idx in 0..num_iter {
            let cur: i32 = v
                .iter()
                .map(|a| a[idx])
                .filter(|&b| b)
                .collect::<Vec<bool>>()
                .len() as i32;
            bits.push(cur > l - cur);
        }
        return Summary { bits };
    }

    fn gamma(&self) -> i32 {
        let l = self.bits.len() as u32;
        self.bits
            .iter()
            .enumerate()
            .map(|(idx, &val)| {
                if val {
                    2_i32.pow(l - 1 - (idx as u32))
                } else {
                    0
                }
            })
            .sum()
    }

    fn ep(&self) -> i32 {
        let l = self.bits.len() as u32;
        self.bits
            .iter()
            .enumerate()
            .map(|(idx, &val)| {
                if !val {
                    2_i32.pow(l - 1 - (idx as u32))
                } else {
                    0
                }
            })
            .sum()
    }
}

pub struct Col<T> {
    data: Vec<Vec<T>>,
}
struct ColIter<'a, It> {
    data: &'a Col<It>,
    col_idx: usize,
}

impl<T> Col<T> {
    fn new(data: Vec<Vec<T>>) -> Option<Col<T>> {
        match data.len() {
            0 => None,
            _ => {
                let initial = data[0].len();
                match data.iter().all(|a| a.len() == initial) {
                    true => Some(Col { data }),
                    false => None,
                }
            }
        }
    }
}

impl<'a, T> Iterator for ColIter<'a, T> {
    type Item = Vec<&'a T>;
    // return None if col_idx = len(data[0])
    fn next(&mut self) -> Option<Self::Item> {
        let vec = &self.data.data;
        if vec[0].len() == self.col_idx {
            return None;
        }
        let result: Vec<&T> = vec.iter().map(|arr| &arr[self.col_idx]).collect();
        self.col_idx += 1;
        Some(result)
    }
}

pub fn part1(v: Vec<Vec<bool>>) -> i32 {
    let d = Summary::new(v);
    d.gamma() * d.ep()
}

