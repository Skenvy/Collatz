## R CMD check results
There were no ERRORs or WARNINGs. 

There was 1 NOTE:

* ```
  Found the following (possibly) invalid URLs:
  URL: http://localhost:4321
    From: README.md
    Status: Error
    Message: libcurl error code 7:
      	Failed to connect to localhost port 4321 after 2243 ms: Connection refused
  URL: https://skenvy.github.io/Collatz/R/articles/collatz.html#install
    From: inst/doc/hailstones.html
          inst/doc/hailstones_576460752303423488.html
          inst/doc/treegraphs.html
    Status: 404
    Message: Not Found
  ```
  * `URL: http://localhost:4321 From: README.md`: Is intentional and a reference to the local address that running `servr` without options will host the docs at, as a comment on a make recipe to be used during development in the `## Developing` section of the readme.
  * `URL: https://skenvy.github.io/Collatz/R/articles/collatz.html#install`: is appearing as a 404 in the iteration of CRAN check run before merging, and the gh-pages URL _should_ exist after merging (used to link between vignette pages), so this note shouldn't be present in a CRAN check run on the tarball after merging.
