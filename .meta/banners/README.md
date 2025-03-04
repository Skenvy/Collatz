# Banners
These banners are a series of modifications (by way of colouring in) of [this image](https://twitter.com/Gelada/status/846751901756653568), originally by Edmund Harriss.

The original is included as well as scripts to generate the modifications, with the scripts and modifications placed under the adjacent [CC-BY-SA-4.0](https://creativecommons.org/licenses/by-sa/4.0/) license [[+](https://choosealicense.com/licenses/cc-by-sa-4.0/)] [[+](https://spdx.org/licenses/CC-BY-SA-4.0.html)].

## Generate the modifications
The end of `./.meta/banners/modifications/img.py` shows both `recreate_blank_image()` and `recreate_contiguities_map_file()`, and how to use `colour_in_blank_image_with_palette(new_image_path, desired_ratios)`.
Make a venv (I use [these aliases](https://github.com/Skenvy/dotfiles/blob/57638c35a0eb097e3b2a8dc9509b45986ebbc671/.bash_aliases#L34-L35)) and `pip install pillow` then you can `python3 img.py`.

## Where are the modifications?
See them all [here](https://github.com/Skenvy/Collatz/blob/main/.meta/banners/modifications/EXAMPLES.md).

To prevent committing too many large image files _here_, the generated images will be committed in this repository's wiki, and the links to the raw files hosted in the wiki will be used in `img` tags. You can clone the wiki as you would any other repo, with the `:owner/:repo` being `:owner/:<repo>.wiki`; either as `git clone git@github.com:Skenvy/Collatz.wiki.git` / `git clone https://github.com/Skenvy/Collatz.wiki.git`.

However, when accessing the raw contents, to `src` the images hosted in the wiki, the url does not use the `:<repo>.wiki` name, nor does it take a branch. For files in the wiki at location `./a/b/c.xyz`, they would be accessed as `https://raw.githubusercontent.com/wiki/:owner/:repo/a/b/c.xyz` e.g. if we host the modifications as `./.meta/banners/modifications/*.png`, then we access them as `https://raw.githubusercontent.com/wiki/Skenvy/Collatz/.meta/banners/modifications/*.png`
## Html for including the images in READMEs
We can then embed these images, stored in the wiki and accessed via `https://raw.githubusercontent.com/wiki/:owner/:repo/:filepath`, into the main repo's READMEs, with [this html embedding of a `<picture>`](https://github.com/stefanjudis/github-light-dark-image-example), combined with [`<figcaption>`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/figcaption), for example (with `<picture>` nested inside `<figure>`);
```html
<!-- For single image mode -->
<figure>
  <img alt="Banner Image, Collatz Coral" src="https://raw.githubusercontent.com/wiki/Skenvy/Collatz/.meta/banners/modifications/XYZ.png" width=830 height=666 style="display:block;margin-left:auto;margin-right:auto;"/>
  <figcaption><p style="color:grey;font-size:10px;font-style:italic;text-align:center">
  <a href="https://github.com/Skenvy/Collatz/blob/main/.meta/banners/README.md">Colourised Collatz Coral</a>; <a href="https://twitter.com/Gelada/status/846751901756653568">original by Edmund Harriss, 2016</a></a>
  </p></figcaption>
</figure>
<!-- For dark / light mode -->
<figure>
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/wiki/Skenvy/Collatz/.meta/banners/modifications/XYZ_dark.png">
    <img alt="Banner Image, Collatz Coral" src="https://raw.githubusercontent.com/wiki/Skenvy/Collatz/.meta/banners/modifications/XYZ_light.png" width=830 height=666 style="display:block;margin-left:auto;margin-right:auto;"/>
  </picture>
  <figcaption><p style="color:grey;font-size:10px;font-style:italic;text-align:center">
  <a href="https://github.com/Skenvy/Collatz/blob/main/.meta/banners/README.md">Colourised Collatz Coral</a>; <a href="https://twitter.com/Gelada/status/846751901756653568">original by Edmund Harriss, 2016</a>
  </p></figcaption>
</figure>
```
While the above would be ideal, it turns out that GitHub doesn't render a lot of this in markdown, only some, and it's a bit of effort to track down what they do or don't render, with [this 2012 blog post](https://github.blog/2012-11-27-html-pipeline-chainable-content-filters/) links to ["html-pipeline"](https://github.com/jch/html-pipeline) which has [this list of allowed elements and attributes](https://github.com/gjtorikian/html-pipeline/blob/main/lib/html_pipeline/sanitization_filter.rb). For example even though GitHub, or the gem they used to use, supports `figcaption` (and it "works" on the GH readme), they don't support the `style` attribute, and it's hard to find a way to center a `figure`. While we can't yet know without a lot of investigation or testing, it's also possible that any of the documentation generation tools wont render the html elements on the readme they include, or that package hosting sites that include the READMEs on the package's page will render them or not, is also a question. So for now, what we can work on that will render in vs code and GitHub;
```html
<!-- Things that don't work: Align a p containing a figure -->
<p align="center"><figure>...</figure></p>
<!-- Things that don't work: Align the img -->
<img align="center"/>
<!-- Things that DO work: Align a p containing an img -->
<p align="center"><img/></p>
<!-- Things that DO work: Align a p containing a picture with source -->
<p align="center"><picture><source/><img/></picture></p>

<!-- For single image mode -->
<p align="center"><img alt="Banner Image, Collatz Coral" src="https://raw.githubusercontent.com/wiki/Skenvy/Collatz/.meta/banners/modifications/XYZ.png" width=830 height=666/></p>
<sub><p align="center"><i>
  <a href="https://github.com/Skenvy/Collatz/blob/main/.meta/banners/README.md">Colourised Collatz Coral</a>; derived from this
  <a href="https://twitter.com/Gelada/status/846751901756653568">original by Edmund Harriss</a>
</i></p></sub>

<!-- For dark / light mode -->
<p align="center"><picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/wiki/Skenvy/Collatz/.meta/banners/modifications/XYZ_dark.png"/>
  <img alt="Banner Image, Collatz Coral" src="https://raw.githubusercontent.com/wiki/Skenvy/Collatz/.meta/banners/modifications/XYZ_light.png" width=830 height=666/>
</picture></p>
<sub><p align="center"><i>
  <a href="https://github.com/Skenvy/Collatz/blob/main/.meta/banners/README.md">Colourised Collatz Coral</a>; derived from this
  <a href="https://twitter.com/Gelada/status/846751901756653568">original by Edmund Harriss</a>
</i></p></sub>
```
## Palettes
### C#
\#TODO
### Gleam
[Gleam's Branding](https://gleam.run/branding/) "All pretty and pink 💖". They list "Gleam's favourite colours":
`#ffaff3` Faff Pink, `#fefefc` White, `#a6f0fc` Unnamed Blue, `#fffbe8` Aged Plastic Yellow, `#584355` Unexpected Aubergine, `#292d3e` Underwater Blue, `#2f2f2f` Charcoal, `#1e1e1e` Black, `#151515` Blacker.
### Go
[Brand and Trademark Usage Guidelines](https://go.dev/brand) and [Go's New Brand](https://go.dev/blog/go-brand). A [go themed slide deck](https://go.dev/s/presentation-theme). And a [brand book](https://go.dev/s/brandbook).
[Brand book v1.9.5](https://go.dev/assets/go-brand-book-v1.9.5.pdf) includes several colours; primary Gopher Blue `#00ADD8`, Light Blue `#5DC9E2`, Aqua `#00A29C`, and for a high contrast background black `#000000`. There are two "secondary colours" Fuchsia `#CE3262` and Yellow `#FDDD00`. There are several un-named "More colours"; a darker aqua `#00758D`, a grey `#555759`, a dark purple `#402B56`, and a light grey `#DBD9D6`.
### Java
Not sure where a more permanent source for these are, but googling "Java Logo Branding" yields a [Java Licensing Logo Guidelines](https://www.oracle.com/a/ocom/docs/java-licensing-logo-guidelines-1908204.pdf) from Oracle from 2016. It lists Oracle's colours for Java as "Java Blue" being `#007396` and "Java Orange" being `#ED8B00`.
[This older logo guidelines](https://www.oracle.com/us/assets/javaone-logo-guidelines-2211236.pdf) also lists two other varieties of orange and blue, with the "Java Blue (Older)" as `#5382A1`, "Java Blue (Uncoated)" as `#548A99`, "Java Orange (Older)" as `#FFA518`, and "Java Orange (Uncoated)" as `#FFA300`.
"[Duke](https://dev.java/duke/)", the java mascot, has a red eye, of varying shades, as can be seen in [Project Duke](https://wiki.openjdk.org/display/duke)'s [gallery](https://wiki.openjdk.org/display/duke/Gallery). Downloading two images of Duke and testing the red in them yields `#B30838` and `#FF0000`.
This rather deep-fried pdf on [Oracle brand guidlines](https://www.oracle.com/a/ocom/docs/oracle-brand-guidelines.pdf) lists Oracle's red as `#C74634`.
### JavaScript
We want our palette to be "JavaScript Yellow", "TypeScript Blue", "Node Green", and "NPM Red". The last three are all easy, they have official branding guidelines via the organisations that operate them. [TypeScript's branding guide](https://www.typescriptlang.org/branding/) shows their blue is `#3178C6`. [NodeJS's branding guide](https://nodejs.org/static/documents/foundation-visual-guidelines.pdf) lists the primary colour as "Pantone 7741 C", or `#339933`. NPM don't seem to have a readily searchable "branding guide", instead presenting a [_logo usage guide_](https://docs.npmjs.com/policies/logos-and-usage), but they do have an archived [logo repo](https://github.com/npm/logos) with logos using the `#C12127` colour.
"JavaScript Yellow" is the challenge, as [there is no "official" logo for JS](https://ux.stackexchange.com/questions/25558/what-is-the-official-javascript-logo-icon) but any icon from googling will be a similar shade of yellow, Wikipedia's (which claim to be the original unofficial logos from JSConf) [`F0DB4F`](https://commons.wikimedia.org/wiki/File:JavaScript-logo.png) and [`F0E14D`](https://commons.wikimedia.org/wiki/File:Unofficial_JavaScript_logo_2.svg), or `colorjs`'s [`F7DF1E`](https://github.com/colorjs/javascript-yellow), or per github's `linguist` [`F1E05A`](https://github.com/github-linguist/linguist/blob/559a6426942abcae16b6d6b328147476432bf6cb/lib/linguist/languages.yml#L3329).
### Julia
A description of the julia logo and colours can be found at [JuliaLang/julia-logo-graphics](https://github.com/JuliaLang/julia-logo-graphics), or [just the colours graphic](https://raw.githubusercontent.com/JuliaLang/julia-logo-graphics/master/images/julia-colors.svg) which lists "Julia" "Blue" `#4063D8`, "Green" `#389826`, "Purple" `#9558B2`, and "Red" `#CB3C33`, as well as "Royal Blue" `#4169E0`, "Forest Green" `#228B22`, "Medium Orchid" `#B452CD`, and "Brown" (but it's red?) `#CD3333`.
### LaTeX
The [LaTeX Logos Usage](https://www.latex-project.org/about/logos/) site includes the [LaTeX hummingbird logo](https://www.latex-project.org/about/logos/latex-project-logo_288x288.svg). We can download this svg and see the only two non-black / non-white colours are the green of the eye `#37c871` and the teal of the body `#008080`.
### Python
[The python logo](https://www.python.org/community/logos/). We can download one of the svg's and see the yellows, dark `#ffd43b` and light `#ffe873`, and the blues, light `#5a9fd4` and dark `#306998`. There are also 5 greys, from darkest to lightest `#7f7f7f`, `#b2b2b2`, `#b3b3b3`, `#b8b8b8`, `#f4f4f4` (almost white).
### R
A description of the [R logo](https://www.r-project.org/logo/). The svg file lists two greys, `(203, 206, 208)` and `(132, 131, 139)`, and two blues, `(39, 109, 195)` and `(22, 92, 170)`.
### Ruby
There are official examples of the [ruby logo](https://www.ruby-lang.org/en/about/logo/), but the only format that appears readable is an Adobe Illustrator vector `.ai`. The ruby discord helpfully provided a svg file. With a little bit of magic, `grep -Eio '#[a-fA-F0-9]{6}' Ruby_logo.svg | tr '[a-z]' '[A-Z]' | awk '!seen[$0]++' | sort`, we can get a mutually exclusive list of the colour codes present in it. There're **42** colours; `#666666`, `#79130D`, `#791C12`, `#7E0E08`, `#7E110B`, `#800E08`, `#820C01`, `#871101`, `#8B2114`, `#8C0C01`, `#910F08`, `#911209`, `#990000`, `#990C00`, `#9E0C00`, `#9E100A`, `#9E1209`, `#9E120B`, `#A30C00`, `#A31601`, `#A60003`, `#A80D00`, `#A80D0E`, `#B31000`, `#B3100C`, `#B31301`, `#BD0012`, `#BE1A0D`, `#BF0905`, `#BF190B`, `#C81F11`, `#C82410`, `#C82F1C`, `#DE3B20`, `#DE4024`, `#E42B1E`, `#E46342`, `#E4714E`, `#E57252`, `#E82609`, `#FB7655`, `#FFFFFF`.
### Rust
\#TODO
