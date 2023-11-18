pub fn function(n: i128, p: i128, a: i128, b: i128) -> i128 {
    if n % p == 0 { n/p } else { a*n+b }
}
