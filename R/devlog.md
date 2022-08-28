# Devlog
[R](https://www.r-project.org/), and [CRAN](https://cran.r-project.org/). There's also [R Technical Papers](https://developer.r-project.org/TechDocs/), [Getting Help with R](https://www.r-project.org/help.html), [The R Manuals](https://cran.r-project.org/manuals.html) (which includes [Writing R Extensions (covers how to create your own packages)](https://cran.r-project.org/doc/manuals/r-release/R-exts.html)), and [Certification](https://www.r-project.org/certification.html) (which includes [R: Software Development Life Cycle](https://www.r-project.org/doc/R-SDLC.pdf)). Besides what these may include about "how to" start writing a package, the CRAN page includes links to [CRAN Repository Policy](https://cran.r-project.org/web/packages/policies.html) and [Submit a package to CRAN](https://xmpalantir.wu.ac.at/cransubmit/) which are also useful to read to see what the process expects!

After writing further down, it's probably worthwhile retroactively coming back up here and just saying that it's impossible to learn R without seeing [Hadley Wickham](https://github.com/hadley) appearing behind every curtin, and many of the packages we end up using here come from him. So while I have intentionally tried to stay free of the shackles of an IDE and run everything through scripts / recipes, [RStudio](https://www.rstudio.com/) might actually be worth checking out.

Previously, I've been using [GitHub Trending for <X> language](https://github.com/trending/r?since=weekly) as a starting point to look at how highely ranked existing repos chose to organise their projects, but the most stars in the last week for an R repo is [this one](https://github.com/rmcelreath/stat_rethinking_2022). So I'll collect a few other examples to look at -- {[rstudio/shiny](https://github.com/rstudio/shiny), [tidyverse/ggplot2](https://github.com/tidyverse/ggplot2), [r-lib/pkgdown](https://github.com/r-lib/pkgdown), [satijalab/seurat](https://github.com/satijalab/seurat), [facebookexperimental/Robyn](https://github.com/facebookexperimental/Robyn)}. A blog that might be useful is [this](https://kbroman.org/pkg_primer/).

Before beginning it's worth mentioning that this might be the "stick in the mud" language as far as the goal of having complete CICD for all languages goes, being that the CRAN submission page appears to intend a manual submission of code, although it might be possible to hack something together that automates interacting with the form to upload a submission, it is clearly not intended. [A search for "R" in the actions marketplace](https://github.com/marketplace?type=actions&query=R) not only reveals no action for automating the submission of a package, but in what feels like perverse serendipity, the fourth result in ***my*** [Julia: R&R ~ Release and Register](https://github.com/marketplace/actions/julia-r-r-release-and-register) package! The _top_ hit is this [R-actions](https://github.com/marketplace/actions/r-actions) which doesn't look "official" but could be worth while reading, even if I'd enjoy the challenge of trying to implement it myself. The most "official" appears to be a handful of actions by the organisation "insightsengineering", [here](https://github.com/search?q=topic%3Agithub-actions+org%3Ainsightsengineering&type=Repositories). Going to google to see if an action exists to install R in a CI step reveals this [r-lib/actions](https://github.com/r-lib/actions) repository, which _is_ an official repo with a bunch of actions, which don't appear on the marketplace because all the actions are bundled into one repo!

Being Australian, we'll download the latest R from the [csiro mirror](https://cran.csiro.au/) for windows and follow [this](https://cran.r-project.org/bin/linux/ubuntu/) for WSL. While we wait for these to download, we'll checkout [Writing R Extensions 1.1 Package structure](https://cran.r-project.org/doc/manuals/r-release/R-exts.html#Package-structure). We'll start off with a "Hello World" file, which prompts to download [this extension](https://marketplace.visualstudio.com/items?itemName=REditorSupport.r). Part way through filling out the DESCRIPTION file, I had to look up whether the apache license would be acceptable for it, as it makes explicit mention of a few others as the "main" license. It's also worth noting that a few of the examples I've looked at all fulfill the required existence of `./man/*.Rd` via "roxygen2"? Will need to look into that!

I'd like a "first" check to run `R CMD check .`, but it appears in doesn't like the recommended use of an `Authors@R: c(person("Nathan", "Levett", role = c("aut", "cre"), email = "nathan.a.z.levett@gmail.com"))` line in the `DESCRIPTION` in place of the normal `Author` and `Maintainer` fields. Although, the CRAN package policy states "Please ensure that `R CMD check --as-cran` has been run _on the tarball to be uploaded_", so I suppose we'll avoid checking "here" and build before checking. Also although earlier there was a page with a list of licenses that were common in R, the list of those likely to be accepted for CRAN are [here](https://svn.r-project.org/R/trunk/share/licenses/license.db), which _does_ include Apache v2. There's also a more comprehensive list of all _previously_ distributed packages [here](https://cran.r-project.org/src/contrib/Archive/), which is more than just the "current" ones. But it also appears searching for Collatz in there yields nothing. There's also an "[incoming](https://cran.r-project.org/incoming/)" list of packages prior to actual approval that's worth bookmarking. Lastly, while earlier the "submit" page was yielding [this link](https://xmpalantir.wu.ac.at/cransubmit/), it appears a more accurate link exists on the policy page, which links to [submit here](https://cran.r-project.org/submit.html). There's also a "[submission checklist](https://cran.r-project.org/web/packages/submission_checklist.html)".

There's a few "arbitrary integer precision" packages on CRAN, but it doesn't seem like there's an in built arbitrary integer package, so we'll need to pick from [gmp](https://cran.r-project.org/web/packages/gmp/index.html), [Rmpfr](https://cran.r-project.org/web/packages/Rmpfr/index.html), [bignum](https://cran.r-project.org/web/packages/bignum/index.html), or [Ryacas](https://cran.r-project.org/web/packages/Ryacas/index.html).

Even without the constant suggestion of simplicity that Go had, the lack of simplicity in installing R packages is starting to become very frustrating, with the constant need to compare errors across a handful of sites to confirm why each new attempt to progressively install more of the packages is not working. The installation on the windows side keeps popping up a message that the language server is required, but even when opening as admin, the installation it's attempting, `C:\Program Files\R\R-4.2.1\bin\R.exe --silent --slave --no-save --no-restore -e install.packages('languageserver', repos='https://cran.r-project.org/')` keeps failing with the message that the package doesn't exist for this version, and trying to [`Rscript -e 'install.packages("devtools")'`](https://cran.r-project.org/package=devtools) from WSL not only took around about an hour to run through, but ended up with 25 Warnings of packages that it couldn't install, with recommendations for a whole host of debian packages that need to be installed first (but which only revealed their necessity on subsequent iterative installation attempts). So even while R doesn't have the same pretense of simplicity that Go did, it's safe to say its package management is anything _BUT_ simple. More annoyingly than packages not being installable is that regardless of a package failing or not, other downstream packages that rely on it will still attempt to download and install and then fail on a missing dependency that it should already have known failed earlier. This, coupled with the installation of the `stringi` package somehow not working as it always downloads a differently sized package to what it expects and errors out (as it timesout on the 60 seconds to download 7.7Mb), means that having run the command to install devtools multiple times, I've realised that it is not idempotent, and is quite thirsty, having taking up 4Gb of space so far. The difficulty in getting something so basic working does make me question why the language is so popular, or at least, for creating packages in. It's very frustrating that is also keeps failing on installing a "Font Manager" library. It's also so anti-idempotent that during one round of installing dependencies, it _removed_ one of the ones it succeded at installing only a few minutes earlier and now won't reinstall it after a few attempts. It took around 20 attempts, but everything has finally downloaded and installed, with a hefty list of debian packages that are also required for devtools.

While there's a lot of ways that generally installing packages in the above could be less painful, it could also be a lot less painful if the devtools package itself made reference to what its minimum supported environments would require already installed to allow it to work. My `make setup_debian` recipe attempts to do this partially for the current release, although it wasn't a fresh ubuntu image, so I can't guarantee it didn't also already have other required packages installed and thus not added to that list. I tried to see about R related image on docker-hub, which has [this _docker official_ image](https://hub.docker.com/_/r-base) which points to the repo [rocker-org/rocker](https://github.com/rocker-org/rocker). Searching that page for any mention of "devtools" yields a link to the [rocker/tidyverse](https://hub.docker.com/r/rocker/tidyverse) images which themselves then link to the repo [rocker-org/rocker-versioned2](https://github.com/rocker-org/rocker-versioned2), whose [latest tidyverse dockerfile](https://github.com/rocker-org/rocker-versioned2/blob/30c72e028f4c6cf4d3c031fb64b5b0d63cc94cf7/dockerfiles/tidyverse_4.2.1.Dockerfile) (besides starting off from the rstudio base) runs [this script](https://github.com/rocker-org/rocker-versioned2/blob/30c72e028f4c6cf4d3c031fb64b5b0d63cc94cf7/scripts/install_tidyverse.sh), which does [this apt insall](https://github.com/rocker-org/rocker-versioned2/blob/30c72e028f4c6cf4d3c031fb64b5b0d63cc94cf7/scripts/install_tidyverse.sh#L18) set of libraries. It's not necessary right now to identify a minimum set of installable libraries for devtools, but a superset of that information is definitely obtainable.

We'll pick [gmp](https://cran.r-project.org/package=gmp) ([pdf](https://cran.r-project.org/web/packages/gmp/gmp.pdf)) for arb ints. Which appears to work like magic, woah. It's basically the "it's free real-estate" meme. It using the bigz class it provides instead of ints adds no additional overhead or even requires multiple function definitions, so it can stay as tidy as python, even though it did need a library for arbitrary integers, it's _real neat_. So with the function and reverse function appearing to work, lets have a look at introducing unit tests. The main name that's always popping up is "[testthat](https://cran.r-project.org/package=testthat)" (which has a staggeringly large "Reverse suggests" list, multiple times as long as the devtools package). We can initiate "testthat" with `Rscript -e 'usethis::use_testthat()'`. Running this provides the source of so many reverse suggestions with the second action it takes being "✔ Adding 'testthat' to Suggests field in DESCRIPTION", which I was already planning on adding, but it occurs to me that it's funny that running "testthat" adds itself to the suggestions, but devtools did not add itself to the suggestions. To continue setting up tests, we can run `Rscript -e 'usethis::use_test("Collatz")'`, and copy over the tests used from the java version.

I realised upon testing for the first time in the gh action that it would be irritatingly long each time to install dependencies that have to recompile, and why do so, when we can just reuse the tidyverse images provided above, which exist far back enough to have a 3.5.0 tagged image, which is the earliest version I want to test on (being the minimum version of the only dependency, gmp). With tests now working in the workflow, the last things to check out are [pkgdown](https://pkgdown.r-lib.org/) for creating a site, but first, [roxygen2](https://roxygen2.r-lib.org/) for generating the `./man/`! It seems that Roxygen doesn't like the DESCRIPTION not including `Encoding: UTF-8` which is against the CRAN standard of ASCII, and I'd been trying to stick with that, but roxygen adds too much benefit to not use it. With a minimum setup of roxygen, let's have a look at using pkgdown. Start with `Rscript -e 'usethis::use_pkgdown()'`.

I did a fair amount of experimenting with setting up the generating of the pdf without commenting about it here, but I finally got it working. Locally it would work 50/50 (for some reason it just casually fails half the time, and works fine the other half of the time, on back to back invocations with no background changes..) but it took installing the debian texinfo package in the rocker/tidyverse container to get it to manage to generate the pdf in the workflow. We're now ready to;
1. `git checkout --orphan gh-pages-R`
1. `rm .git/index ; git clean -fdx`
1. `git commit -m "Initial empty orphan" --allow-empty`
1. `git push --set-upstream origin gh-pages-R`

Which means we now have the target for where to deploy docs to, and then test that they are fine to merge to the main gh-pages branch. A funny quirk of pkgdown appears to be that it requires newlines above header lines in the markdown files that it converts to the home page, so the readme here will be formatted slightly differently, although visually inconsequentially so, to all the others. I've reached the stage where I can generate docs, and test successfully across ubuntu, mac and windows, and complete a CRAN check on the latest. So we'll merge to main now to get the 0.1.0 release into main before then adding vignettes and the hailstone and tree graph functions.

We've released version 0.1.0, but I've realised that my desire to keep the roxygen2 generated namespace and man folder changes only to be generated in CI has hit a roadblock; using devtools to install from github would require the state of the repo to be as the contents of the tarballs would be, so we've got to swap it around and make sure that we do checkin the man folder and namespace changes, which means adding the ability to fail the workflow if it detects a change that hasn't been checked in. This led to discovering a semi-bug, that if using a job container in github actions, that the repository checked out with actions/checkout step won't be owned by the user inside the job container that is used to evoke the run commands, so we need to add the checkout as a safe directory so that we can compare and error on a diff. Now we need to start looking at vignettes `Rscript -e 'usethis::use_vignette("my-vignette")'`.

Well, I've got most of the content sorted, but have uncovered an unusual behaviour I didn't see before in how `bigz` isn't easy to use in an iterative sense, i.e. like `append`'ing to a list and then looping through them. I only caught it because the bug surfaced through using a vignette for the tree graphing function when using a `bigz`, and the error can be reproduced with something like `append(list(), gmp::as.bigz(5))`, which yields;
```R
> append(list(), as.bigz(5))
Error in c_bigz(argL) : 
  only logical, numeric or character (atomic) vectors can be coerced to 'bigz'
```
The reverse function and the tree graph that uses it are the only places that the append can operate on a `bigz`, and it seems it doesn't behave well with them. For example;
```R
> f <- list()
> f <- append(f, as.bigz(3))
Error in c_bigz(argL) : 
  only logical, numeric or character (atomic) vectors can be coerced to 'bigz'
```
If the list is initialised with a numeric, `f <- list(1)`, then appending a `bigz` doesn't produce the same error, but it adds the entire raw contents. For example, the resulting list of adding a small `bigz` to a number is 17 elements long. If `f` in the example is initialised with a `bigz`, then the result is the same, but the first element is the `bigz` and the following 16 entries are the raw contents of the appended `bigz`. HOWEVER, there is a solution! By wrapping the appended content in another `list()` invocation, it does properly separate them.
```R
> f <- list()
> f <- append(f,list(as.bigz(1)))
> f
[[1]]
Big Integer ('bigz') :
[1] 1
```

After releasing version 1 of this R implementation, I've uploaded it to CRAN, which resulted in an email "CRAN Submission of collatz 1.0.0 - Confirmation Link" with a link `https://<some_cran_mirror>/cransubmit/conf_mail.php?code=<unique_submission_code>` to confirm the submission, and included the comments on the submission. After confirming the upload, the tarball appeared in the [incoming/pretest](https://cran.r-project.org/incoming/pretest/) section, before then 8 minutes later recieving a "package collatz_1.0.0.tar.gz has been auto-processed and is pending a manual inspection" email, which included (along with the upload now instead appearing in [incoming/inspect](https://cran.r-project.org/incoming/inspect/))
```txt
Log dir: <https://win-builder.r-project.org/incoming_pretest/collatz_1.0.0_20220827_180118/>
The files will be removed after roughly 7 days.
Installation time in seconds: 5
Check time in seconds: 88
R Under development (unstable) (2022-08-25 r82762 ucrt)

Pretests results:
Windows: <https://win-builder.r-project.org/incoming_pretest/collatz_1.0.0_20220827_180118/Windows/00check.log>
Status: 1 NOTE
Debian: <https://win-builder.r-project.org/incoming_pretest/collatz_1.0.0_20220827_180118/Debian/00check.log>
Status: 1 NOTE
```
The windows check was;
```txt
* using log directory 'd:/RCompile/CRANincoming/R-devel/collatz.Rcheck'
* using R Under development (unstable) (2022-08-25 r82762 ucrt)
* using platform: x86_64-w64-mingw32 (64-bit)
* using session charset: UTF-8
* checking for file 'collatz/DESCRIPTION' ... OK
* this is package 'collatz' version '1.0.0'
* package encoding: UTF-8
* checking CRAN incoming feasibility ... [14s] NOTE
Maintainer: 'Nathan Levett <nathan.a.z.levett@gmail.com>'

New submission

Possibly misspelled words in DESCRIPTION:
  Collatz (5:33, 6:68)
  parameterisation (7:9)

Found the following (possibly) invalid URLs:
  URL: http://localhost:4321
    From: README.md
    Status: Error
    Message: Failed to connect to localhost port 4321: Connection refused
  URL: https://skenvy.github.io/Collatz/R (moved to https://skenvy.github.io/Collatz/R/)
    From: DESCRIPTION
    Status: 200
    Message: OK
  URL: https://skenvy.github.io/Collatz/R/pdf (moved to https://skenvy.github.io/Collatz/R/pdf/)
    From: DESCRIPTION
    Status: 200
    Message: OK
* checking package namespace information ... OK
* checking package dependencies ... OK
* checking if this is a source package ... OK
* checking if there is a namespace ... OK
* checking for hidden files and directories ... OK
* checking for portable file names ... OK
* checking whether package 'collatz' can be installed ... OK
* checking installed package size ... OK
* checking package directory ... OK
* checking for future file timestamps ... OK
* checking 'build' directory ... OK
* checking DESCRIPTION meta-information ... OK
* checking top-level files ... OK
* checking for left-over files ... OK
* checking index information ... OK
* checking package subdirectories ... OK
* checking R files for non-ASCII characters ... OK
* checking R files for syntax errors ... OK
* checking whether the package can be loaded ... [1s] OK
* checking whether the package can be loaded with stated dependencies ... [0s] OK
* checking whether the package can be unloaded cleanly ... [0s] OK
* checking whether the namespace can be loaded with stated dependencies ... [0s] OK
* checking whether the namespace can be unloaded cleanly ... [1s] OK
* checking loading without being on the library search path ... [1s] OK
* checking use of S3 registration ... OK
* checking dependencies in R code ... OK
* checking S3 generic/method consistency ... OK
* checking replacement functions ... OK
* checking foreign function calls ... OK
* checking R code for possible problems ... [5s] OK
* checking Rd files ... [1s] OK
* checking Rd metadata ... OK
* checking Rd line widths ... OK
* checking Rd cross-references ... OK
* checking for missing documentation entries ... OK
* checking for code/documentation mismatches ... OK
* checking Rd \usage sections ... OK
* checking Rd contents ... OK
* checking for unstated dependencies in examples ... OK
* checking installed files from 'inst/doc' ... OK
* checking files in 'vignettes' ... OK
* checking examples ... NONE
* checking for unstated dependencies in 'tests' ... OK
* checking tests ... [4s] OK
  Running 'testthat.R' [4s]
* checking for unstated dependencies in vignettes ... OK
* checking package vignettes in 'inst/doc' ... OK
* checking re-building of vignette outputs ... [16s] OK
* checking PDF version of manual ... [20s] OK
* checking HTML version of manual ... [1s] OK
* checking for detritus in the temp directory ... OK
* DONE
Status: 1 NOTE
```
And the debian check was;
```txt
* using log directory ‘/srv/hornik/tmp/CRAN/collatz.Rcheck’
* using R Under development (unstable) (2022-08-25 r82762)
* using platform: x86_64-pc-linux-gnu (64-bit)
* using session charset: UTF-8
* checking for file ‘collatz/DESCRIPTION’ ... OK
* this is package ‘collatz’ version ‘1.0.0’
* package encoding: UTF-8
* checking CRAN incoming feasibility ... [3s/4s] NOTE
Maintainer: ‘Nathan Levett <nathan.a.z.levett@gmail.com>’

New submission

Possibly misspelled words in DESCRIPTION:
  Collatz (5:33, 6:68)

Found the following (possibly) invalid URLs:
  URL: http://localhost:4321
    From: README.md
    Status: Error
    Message: Failed to connect to localhost port 4321 after 0 ms: Connection refused
  URL: https://skenvy.github.io/Collatz/R (moved to https://skenvy.github.io/Collatz/R/)
    From: DESCRIPTION
    Status: 301
    Message: Moved Permanently
  URL: https://skenvy.github.io/Collatz/R/pdf (moved to https://skenvy.github.io/Collatz/R/pdf/)
    From: DESCRIPTION
    Status: 301
    Message: Moved Permanently
* checking package namespace information ... OK
* checking package dependencies ... OK
* checking if this is a source package ... OK
* checking if there is a namespace ... OK
* checking for executable files ... OK
* checking for hidden files and directories ... OK
* checking for portable file names ... OK
* checking for sufficient/correct file permissions ... OK
* checking whether package ‘collatz’ can be installed ... [1s/1s] OK
* checking package directory ... OK
* checking for future file timestamps ... OK
* checking ‘build’ directory ... OK
* checking DESCRIPTION meta-information ... OK
* checking top-level files ... OK
* checking for left-over files ... OK
* checking index information ... OK
* checking package subdirectories ... OK
* checking R files for non-ASCII characters ... OK
* checking R files for syntax errors ... OK
* checking whether the package can be loaded ... [0s/0s] OK
* checking whether the package can be loaded with stated dependencies ... [0s/0s] OK
* checking whether the package can be unloaded cleanly ... [0s/0s] OK
* checking whether the namespace can be loaded with stated dependencies ... [0s/0s] OK
* checking whether the namespace can be unloaded cleanly ... [0s/0s] OK
* checking loading without being on the library search path ... [0s/0s] OK
* checking use of S3 registration ... OK
* checking dependencies in R code ... OK
* checking S3 generic/method consistency ... OK
* checking replacement functions ... OK
* checking foreign function calls ... OK
* checking R code for possible problems ... [2s/2s] OK
* checking Rd files ... [0s/0s] OK
* checking Rd metadata ... OK
* checking Rd line widths ... OK
* checking Rd cross-references ... OK
* checking for missing documentation entries ... OK
* checking for code/documentation mismatches ... OK
* checking Rd \usage sections ... OK
* checking Rd contents ... OK
* checking for unstated dependencies in examples ... OK
* checking installed files from ‘inst/doc’ ... OK
* checking files in ‘vignettes’ ... OK
* checking examples ... NONE
* checking for unstated dependencies in ‘tests’ ... OK
* checking tests ... [1s/1s] OK
  Running ‘testthat.R’ [1s/1s]
* checking for unstated dependencies in vignettes ... OK
* checking package vignettes in ‘inst/doc’ ... OK
* checking re-building of vignette outputs ... [3s/3s] OK
* checking PDF version of manual ... [2s/2s] OK
* checking HTML version of manual ... [0s/0s] OK
* checking for non-standard things in the check directory ... OK
* checking for detritus in the temp directory ... OK
* DONE
Status: 1 NOTE
```
I do find it funny that the `x86_64-w64-mingw32` check included `parameterisation (7:9)` in `Possibly misspelled words in DESCRIPTION`, and both github pages in the notes yielded http 200, but in the `x86_64-pc-linux-gnu` check it did not complain about `parameterisation`, and both github pages links yielded a http 301.
