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
* [Editions Guide](https://doc.rust-lang.org/stable/edition-guide/); with editions being important enough that it's one of the three properties generated in the default project by `cargo init`.
* [Packaging and distributing a Rust tool](https://rust-cli.github.io/book/tutorial/packaging.html) which describes how to `cargo publish` effectively.

As well as other loose resources such as;
* The [rust-lang](https://github.com/rust-lang) repositories; [rust](https://github.com/rust-lang/rust), [cargo](https://github.com/rust-lang/cargo), [crates.io](https://github.com/rust-lang/crates.io), [libc](https://github.com/rust-lang/libc)
* [Wikipedia](https://en.wikipedia.org/wiki/Rust_(programming_language)) | The Rust [_discord_](https://discord.gg/rust-lang) | Reddit's [r/rust](https://www.reddit.com/r/rust/)

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
