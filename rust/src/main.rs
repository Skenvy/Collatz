use ferris_says::say;
use std::io::{stdout, BufWriter};
use collatz::parameterised::function as parameterised_function;
use collatz::default::function as default_function;

fn main() {
    let stdout = stdout();
    let pfr = parameterised_function(17, 2, 3, 3); // 54
    let dfr = default_function(27); // 82
    let message = format!("C(17, 2, 3, 3) = {pfr}, C(27) = {dfr}");
    let width = message.chars().count();

    let mut writer = BufWriter::new(stdout.lock());
    say(&message, width, &mut writer).unwrap();
}
