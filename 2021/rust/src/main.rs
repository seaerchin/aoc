extern crate rust;

use rust::three;
use rust::util;

fn main() {
    let data = util::read_file("src/three/data.txt")
        .iter()
        .map(|s| {
            s.chars()
                .map(|c| if c == '1' { true } else { false })
                .collect::<Vec<bool>>()
        })
        .collect();
    let result = three::part1(data);
    println!("{}", result);
}
