pub fn function(n: i128, p: i128, a: i128, b: i128) -> i128 {
    if n % p == 0 { n/p } else { a*n+b }
}

pub fn reverse_function(n: i128, p: i128, a: i128, b: i128) -> (i128, Option<i128>) {
    if (n-b) % a == 0 && (n-b) % (p*a) != 0 { (p*n, Some((n-b)/a)) } else { (p*n, None) }
}
