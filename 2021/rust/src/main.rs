extern crate rust;

use rust::two;
use rust::util;

fn main() {
    let data = util::read_file("src/two/data.txt");
    let result = two::part2(data);
    println!("{}", result);
}
