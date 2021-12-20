use std::fs;

pub fn read_file(path: &str) -> Vec<String> {
    fs::read_to_string(path)
        .map(|ref s| s.trim().split("\n").map(|s| s.to_owned()).collect())
        .expect("Please ensure the path is correct and the file exists!")
}

pub fn parse_int(v: Vec<String>) -> Vec<i32> {
    v.iter().map(|s| s.parse().unwrap()).collect()
}
