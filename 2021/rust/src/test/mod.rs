use crate::four;

use super::three;
use super::util;

#[test]
fn test_read_file() {
    let expected: Vec<String> = vec!["some", "data"]
        .iter_mut()
        .map(|s| s.to_owned())
        .collect();
    let actual = crate::util::read_file("src/test/test.txt");
    assert_eq!(expected, actual);
}

#[test]
fn test_one() {
    let data = crate::util::read_file("src/one/test.txt");
    let data = crate::util::parse_int(data);
    let expected = 7;
    let actual = crate::one::part1(data);
    assert_eq!(expected, actual);
}

#[test]
fn test_one_two() {
    let data = crate::util::read_file("src/one/test.txt");
    let data = crate::util::parse_int(data);
    let expected = 5;
    let actual = crate::one::part2(data);
    assert_eq!(expected, actual);
}

#[test]
fn test_two() {
    let data = crate::util::read_file("src/two/test.txt");
    let expected = 150;
    let actual = crate::two::part1(data);
    assert_eq!(expected, actual);
}

#[test]
fn test_two_two() {
    let data = crate::util::read_file("src/two/test.txt");
    let expected = 900;
    let actual = crate::two::part2(data);
    assert_eq!(expected, actual);
}

#[test]
fn test_3() {
    let data = util::read_file("src/three/test.txt")
        .iter()
        .map(|s| {
            s.chars()
                .map(|c| if c == '1' { true } else { false })
                .collect::<Vec<bool>>()
        })
        .collect();
    let expected = 198;
    let actual = three::part1(data);
    assert_eq!(expected, actual)
}

#[test]
fn test_4() {
    let arr = util::read_file("src/four/test.txt");
    let (values, boards) = arr.split_at(1);

    let values = values[0]
        .split(',')
        .map(|x| str::parse::<i32>(x).unwrap())
        .collect();

    println!("{:?}", boards);

    let boards: Vec<four::Board> = boards
        .to_vec()
        .iter()
        .map(|v| {
            v.trim()
                .split(' ')
                .map(|x| {
                    println!("{}", x);
                    str::parse::<i32>(x).unwrap()
                })
                .collect()
        })
        .fold(
            Vec::default(),
            |mut prev: Vec<Vec<Vec<i32>>>, cur: Vec<i32>| match prev.pop() {
                Some(mut last) => {
                    if last.len() < 5 {
                        last.push(cur.to_owned());
                        prev.push(last);
                    } else {
                        prev.push(last);
                        prev.push(Vec::default());
                    }
                    prev
                }
                None => {
                    vec![vec![cur.to_owned()]]
                }
            },
        )
        .iter()
        .map(|bingo| four::Board::new(bingo))
        .collect();

    assert_eq!(four::part1(values, boards), 4512);
}
