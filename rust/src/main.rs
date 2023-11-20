use ferris_says::say;
use std::io::{stdout, BufWriter};
use collatz::parameterised::function as parameterised_function;
use collatz::default::function as default_function;
use collatz::parameterised::reverse_function as parameterised_reverse_function;
use collatz::default::reverse_function as default_reverse_function;

fn main() {
    let stdout = stdout();
    let pfr = parameterised_function(17, 2, 3, 3); // 54
    let dfr = default_function(27); // 82
    let (prfr_pd, prfr_pm) = parameterised_reverse_function(1, 5, 2, 3); // [5, -1]
    let (drfr_pd, drfr_pm) = default_reverse_function(16); // [32, 5]
    let prfr_pm_s = match prfr_pm {Some(x) => format!("{x}"), None => "Nothing".to_string()};
    let drfr_pm_s = match drfr_pm {Some(x) => format!("{x}"), None => "Nothing".to_string()};
    let message = format!("C(17, 2, 3, 3) = {pfr}, C(27) = {dfr}, RC(1, 5, 2, 3) = ({prfr_pd}, {prfr_pm_s}), RC(16) = ({drfr_pd}, {drfr_pm_s})");
    let width = message.chars().count();

    let mut writer = BufWriter::new(stdout.lock());
    say(&message, width, &mut writer).unwrap();
}
