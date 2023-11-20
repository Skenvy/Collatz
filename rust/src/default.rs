pub fn function(n: i128) -> i128 {
    if n % 2 == 0 { n/2 } else { 3*n+1 }
}

pub fn reverse_function(n: i128) -> (i128, Option<i128>) {
    if (n).rem_euclid(6) == 4 { (2*n, Some((n-1)/3)) } else { (2*n, None) }
}
