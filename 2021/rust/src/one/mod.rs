pub fn part1(data: Vec<i32>) -> i32 {
    // let data: Vec<i32> = data.iter().map(|s| s.parse().unwrap()).collect();
    let front = &data[..data.len()];
    let back = &data[1..];
    front
        .iter()
        .zip(back.iter())
        .map(|(front, back)| if back > front { 1 } else { 0 })
        .sum()
}

// we construct a sliding window of size 3
pub fn part2(data: Vec<i32>) -> i32 {
    let (mut left, mut right) = (0, 3);
    let mut compressed = Vec::new();
    let mut cur_sum = (&data[left..right]).iter().sum();
    let rest = &data[1..data.len() - 2];
    compressed.push(cur_sum);
    for _ in rest.iter() {
        cur_sum = cur_sum - data[left] + data[right] as i32;
        compressed.push(cur_sum);
        left += 1;
        right += 1;
    }
    part1(compressed)
}
