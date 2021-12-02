use std::fs;

pub fn read_file(path: &str) -> Vec<String> {
    let data =
        fs::read_to_string(path).expect("Please ensure the path is correct and the file exists!");
    data.split("\n").map(|s| s.to_owned()).collect()
}

pub fn parse_int(v: Vec<String>) -> Vec<i32> {
    v.iter().map(|s| s.parse().unwrap()).collect()
}
