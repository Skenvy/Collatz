use std::{error::Error, fmt};

// Create a custom error with fields that can be referenced in impl fmt::Display
#[derive(Debug)]
pub struct FailedSaneParameterCheck {message: String}
impl Error for FailedSaneParameterCheck {}
impl fmt::Display for FailedSaneParameterCheck {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{}", self.message)
    }
}

fn assert_sane_parameterisation(p: i128, a: i128, _b: i128) -> Result<(),FailedSaneParameterCheck> {
    if p == 0 {
        return Err(FailedSaneParameterCheck{message: "'p' should not be 0 ~ violates modulo being non-zero.".to_string()});
    }
    if a == 0 {
        return Err(FailedSaneParameterCheck{message: "'a' should not be 0 ~ violates the reversability.".to_string()});
    }
    Ok(())
}

pub fn function(n: i128, p: i128, a: i128, b: i128) -> Result<i128,FailedSaneParameterCheck> {
    assert_sane_parameterisation(p, a, b)?;
    if n % p == 0 { Ok(n/p) } else { Ok(a*n+b) }
}

pub fn reverse_function(n: i128, p: i128, a: i128, b: i128) -> (i128, Option<i128>) {
    if (n-b) % a == 0 && (n-b) % (p*a) != 0 { (p*n, Some((n-b)/a)) } else { (p*n, None) }
}
