# Devlog
[Gleam](https://gleam.run/) [[gh](https://github.com/gleam-lang)|[core](https://github.com/gleam-lang/gleam)] is a _recent_ addition to the BEAM ecosystem (see [[Erlang](https://www.erlang.org/)] [[Elixir](https://elixir-lang.org/)] [[Hex](https://hex.pm/)]). Being [FLOSS](https://github.com/gleam-lang/gleam/blob/32ba73ff5401e5a976b6d250de7248b416ca9c43/LICENCE) from the [beginning](https://github.com/gleam-lang/gleam/blob/4d791cbf8e7ef93f9174103e4a547f1262cb7ace/LICENSE), maintained by nice, friendly people, and not being afraid to be immediately prescriptivist about its tooling, it should make for hopefully a gentle experience.
Recently spiked in popularity after [its v1 release](https://gleam.run/news/gleam-version-1/), especially in the land of "Streamer Driven Development" [[@t3dotgg](https://www.youtube.com/watch?v=_I-CSgoCgsk)] [[@ThePrimeTimeagen](https://www.youtube.com/watch?v=9mfO821E7sE)], it's the new hype.
This project does not yet have an implementation from the BEAM family. I figured I'd eventually think about maybe considering doing it in Elixir, which I've heard good things about, but it'd be fun to battle-test gleam's tools.
## Setup Environment / Tools
### "Install Gleam"
Funnily enough, the [gleam home page](https://gleam.run/) doesn't link directly to downloads. The first big button is [Try Gleam](https://tour.gleam.run/) [[1](https://tour.gleam.run/table-of-contents/)], and it's good to see a fancy in-browser tour, but I am surprised that there is still yet to be a prominent "download here" button.
The top panel though links the the [**docs**](https://gleam.run/documentation/), and the third link in here is where we see [Installing Gleam](https://gleam.run/getting-started/installing/). There are three parts to this. We'll be setting it up in Ubuntu WSL and Windows.
### Install "Gleam"
First, it will have us go to [the releases page](https://github.com/gleam-lang/gleam/releases), unless you want to use one of the package managers it's available in. But there is no `apt` install of it, so to the release page we go. It's not written anywhere there I can see, but we can put together;
```sh
VERSION=1.0.0 curl -s -L https://github.com/gleam-lang/gleam/releases/download/v$VERSION/gleam-v$VERSION-x86_64-unknown-linux-musl.tar.gz | tar xvz -C /tmp && mv /tmp/gleam ~/.local/bin/gleam
```
And we can install the windows side manually. I'm _surprised_ there isn't an installer yet, at least, because there're smaller products that have installers. But that's not an issue. And it's probably expected the users will know how to set their paths / manage multiple installs.
### Install Erlang
The gleam site recommends the ["Erlang solutions website"](https://www.erlang-solutions.com/resources/download.html), but surely [Download Erlang/OTP](https://www.erlang.org/downloads) is good as well? We can `sudo apt install erlang` and accept the half a Gb install, and download and run the windows installer. Windows side installed fine, `14.2.3`, but the WSL side required a `sudo apt --fix-broken install` followed by another `sudo apt install erlang`, and now it's on `10.6.4`.
It turns out later, that for rebar3, they "support the 3 latest major releases of erlang", and the number that comes back for `erl -version` is not the version of erlang, which can elsewise be obtained by running `erl -eval 'erlang:display(erlang:system_info(otp_release)), halt().'  -noshell` which shows us that on Windows we have version 26, and on WSL version 22. To update our WSL version we can;
```sh
curl -L https://binaries2.erlang-solutions.com/ubuntu/pool/contrib/e/esl-erlang/esl-erlang_25.0-1~ubuntu~focal_amd64.deb -o /tmp/esl-erlang_25.0-1.deb && sudo dpkg -i /tmp/esl-erlang_25.0-1.deb && rm /tmp/esl-erlang_25.0-1.deb
# But it needs sudo dpkg --auto-deconfigure -i /tmp/esl-erlang_25.0-1.deb, which then asks for;
sudo apt --fix-broken install && sudo apt autoremove -y
# And then it also needs manual dependencies
sudo apt install libncurses5 libsctp1
# Which once again wants a
sudo apt --fix-broken install
# Which asks to confirm to install libncurses5 libsctp1 libtinfo5, and NOW we can install the deb pkg.
# At least `rebar3 local install` works without any further complaints after fighting the erlang installation.
```
### Install [Rebar](https://rebar3.org/)
The gleam page simply says to follow [the rebar page](https://rebar3.org/docs/getting-started/). (Also see [gh:rebar3](https://github.com/erlang/rebar3)).
```sh
curl -L https://s3.amazonaws.com/rebar3/rebar3 -o ~/.local/bin/rebar3 && chmod +x ~/.local/bin/rebar3 && rebar3 local install
```
Yet, although the rebar3 page funnily enough makes a point of driving home that it should just work with any installed erlang, trying to run it on the version of erlang installed by apt on ubuntu 20 yields an;
```
escript: exception error: undefined function rebar3:main/1
  in function  escript:run/2 (escript.erl, line 758)
  in call from escript:start/1 (escript.erl, line 277)
  in call from init:start_em/1
  in call from init:do_boot/3
=ERROR REPORT==== 19-Mar-2024::23:33:00.202362 ===
beam/beam_load.c(1876): Error loading module rebar3:
  This BEAM file was compiled for a later version of the run-time system than 22.
  To fix this, please recompile this module with an 22 compiler.
  (Use of opcode 172; this emulator supports only up to 168.)
```
And on windows, adding the `rebar3.cmd` file adjacent to the `rebar3` with the contents it recommends yields a `===> Sorry, this feature is not yet available on Windows.`. So I guess we need to just use the file and the cmd script on Windows, and try updating Erlang in Ubuntu. The latest version that [Erlang Solutions](https://www.erlang-solutions.com/downloads/) provides for Ubuntu is 25. And after fighting the upgrade to Erlang version 25, `rebar3 local install` works as expected.
### Install Editor Plugin
A quick search on the vsc marketplace yields an official [VS Code Plugin](https://github.com/gleam-lang/vscode-gleam).
### "Writing Gleam"
[Writing Gleam](https://gleam.run/writing-gleam/) is an example of how to create a new gleam project. `gleam new <project-name>`. We'll run `gleam new howdy`.
