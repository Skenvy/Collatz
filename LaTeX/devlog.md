# Devlog
Whilst the root devlog's "original motivation" briefly addresses part of the "why" this project came into existence, at least from the programming perspective of wanting something simple to experiment with monorepoing multiple packages from, here I will address the "original original motivation"; _before I had the idea to make a project focused on the topic, I had spent some time being interested in the Collatz conjecture already._

## """Original""" "Original Motivation"
> [!CAUTION]
> This is an adhoc summary written several years after dabbling in a topic that is one of the most abundant with people claiming solutions that are dubious at best. That's not what this is. This was just some fun. I have mentioned some things here without bothering to go into more detail on them because this is just a summary, I'm not expecting them to be meaningful to anyone, and plan to eventually write them into the pdf. It is _**not**_ a `proof by "just trust me"`.

I first started reading up on the problem several months before [Terrence Tao](https://arxiv.org/search/math?searchtype=author&query=Tao,+T)'s 2019 [Almost all orbits of the Collatz map attain almost bounded values](https://arxiv.org/abs/1909.03562) came out, possibly from having seen it on [Numberphile's video](https://www.youtube.com/watch?v=5mFpVDpKX70). I had spent those several months, and about half a notebook, idling writing out explorations into different areas of the problem. I had stumbled across a few insights that, although they weren't new, they were fun to rediscover before learning of their prior existence.

Back when Tao released his paper, he also released some posts about it on his wordpress, like [this one](https://terrytao.wordpress.com/2019/09/10/almost-all-collatz-orbits-attain-almost-bounded-values/). I can't find the post I remember reading from back then again, or the comment on it, but I remember one specific insight I had rediscovered, that someone else had asked about in the comments on one of the wordpress pages, to which Tao replied with the name of the original paper that had demonstrated that property, and I enjoyed that I had reacquired a result from some paper from 50ish odd years earlier.

The joy of mathematics is in these moments of discovery. It doesn't matter that the result was already known half a century earlier than I thought about it. I had fun reaching the same conclusion on my own. Of course, there is an extent to which you can tackle a problem without reading any of the papers that already exist on the topic, and at which point it's better to know what is already known. I hadn't reached that point yet.

I ended my notes at this stage in 2019 with what I had called sub-residue and super-residue classes -- the idea being that any residue class could be a "super" class that could be broken up into multiple sub-residue classes. In the specific case of my original notes, it was that the values `4 mod 6` had specific leaps between them I was interested in, and noted that the "sub-residues" of this (`4 mod 24`, `10 mod 24`, `16 mod 24`, and `22 mod 24`) had themselves more consistent behaviour. The point my notes ended at was that, after _indexing_ all **values** in the class `4 mod 6` (i.e. 0th value is 4, 1st value is 10...), that the sub-residues of a top level "identity super-residue" `0 mod 1` ;= `0 mod 2` U `1 mod 2` ;= `0 mod 4` U `1 mod 4` U `2 mod 4` U `3 mod 4` etc. had patterns that appeared to repeat frequently under most sub-residues. The specific last point I had in this tangent was that for the `x mod 16`'s, 13 classes were always provable to eventually descend by the way their sub-residue classes behaved the same as specific super-residues, and 3 classes weren't consistently eventually descending or not.

I took a hiatus from the problem until [Veritasium's video](https://www.youtube.com/watch?v=094y1Z2wpJg) reminded me about it.  I tried to read through my previous notes and it was a bit of a challenge because I hadn't written them out particularly well ordered, or just in one notebook. Parts of the notes were written forwards and backwards across a few notebooks. At this point, I wanted to commit to trying to put the notes into LaTeX so they were easier to keep organised and all in one place and cut down on duplicate proofs for simple things.

But it wasn't bad enough to stop me from writing some more notes, which this time ended with a way to assess the "potential validity" of some cycles; an expression that would have to result in an integer for a cycle to be valid. A very simple but decisive piece of this was that the denominator was the difference between powers of the multiplier and the divider. For the normal parameterisation of the problem, this was `2^d - 3^m` with `d` and `m` being the amount of division steps and multiplication steps respectively. For the only known cycle in the positives, this was `2^2 - 3^1 = 1`. For the known cycles in the negatives, there is the `-1` cycle with `2^1 - 3^1 = -1`,  the `-5` cycle with `2^3 - 3^2 = -1`. Besides the zero self loop having a numerator of `0`, I found it interesting that these three loops of `1`, `-1`, and `-5` all had a `1` or `-1` denominator. Only the `-17` cycle had a non-unitary denominator of `2^11 - 3^7 = -139`. I considered that, for being an amateur at this just having fun with it, that was a fair point in time to call it and be content with saying `-17`'s was a non-trivial cycle, but the others were "trivial-ish".

A few months after that, I started trying to write my notes in LaTeX, but the effort felt cumbersome for something that didn't already have a presence. I had some scripts I had written to evaluate the sub-residues from earlier, so I decided that before coming back to and trying to write my notes in LaTeX, I would try and create a presence in the form of some simple packages, initially just so that I had more basic building blocks for my scripts, but it turned in to this. And then I had the [initial commit on 8th of March 2022](https://github.com/Skenvy/Collatz/commit/01efc0533ab002f19d68aae14476cc6843308091) for this repository. And only now in January of 2025 and I looking at my old barely put together notes, thinking I should maybe add the first draft of them, finally.

## Context of the state this is in on first PR "here"
The initial `document.tex` is a series of commits replayed from the original "collatz" repo I made before this one, when I was initially writing my poorly organised notes into LaTeX. It will eventually be expanded upon, but I'm moving it here before cleaning it up because I haven't yet gotten around to cleaning it up, and having a home for it was the original reason for starting this sort of project.

## What's what
[TeX](https://tug.org/) ([wiki](https://en.wikipedia.org/wiki/TeX)) and [LaTeX](https://www.latex-project.org/) ([wiki](https://en.wikipedia.org/wiki/LaTeX)).

## What we need to make the pdf
To enable building the pdf on ubuntu, we need;
```bash
sudo apt-get install texlive-latex-base
```
This is all we _need_ to `make pdf` and get the generated pdf, but it's worth knowing that searching around for how to build pdf's, sites often also cite `texlive-latex-recommended` and `texlive-latex-extra` as suggested for install alongside `texlive-latex-base` but they amount to several additional GB of space, so I'd like to avoid them until necessary.

## Adding additional LaTeX components
I would like to add hyperlinks to the output of the pdf. I added the `\usepackage{hyperref}` but now trying to rebuild the pdf yields the error ``! LaTeX Error: File `etoolbox.sty' not found.``. [This Q&A on tex stackexchange](https://tex.stackexchange.com/questions/73016/how-do-i-install-an-individual-package-on-a-linux-system/73017) addresses common ways of solving this issue. One of them is `tlmgr`.
On our version of ubuntu, `texlive-latex-base` gave us `tlmgr`. We can try `tlmgr install etoolbox` but we get an error about not initiating user mode. To do so we can `tlmgr init-usertree`. We can now retry `tlmgr install etoolbox` but get an error that `tlmgr: Local TeX Live (2023) is older than remote repository (2024).`. [The tlmgr page](https://www.tug.org/texlive/tlmgr.html) includes mention of the `update-tlmgr-latest(.sh/.exe) --update` that the previous error suggests using. So we can download that script and use it to update tlmgr. Of course, this produces another error. Firstly, that the script doesn't understand the `--update` flag. Secondly, that it can't find the TeX live root or any TeX paths that are set.

At this point, it's worth knowing that if we wanted to install "just" "TeX Live" that the [quickinstall](https://www.tug.org/texlive/quickinstall.html) mentions that it defaults to including around 7GB of content, which feels absurd. I'll just give up trying to understand acquiring a specific version of LaTeX or TeX and accept whatever the default version is for my version of ubuntu, because accepting that `sudo apt-get install texlive-latex-extra` wants to use a few GB is easier than chasing a thousand errors in trying to update just one component for a thing that might need the same amount of space to install the stuff to manage updating just one component anyway..
```bash
sudo apt-get install texlive-latex-extra
```
And I can rebuild the pdf with links.

## Sources to read
[Jeffrey C. Lagarias @ arxiv](https://arxiv.org/search/math?searchtype=author&query=Lagarias,+J+C) has several important reads, including these aggregate papers;
1. [An annotated bibliography (1963--1999)](https://arxiv.org/abs/math/0309224)
1. [An Annotated Bibliography, II (2000-2009)](https://arxiv.org/abs/math/0608208)
1. [An Overview](https://arxiv.org/abs/2111.02635)

Plus some other fun reads;
1. [Stochastic Models for the 3x+1 and 5x+1 Problems](https://arxiv.org/abs/0910.1944)
