# Devlog
[Rust](https://www.rust-lang.org/) (repo [here](https://github.com/rust-lang/rust)) and its package manager [cargo](https://doc.rust-lang.org/cargo/) which distributes its packages as "[crates](https://crates.io/)" is a pretty hyped up systems programming language. So hyped up it's the only language besides C and Assembly to be supported in linux kernel development, since [version 6.1 of the kernel](https://lore.kernel.org/lkml/202210010816.1317F2C@keescook/). Indeed the community admiration has inspired the "three(-ish) emojis" for rust; per this repo's attempt to represent each language that an implementation is done in with three emojis, rust's are ❤️[🦀](https://www.rustacean.net/)❤️, based on the [100000's rust issue](https://github.com/rust-lang/rust/issues/100000).

If we start searching for information on rust, there's a few helpful starting points;
* [Rust](https://www.rust-lang.org/)'s homepage, which suggests a getting started at the top. 
* [Getting Started](https://www.rust-lang.org/learn/get-started), which suggests the [Rust Playground](https://play.rust-lang.org/).
  * The "Installing Rust" section appears to detect your OS and present relevant installation instructions accordingly.
* [Rustup](https://rustup.rs/) ([docs](https://rust-lang.github.io/rustup/)) -- straight away rust gets points for recommending a version management tool as the primary point from which to install rust.
  * it even suggests the WSL installation on the same page, so there's no need to navigate to the [other methods](https://forge.rust-lang.org/infra/other-installation-methods.html)
* [Install](https://www.rust-lang.org/tools/install), if we followed the getting started and installed rustup, will rehash and provide some additional context;
  * Updating rustup is entirely self contained with `rustup update`.
  * Uninstalling is also self contained with `rustup self uninstall`.
  * We can verify our install with `rustc --version` and get something like ~ `rustc 1.73.0 (cc66ad468 2023-10-03)`
* [Read the cargo book](https://doc.rust-lang.org/cargo/index.html); back on getting started we'll get a few examples of cargo.
  * and verify it with `cargo --version` to get something like ~ `cargo 1.73.0 (9c4383fb5 2023-08-26)`
* [Rust in VS Code](https://code.visualstudio.com/docs/languages/rust) and other "rust in your IDE" plugins and extensions.
  * For VS Code this is [rust-analyzer](https://rust-analyzer.github.io/)
  * For vim there's [rust.vim](https://github.com/rust-lang/rust.vim).
* `cargo new hello-rust`; a short guide on creating a new sample project.
* [Learn](https://www.rust-lang.org/learn): following the quickstart is a link to learning, which links to a lot of well described docs.
  * [_The Book_](https://doc.rust-lang.org/book/) -- the primary starting point for rust documentation
* [Rustacean](https://rustacean.net/) is also included as a footer to the quickstart, to explain Ferris the crab.

That's it for as far as the getting started guide took us. There's many more links on the rust site such as;
* [Toolchains](https://rust-lang.github.io/rustup/concepts/toolchains.html)
* [Editions Guide](https://doc.rust-lang.org/stable/edition-guide/); with editions being important enough that it's one of the three properties generated in the default project by `cargo init`.
* [Packaging and distributing a Rust tool](https://rust-cli.github.io/book/tutorial/packaging.html) which describes how to `cargo publish` effectively.

As well as other loose resources such as;
* The [rust-lang](https://github.com/rust-lang) repositories; [rust](https://github.com/rust-lang/rust), [cargo](https://github.com/rust-lang/cargo), [crates.io](https://github.com/rust-lang/crates.io), [libc](https://github.com/rust-lang/libc), [rustfmt](https://github.com/rust-lang/rustfmt), [clippy](https://github.com/rust-lang/rust-clippy)
* [Wikipedia](https://en.wikipedia.org/wiki/Rust_(programming_language)) | The Rust [_discord_](https://discord.gg/rust-lang) | Reddit's [r/rust](https://www.reddit.com/r/rust/)
* [KokaKiwi/rust-mk](https://github.com/KokaKiwi/rust-mk/blob/master/rust.mk), a thoroughly designed Makefile for rust projects.

As well as some examples plucked from [trending rust repos](https://github.com/trending/rust?since=daily);
* [uutils/coreutils](https://github.com/uutils/coreutils)
* [bevyengine/bevy](https://github.com/bevyengine/bevy)
* [lapce/lapce](https://github.com/lapce/lapce)
* [denoland/deno](https://github.com/denoland/deno)
* [FuelLabs/sway](https://github.com/FuelLabs/sway)
* [tokio-rs/axum](https://github.com/tokio-rs/axum)
* [solana-labs/solana](https://github.com/solana-labs/solana)
* [slint-ui/slint](https://github.com/slint-ui/slint)
* [lapce/floem](https://github.com/lapce/floem)
* [biomejs/biome](https://github.com/biomejs/biome)

## [Installation](https://www.rust-lang.org/tools/install)
[Rustup](https://rustup.rs/), a version management tool, is _the_ recommended way of installing rust. It's pretty neat for the recommended way to handle installing it to be through the officially supported version manager, rather than have different version managers be second to some primary installation of the language, and version managers after the fact are something that the community is split on. It's neat that rust doesn't have that problem by just giving you the version manager not just OotB, but as the _recommended_ experience. On linux / WSL, we can install it with the recommended;
```
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```
We can see that it will create a rustup home directory at `~/.rustup/` (or other `RUSTUP_HOME`), a cargo home directory at `~/.cargo/` (or other `CARGO_HOME`), it will add `cargo`, `rustc`, and `rustup`, to `$CARGO_HOME/bin`, and add this to the path. We do have to interactively agree to either the default or a custom installation. Simply picking the default and 30 seconds later we've got the `Rust is installed now. Great!` response.

The same happens during the running of `rustup-init.exe` on windows.

## `cargo init`
During the "`cargo new hello-rust`" quickstart, we see that running `cargo new abc` will create an `./abc/Cargo.toml` and `./abc/src/main.rs`. If you want to create a new `Cargo.toml` and `src/main.rs` in the _current_ directory rather than in some `./hello-rust` directory from running `cargo new hello-rust`, it isn't mentioned on the page but guessing that `cargo new .` might be worth a shot yields the suggestion to `cargo init` to initialise the _current_ directory. Although in this case, `Cargo.toml` initiliases with the name of the directory we're in as the name of the package. I hope that's not going to be an actual restriction and is instead a "nice default."

The quick start example continues to demo adding dependencies, using `cargo build` to install `Cargo.toml`'s `[dependencies]`. Interestingly `cargo init` doesn't create a `.gitignore`, and no where in the quick start does it link to or mention that [rust recommends not checking in](https://doc.rust-lang.org/cargo/guide/cargo-toml-vs-cargo-lock.html) the `Cargo.lock` that `cargo build` produces.

The `Cargo.toml` has [this manifest format](https://doc.rust-lang.org/cargo/reference/manifest.html), and [this list of required fields for crates.io](https://doc.rust-lang.org/cargo/reference/publishing.html).

## Tools
Rust provides a number of development tools OotB. We'll go ahead and comment on them a bit here before starting any code+tests, but will likely be talked about more later when an inevitable problem arises.
### `rustfmt`
[`rustfmt`](https://github.com/rust-lang/rustfmt) is a tool for formatting rust source. Essentially we can `cargo fmt` to auto format files, or check that no formating is required, with `--check`. We can use `rustfmt --print-config default rustfmt.toml` to generate a [configuration file](https://rust-lang.github.io/rustfmt/) that will be honoured by the tool, populated with what it considers [the default style](https://doc.rust-lang.org/nightly/style-guide/).

It's not that transparent of a tool to use OotB, though. With no `rustfmt.toml` configuration, running `cargo fmt --check` with an intentionally introduced error yields the format error correctly, but upon creating the default configuration, and rerunning `cargo fmt --check`, we're bombarded with many warnings like ``Warning: can't set `indent_style = Block`, unstable features are only available in nightly channel.`` for a whole bunch of the rules in the default configuration. The first question is what then, is the configuration being used when the "default" configuration file does not exist, given the existence of it yields so many warnings that the rules it stipulates aren't enforceable, but does not appear when the "default" configuration file doesn't exist either. The solution proposed is to run the "nightly" version, via `cargo +nightly fmt --check`. The first time, having not installed it separately, will give something like `error: toolchain 'nightly-x86_64-unknown-linux-gnu' is not installed`. We can `rustup toolchain install nightly` to install the nightly build, but one of the fields populated in the defaults is a `required_version`, so if we automate a dependency on the nightly build of rustfmt to be able to run fmt on the default rules, we'd also need to automate the creation of the config such that its required version was always whatever the nightly version was, i.e. `rustfmt +nightly --print-config default rustfmt.toml`, which makes it pointless to keep the rules in a configuration file at that point, if we're automating the config file's generation and then its use.

Why on earth does `rustfmt +stable --print-config default rustfmt.toml` produce a configuration file that it will warn on many of the choices within, that it cannot utilise them being not the nightly build. It would also appear that `unstable_features` is an option within the generated config that must be changed to true to allow the "unstable" rules even if using the `+nightly` build. It would likely be a lot less unexpected if the default generated config happened to explain any of this in a comment, or split the entries in the config up between stable and unstable rather than having them all in one soup. It also appears there's no way then to say, error if an unstable rule is specified, such that it's limited to only running on versions where all specified formatting rules are stable and can't run on older versions where rules may not be stable.

The best compromise right now appears to be to let `rustfmt +stable --print-config default rustfmt.toml` output what it wants and generally ignore all the `Warning: can't set X` warnings, while attempting to keep the version of rustfmt that's installed stable across the desire to test against a range of versions.

### `clippy`
[Clippy](https://github.com/rust-lang/rust-clippy) is a tool for linting rust source. It can be configured via a `clippy.toml` to include these [lint configuration options](https://doc.rust-lang.org/nightly/clippy/lint_configuration.html), which are also explained [here](https://rust-lang.github.io/rust-clippy/master/index.html#/). It does not appear to have a way to easily output its default configuration to a file the same way `fmt` did. We'll suffice for now to add a file that contains the links to the options as a comment, and trust that the defaults are stable.

### `rustdoc`
[`librustdoc`](https://github.com/rust-lang/rust/tree/master/src/librustdoc), or simply [`rustdoc`](https://doc.rust-lang.org/rustdoc/what-is-rustdoc.html) (_also see the_ [_rustc developers guide on rustdoc_](https://rustc-dev-guide.rust-lang.org/rustdoc.html)), or even simply-er (in `cargo`-land), [`doc`](https://doc.rust-lang.org/cargo/commands/cargo-doc.html), is the rust provided tool for generating documentation from code comments. See this for ["how to write documentation"](https://doc.rust-lang.org/rust-by-example/meta/doc.html). Simply, though, comments beginning with `///` document the component below them, and comments starting with `//!` document the component they are inside. `//!` for this reason is often used to describe a crate by commenting the crate's root file, by existing in the top level context in that file.

### `cargo test`
Cargo comes with testing, via [`cargo test`](https://doc.rust-lang.org/cargo/commands/cargo-test.html). See the [rust book's chapter on tests](https://doc.rust-lang.org/book/ch11-00-testing.html), or more specifically ["how to write tests"](https://doc.rust-lang.org/book/ch11-01-writing-tests.html). Also see [the examples for how to write unit tests](https://doc.rust-lang.org/rust-by-example/testing/unit_testing.html) and [how to test a rust-written cli](https://rust-cli.github.io/book/tutorial/testing.html).

## Begin developing
### `main` or `lib`
A number of the things I've read through so far have primarily provided examples that use a `./src/main.rs`, but others have specifically mentioned that `./src/lib.rs` is the root file for a crate. Producing a crate is the end goal of this exercise, so it seems like a meaningful distinction that would be worthwhile understanding early. [This SO post](https://stackoverflow.com/questions/57756927/rust-modules-confusion-when-there-is-main-rs-and-lib-rs) asks simply this; and the top answer directs us to [the rust book's section on "package layout"](https://doc.rust-lang.org/cargo/guide/project-layout.html), although it's worth noting that I had spent a while googling around for a guide to rust package layouts prior to discovering this SO answer, and the rust book's entry had never appeared in the first page's results. The [package layout](https://doc.rust-lang.org/cargo/guide/project-layout.html) page makes a clear distinction that the `./src/lib.rs` file is the _default_ **library** file, and the `./src/main.rs` file is the _default_ **executable** file. A similar question was posed in [this reddit thread](https://www.reddit.com/r/rust/comments/lvtzri/confused_about_package_vs_crate_terminology/) which links to [this section of the rust book](https://doc.rust-lang.org/book/ch07-01-packages-and-crates.html), which is part of [this chapter](https://doc.rust-lang.org/book/ch07-00-managing-growing-projects-with-packages-crates-and-modules.html) on packages and crates.

The gist of both is that "package" is a pretty loose construct in rust, while a "crate" can mean either a "library crate" or a "binary crate", or both. A library crate's default entry is the `./src/lib.rs` and a binary crate's default entry is `./src/main.rs`. These can be customised according to the `[lib]` and `[[bin]]` fields in the `Cargo.toml` according to ["configuring a target"](https://doc.rust-lang.org/cargo/reference/cargo-targets.html#configuring-a-target).

### Testing the waters with the first function
We'll eventually need to add a version of the functions that utilises a `gmp` wrapping package. From googling around, it seems that the [rug crate](https://crates.io/crates/rug) is the most recommended and most frequently kept up to date. Which also makes [the rug repo](https://gitlab.com/tspiteri/rug) a worthwhile read for what is a good idea to include in the package metadata. As a side note, it's interesting that this is the second time looking up a `gmp` wrapping package, and the most recommended happens to be hosted on gitlab; the other being the one we used in R, [_this_ gmp package](https://forgemia.inra.fr/sylvain.jasson/gmp). That aside, it'd be a good idea to get used to adding the function using [rust's types](https://doc.rust-lang.org/book/ch03-02-data-types.html) before adding arbitrary integers, although with one of those types being `i128`/`u128`, it's possible it's also valuable having a non arbitrary integer version too, considering the rationale for not bothering with multiple versions elsewhere has either been that they aren't particularly performant languages, or that their largest types are 64 bits, which is shorter than the 68 bit numbers up to which the Collatz conjecture has been manually verified, making any effort to optimise anything less than that meaningless.

We can add a new custom error, following the [traits](https://doc.rust-lang.org/stable/book/ch10-02-traits.html) pattern, for [std::error::Error](https://doc.rust-lang.org/std/error/trait.Error.html). The [example](https://doc.rust-lang.org/rust-by-example/error/multiple_error_types/define_error_type.html) for custom errors isn't particularly clear. If we do something like
```rust
use std::error::Error;
struct CustomError;
impl Error for CustomError {};
```
We'll get some good complaints from the rust analyser plugin that mirror the content that can be found on line, but it takes a while to track down where the source of this information can be found. The [std::error::Error](https://doc.rust-lang.org/std/error/trait.Error.html) trait mentions that;
> Errors must describe themselves through the Display and Debug traits.

Well, if we have a look at [std::fmt::Display](https://doc.rust-lang.org/std/fmt/trait.Display.html) and [std::fmt::Debug](https://doc.rust-lang.org/std/fmt/trait.Debug.html) we'll see some more information. Debug's page suggests the same in example blogs; to just use `#[derive(Debug)]`. A short while later and we end up with something like this [[a good example](https://stevedonovan.github.io/rust-gentle-intro/6-error-handling.html)];
```rust
// Create a custom error, FailedSaneParameterCheck, with a message.
#[derive(Debug)]
pub struct FailedSaneParameterCheck {message: String}
impl Error for FailedSaneParameterCheck {}
impl fmt::Display for FailedSaneParameterCheck {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{}", self.message)
    }
}

// A function to determine if it should be thrown or not.
fn assert_sane_parameterisation(p: i128, a: i128, _b: i128) -> Result<(),FailedSaneParameterCheck> {
    if p == 0 {
        return Err(FailedSaneParameterCheck{message: "'p' should not be 0 ~ violates modulo being non-zero.".to_string()});
    }
    if a == 0 {
        return Err(FailedSaneParameterCheck{message: "'a' should not be 0 ~ violates the reversability.".to_string()});
    }
    Ok(())
}

// Using the asserting function to throw if necessary.
pub fn function(n: i128, p: i128, a: i128, b: i128) -> Result<i128,FailedSaneParameterCheck> {
    assert_sane_parameterisation(p, a, b)?;
    if n % p == 0 { Ok(n/p) } else { Ok(a*n+b) }
}
```
In which we can use `function` and get a result `val_of_func_on_vars` that can be formatted for printing `format!("{val_of_func_on_vars:?}")` and yield something like `Err(FailedSaneParameterCheck { message: "'p' should not be 0 ~ violates modulo being non-zero." })`.

**However**, although we now know how to add and throw a custom error and the _Result_ type return, there is an important question raised and answered by the rust docs. Rust has a preference for `panic!` over using `Result` types. The "book" section [To `panic!` or Not to `panic!`](https://doc.rust-lang.org/book/ch09-03-to-panic-or-not-to-panic.html), and the subsection [Encoding States and Behavior as Types](https://doc.rust-lang.org/book/ch17-03-oo-design-patterns.html#encoding-states-and-behavior-as-types) that covers **assertions** ([std::assert](https://doc.rust-lang.org/std/macro.assert.html)) offer a good reading on this. Yet it's still nuanced. So we'll say, we'll `panic!` in the parameterised but non-gmp module, but we'll use the custom error approach in the gmp based module.
