# Banners
These banners are a series of modifications (by way of colouring in) of [this image](https://twitter.com/Gelada/status/846751901756653568), originally by Edmund Harriss.

The original is included as well as scripts to generate the modifications, with the scripts and modifications placed under the adjacent [CC-BY-SA-4.0](https://creativecommons.org/licenses/by-sa/4.0/) license [[+](https://choosealicense.com/licenses/cc-by-sa-4.0/)] [[+](https://spdx.org/licenses/CC-BY-SA-4.0.html)].

## Generate the modifications
The end of `./.meta/banners/modifications/img.py` shows both `recreate_blank_image()` and `recreate_contiguities_map_file()`, and how to use `colour_in_blank_image_with_palette(new_image_path, desired_ratios)`.

## Where are the modifications?
See them all [here](https://github.com/Skenvy/Collatz/blob/main/.meta/banners/EXAMPLES.md).

To prevent committing too many large image files _here_, the generated images will be committed in this repository's wiki, and the links to the raw files hosted in the wiki will be used in `img` tags. You can clone the wiki as you would any other repo, with the `:owner/:repo` being `:owner/:<repo>.wiki`; either as `git clone git@github.com:Skenvy/Collatz.wiki.git` / `git clone https://github.com/Skenvy/Collatz.wiki.git`.

However, when accessing the raw contents, to `src` the images hosted in the wiki, the url does not use the `:<repo>.wiki` name, nor does it take a branch. For files in the wiki at location `./a/b/c.xyz`, they would be accessed as `https://raw.githubusercontent.com/wiki/:owner/:repo/a/b/c.xyz` e.g. if we host the modifications as `./.meta/banners/modifications/*.png`, then we access them as `https://raw.githubusercontent.com/wiki/Skenvy/Collatz/.meta/banners/modifications/*.png`

We can then embed these images, stored in the wiki and accessed via `https://raw.githubusercontent.com/wiki/:owner/:repo/:filepath`, into the main repo's READMEs, with [this html embedding of a `<picture>`](https://github.com/stefanjudis/github-light-dark-image-example), combined with [`<figcaption>`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/figcaption), for example (with `<picture>` nested inside `<figure>`);
```html
<!-- For single image mode -->
<figure>
  <img alt="Banner Image, Collatz Coral" src="https://raw.githubusercontent.com/wiki/Skenvy/Collatz/.meta/banners/modifications/XYZ.png" width=830 height=666 style="display:block;margin-left:auto;margin-right:auto;">
  <figcaption><p style="color:grey;font-size:10px;font-style:italic;text-align:center">
  <a href="https://raw.githubusercontent.com/wiki/Skenvy/Collatz/.meta/banners/modifications/XYZ.png">Colourised Collatz Coral</a>; <a href="https://twitter.com/Gelada/status/846751901756653568">original by Edmund Harriss, 2016</a>, <a href="https://theexperimentpublishing.com/catalogs/fall-2016/visions-of-the-universe/">Visions of the Universe</a>, <a href="https://github.com/Skenvy/Collatz/blob/main/.meta/banners/README.md#generate-the-modifications">Modified</a>
  </p></figcaption>
</figure>
<!-- For dark / light mode -->
<figure>
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/wiki/Skenvy/Collatz/.meta/banners/modifications/XYZ_dark.png">
    <img alt="Banner Image, Collatz Coral" src="https://raw.githubusercontent.com/wiki/Skenvy/Collatz/.meta/banners/modifications/XYZ_light.png" width=830 height=666 style="display:block;margin-left:auto;margin-right:auto;">
  </picture>
  <figcaption><p style="color:grey;font-size:10px;font-style:italic;text-align:center">
  <a href="https://github.com/Skenvy/Collatz/blob/main/.meta/banners/EXAMPLES.md">Colourised Collatz Coral</a>; <a href="https://twitter.com/Gelada/status/846751901756653568">original by Edmund Harriss, 2016</a>, <a href="https://theexperimentpublishing.com/catalogs/fall-2016/visions-of-the-universe/">Visions of the Universe</a>, <a href="https://github.com/Skenvy/Collatz/blob/main/.meta/banners/README.md#generate-the-modifications">Modified</a>
  </p></figcaption>
</figure>
```
While the above would be ideal, it turns out that GitHub doesn't render a lot of this in markdown, only some, and it's a bit of effort to track down what they do or don't render, with [this 2012 blog post](https://github.blog/2012-11-27-html-pipeline-chainable-content-filters/) links to ["html-pipeline"](https://github.com/jch/html-pipeline) which has [this list of allowed elements and attributes](https://github.com/gjtorikian/html-pipeline/blob/main/lib/html_pipeline/sanitization_filter.rb). While we can't yet know without a lot of investigation or testing, it's also possible that any of the documentation generation tools wont render the html elements on the readme they include, or that package hosting sites that include the READMEs on the package's page will render them or not, is also a question. So for now, what we can work on that will render in vs code and GitHub;
```html
<!-- For single image mode -->
<figure>
  <img alt="Banner Image, Collatz Coral" src="https://raw.githubusercontent.com/wiki/Skenvy/Collatz/.meta/banners/modifications/XYZ.png" width=830 height=666 align="center">
  <figcaption><p style="color:grey;font-size:10px;font-style:italic;text-align:center">
  <a href="https://raw.githubusercontent.com/wiki/Skenvy/Collatz/.meta/banners/modifications/XYZ.png">Colourised Collatz Coral</a>; <a href="https://twitter.com/Gelada/status/846751901756653568">original by Edmund Harriss, 2016</a>, <a href="https://theexperimentpublishing.com/catalogs/fall-2016/visions-of-the-universe/">Visions of the Universe</a>, <a href="https://github.com/Skenvy/Collatz/blob/main/.meta/banners/README.md#generate-the-modifications">Modified</a>
  </p></figcaption>
</figure>
```
## Palettes
### C#
### Go
### Java
### JavaScript
We want our palette to be "JavaScript Yellow", "TypeScript Blue", "Node Green", and "NPM Red". The last three are all easy, they have official branding guidelines via the organisations that operate them. [TypeScript's branding guide](https://www.typescriptlang.org/branding/) shows their blue is `#3178C6`. [NodeJS's branding guide](https://nodejs.org/static/documents/foundation-visual-guidelines.pdf) lists the primary colour as "Pantone 7741 C", or `#339933`. NPM don't seem to have a readily searchable "branding guide", instead presenting a [_logo usage guide_](https://docs.npmjs.com/policies/logos-and-usage), but they do have an archived [logo repo](https://github.com/npm/logos) with logos using the `#C12127` colour.
"JavaScript Yellow" is the challenge, as [there is no "official" logo for JS](https://ux.stackexchange.com/questions/25558/what-is-the-official-javascript-logo-icon) but any icon from googling will be a similar shade of yellow, Wikipedia's (which claim to be the original unofficial logos from JSConf) [`F0DB4F`](https://commons.wikimedia.org/wiki/File:JavaScript-logo.png) and [`F0E14D`](https://commons.wikimedia.org/wiki/File:Unofficial_JavaScript_logo_2.svg), or `colorjs`'s [`F7DF1E`](https://github.com/colorjs/javascript-yellow), or per github's `linguist` [`F1E05A`](https://github.com/github-linguist/linguist/blob/559a6426942abcae16b6d6b328147476432bf6cb/lib/linguist/languages.yml#L3329).
### Julia
### LaTeX
### Python
### R
### Ruby
### Rust
