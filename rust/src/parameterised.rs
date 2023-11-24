fn assert_sane_parameterisation(p: i128, a: i128, _b: i128) {
    assert_ne!(p, 0, "'p' should not be 0 ~ violates modulo being non-zero.");
    assert_ne!(a, 0, "'a' should not be 0 ~ violates the reversability.");
}

pub fn function(n: i128, p: i128, a: i128, b: i128) -> i128 {
    assert_sane_parameterisation(p, a, b);
    if n % p == 0 { n/p } else { a*n+b }
}

pub fn reverse_function(n: i128, p: i128, a: i128, b: i128) -> (i128, Option<i128>) {
    if (n-b) % a == 0 && (n-b) % (p*a) != 0 { (p*n, Some((n-b)/a)) } else { (p*n, None) }
}
