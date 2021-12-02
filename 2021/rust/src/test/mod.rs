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
