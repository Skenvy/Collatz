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

As well as some examples plucked from trending rust repos;
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

## Tools
### `rustfmt`
[`rustfmt`](https://github.com/rust-lang/rustfmt) is a tool for formatting rust source. Essentially we can `cargo fmt` to auto format files, or check that no formating is required, with `--check`. We can use `rustfmt --print-config default rustfmt.toml` to generate a [configuration file](https://rust-lang.github.io/rustfmt/) that will be honoured by the tool, populated with what it considers [the default style](https://doc.rust-lang.org/nightly/style-guide/).

It's not that transparent of a tool to use OotB, though. With no `rustfmt.toml` configuration, running `cargo fmt --check` with an intentionally introduced error yields the format error correctly, but upon creating the default configuration, and rerunning `cargo fmt --check`, we're bombarded with many warnings like ``Warning: can't set `indent_style = Block`, unstable features are only available in nightly channel.`` for a whole bunch of the rules in the default configuration. The first question is what then, is the configuration being used when the "default" configuration file does not exist, given the existence of it yields so many warnings that the rules it stipulates aren't enforceable, but does not appear when the "default" configuration file doesn't exist either. The solution proposed is to run the "nightly" version, via `cargo +nightly fmt --check`. The first time, having not installed it separately, will give something like `error: toolchain 'nightly-x86_64-unknown-linux-gnu' is not installed`. We can `rustup toolchain install nightly` to install the nightly build, but one of the fields populated in the defaults is a `required_version`, so if we automate a dependency on the nightly build of rustfmt to be able to run fmt on the default rules, we'd also need to automate the creation of the config such that its required version was always whatever the nightly version was, i.e. `rustfmt +nightly --print-config default rustfmt.toml`, which makes it pointless to keep the rules in a configuration file at that point, if we're automating the config file's generation and then its use.

Why on earth does `rustfmt +stable --print-config default rustfmt.toml` produce a configuration file that it will warn on many of the choices within, that it cannot utilise them being not the nightly build. It would also appear that `unstable_features` is an option within the generated config that must be changed to true to allow the "unstable" rules even if using the `+nightly` build. It would likely be a lot less unexpected if the default generated config happened to explain any of this in a comment, or split the entries in the config up between stable and unstable rather than having them all in one soup. It also appears there's no way then to say, error if an unstable rule is specified, such that it's limited to only running on versions where all specified formatting rules are stable and can't run on older versions where rules may not be stable.

The best compromise right now appears to be to let `rustfmt +stable --print-config default rustfmt.toml` output what it wants and generally ignore all the `Warning: can't set X` warnings, while attempting to keep the version of rustfmt that's installed stable across the desire to test against a range of versions.

### `clippy`
[Clippy](https://github.com/rust-lang/rust-clippy) is a tool for linting rust source. It can be configured via a `clippy.toml` to include these [lint configuration options](https://doc.rust-lang.org/nightly/clippy/lint_configuration.html), which are also explained [here](https://rust-lang.github.io/rust-clippy/master/index.html#/). It does not appear to have a way to easily output its default configuration to a file the same way `fmt` did. We'll suffice for now to add a file that contains the links to the options as a comment, and trust that the defaults are stable.
