# Devlog
## What even _is_ "JavaScript"
"[JavaScript](https://www.ecma-international.org/publications-and-standards/standards/ecma-262/)" is a hard target to pin down precisely what would be the best way to learn it, without first learning the history of the language, as an evolution of ECMA Script; see [ECMAScript Language Specification](https://tc39.es/ecma262/) and [ECMAScript Internationalization API Specification](https://tc39.es/ecma402/) for the _most_ "source of truth" as it gets for JavaScript (even if a cumbersome point of reference to get up and running with a project quickly, they are important to be aware of).

---
### Engines
As from the start the JavaScript ecosystem was fragmented across various browsers, there is no single source of truth for how a "JavaScript Engine" enacts the ECMAScript language spec, so it's worth knowing of the major engines (with there being a distinction between the [JavaScript Engine](https://en.wikipedia.org/wiki/JavaScript_engine) and the [Browser Engine](https://en.wikipedia.org/wiki/Browser_engine)).
* [ChakraCore](https://github.com/chakra-core/ChakraCore) is an evolution of the Microsoft IE JS Engine, Chakra.
* [JavaScriptCore](https://github.com/WebKit/webkit/blob/main/Source/JavaScriptCore/API/JavaScriptCore.h) (a part of [WebKit](https://webkit.org/)) ([opensource.apple](https://opensource.apple.com/projects/webkit/)) (or on [github](https://github.com/WebKit/WebKit))
    * [Bun](https://bun.sh/) (or on [github](https://github.com/oven-sh/bun)), a new and still experimental runtime which "embeds" JavaScriptCore.
* [SpiderMonkey](https://spidermonkey.dev/) ([firefox-source-docs](https://firefox-source-docs.mozilla.org/js/index.html)) ([mozilla-central/source](https://searchfox.org/mozilla-central/source/js/src)) ([Gecko on github](https://github.com/mozilla/gecko-dev))
* [V8](https://github.com/v8/v8) ([googlesource](https://chromium.googlesource.com/v8/v8.git)) [v8.dev](https://v8.dev/)
    * [Node.JS](https://nodejs.org/), or on [github](https://github.com/nodejs/node), is the most widely used JS Engine, and is built on V8.
    * [Deno](https://deno.land/), or on [github](https://github.com/denoland/deno), is also built on V8, with many more features OotB.

### Runtimes
The three "server side runtimes" are Node (V8), Deno (V8), or the recent and experimental Bun (JavaScriptCore). Bun's package management is "npm compatible", so if our goal is to create a JavaScript package, we need to focus on Node and Deno.
* Node packages can be hosted on [npm](https://www.npmjs.com/) (see [Getting started](https://docs.npmjs.com/getting-started)), and are manually `npm publish`'d.
* Deno packages can be seen on [Deno Third Party Modules](https://deno.land/x) (see [Adding a module](https://deno.land/add_module)), and are cached from public GitHub repos.
* We also want to target the [github hosted npm registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-npm-registry) (also see [Publishing Node.js packages](https://docs.github.com/en/actions/publishing-packages/publishing-nodejs-packages)).

---
## Transpilers (TypeScript, etc.)
JavaScript (at least, as it was first created by Brendan Eich in 1995) has gone through a long history of corporate holdouts on standardising its adoption (leading to its early fragmented _sources_ of "truth") until 2009 when all the major implementations conformed, and agreed to adopt a shared standard, from [ECMAScript 5](https://262.ecma-international.org/5.1/) and onwards. The early fragmented nature of JavaScript has lead to subsequent releases of languages that are strict supersets of JavaScript, and transpile to JavaScript. By far the most common of these is Microsoft's [TypeScript](https://www.typescriptlang.org/), which adds static typing amongst other features. Others worth noting are;
* [PureScript](https://www.purescript.org/): Functional programming language.
* [AssemblyScript](https://www.assemblyscript.org/): [TypeScript](https://www.typescriptlang.org/) for [WebAssembly](https://webassembly.org/).
* [CoffeeScript](https://coffeescript.org/).

Although this implementation is supposed to be the "JavaScript" implementation, for reasons discussed much further down, it will more honestly be a "TypeScript" implementation that will be transpiled into two different types of JavaScript, targetting the split in module systems between NodeJS's original CommonJS module system, and the subsequent standardised ECMAScript Modules.

---
## _Two_ module systems
One of the top considerations for starting to learn javascript, with the end goal of its utility by node, is the dichotomy of the two "module formats" that node can be used with. Prior to "[ECMAScript modules](https://nodejs.org/docs/latest/api/esm.html)" being introduced around 2015 as the standard module format that browsers adopted, NodeJS was built around its own module system "[CommonJS modules](https://nodejs.org/docs/latest/api/modules.html)" which was the only module system supported by Node until version 12, where ECMAScript modules were slowly introduced until being fully supported by version 13/14 ([from this reflectoring blog](https://reflectoring.io/nodejs-modules-imports/) and [this logrocket blog](https://blog.logrocket.com/commonjs-vs-es-modules-node-js/)). For a deep dive on the loading order of ECMAScript modules, see [this mozilla "hacks" blogs](https://hacks.mozilla.org/2018/03/es-modules-a-cartoon-deep-dive/).

---
## Existing Collatz Packages
At the time of writing this, `npm` already has a [`collatz` package](https://www.npmjs.com/package/collatz) (from [this repo](https://github.com/partkyle/collatz)), and `deno.land/x` has [collatz_wasm](https://deno.land/x/collatz_wasm@0.0.1) (which is [also on npm](https://www.npmjs.com/package/collatz-wasm)) (from [this repo](https://github.com/hexagon6/collatz-wasm)). For github hosted packages, we'll look at [this search](https://github.com/search?q=collatz&type=registrypackages). Oddly enough, at the time of writing this, I was getting ready to say there is no `npm` package with the name `collatz` in the github `npm` registry, as it was not appearing without being logged in, but when I searched again from a browser I was logged in with, [this package](https://github.com/pavan142/collatz/pkgs/npm/collatz) appeared.
### Mozilla's Guide
A good resource for starting to learn "JavaScript" would be [mozilla's developer docs on JavaScript](https://developer.mozilla.org/en-US/docs/Web/JavaScript) ([or guide](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide)).
### GitHub's npm Registry guide
Two links recommended by the GitHub "[Working with the npm registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-npm-registry)" page include [Creating a package.json file](https://docs.npmjs.com/creating-a-package-json-file) and [Creating Node.js modules](https://docs.npmjs.com/creating-node-js-modules).

---
## NPM
### [Signing up](https://www.npmjs.com/signup)
We'll need to start with [signing up to npm](https://www.npmjs.com/signup). I made [my profile](https://www.npmjs.com/~skenvy). Something that immediately stands out is that the one time password email includes links for [Configuring two-factor authentication](https://docs.npmjs.com/configuring-two-factor-authentication) and [Creating and viewing access tokens](https://docs.npmjs.com/creating-and-viewing-access-tokens), as `2FA` is required for logging in; although an "Automation" token can be made for publishing packages without a 2FA token, it can only be made from the website, not from the CLI. So we'll do that now. There's also an option to "Linked Accounts & Recovery Option" with a GitHub account, which seems worthwhile trying, if it didn't request the egregious permission of "Act on your behalf". Why does it want that permission?
### [Package **scope**](https://docs.npmjs.com/about-scopes)
An important concept for npm is [scope](https://docs.npmjs.com/about-scopes), both [public](https://docs.npmjs.com/about-public-packages) and [private](https://docs.npmjs.com/about-private-packages). I hadn't realised before that npm included this feature. But because it is included we can focus on [creating a public **scoped** package](https://docs.npmjs.com/creating-and-publishing-scoped-public-packages), because there already exists an **unscoped** [collatz](https://www.npmjs.com/package/collatz) package on npm. Starting off, our `node --version` is `v17.6.0`, and our `npm -v` is `8.5.5`. We can create the initial [`package.json` file](https://docs.npmjs.com/cli/v8/configuring-npm/package-json) with default values (`--yes`) within a scope (`--scope=@scope-name`) by running `npm init --scope=@skenvy --yes`. Because it'll be initialised with a scope, we'll have to publish it with `npm publish --access=public`, as scoped packages default to private.
### [Other `package.json` settings](https://docs.npmjs.com/cli/v8/configuring-npm/package-json)
The [package license](https://docs.npmjs.com/cli/v8/configuring-npm/package-json#license) should be an [OSI approved](https://opensource.org/licenses/alphabetical) identifier from the [SPDX License List](https://spdx.org/licenses/). Although I'm trying to add as many of the optional data fields in the package json as possible, rather than use [`"files": ["*"],`](https://docs.npmjs.com/cli/v8/configuring-npm/package-json#files) we'll use an [.npmignore](https://docs.npmjs.com/cli/v8/using-npm/developers#testing-whether-your-npmignore-or-files-config-works) file, which can be tested with `npm pack` to generate the tarball locally. Although, to "use" the `.npmignore`, we don't actually need to add one, unless its contents would differ from the `.gitignore` that's already present, as outlined via "If there is a `.gitignore` file, and `.npmignore` is missing, `.gitignore`'s contents will be used instead." As a moment of learning, this being the first time I'm setting up a node package, I find it noteworthy that there is a ["browser" option](https://docs.npmjs.com/cli/v8/configuring-npm/package-json#browser), which is mutually exclusive with ["main"](https://docs.npmjs.com/cli/v8/configuring-npm/package-json#main) as I'd assumed node modules weren't supposed to target the client side! Other note worthy options are `bin` and `man` for packaging scripts that should be symlinked to a bin folder, and for requesting the man docs. Following this we have [a whole guide dedicated to the "scripts" dictionary entry](https://docs.npmjs.com/cli/v8/using-npm/scripts). Following the scripts and config, are several different ways to define dependencies (including `"overrides"` to lock sub-dependencies), there are the `"engines"`, `"os"`, and `"cpu"` options (and the `"private"` and `"publishConfig"` to prevent accidentally pushing/publishing).
### ["Package" vs "Module"](https://docs.npmjs.com/about-packages-and-modules)
Another important concept is the [difference between a "package" and a "module"](https://docs.npmjs.com/about-packages-and-modules). Even though this wont impact how we go about creating a package, it's important to understand why _"almost"_ all packages can be modules but not all modules are packages. Although the page linked to has additional caveat that describe additional ways to procure packages, the central defining factor of a package is "A package is a file or directory that is described by a `package.json` file." We saw above that there are two primary types of packages; those that define a `"main"`, and those that define a `"browser"` option. The "_"almost"_ all packages can be modules" is discluding those that define a `"browser"` option. As for modules; "A module is any file or directory in the `node_modules` directory that can be loaded by the Node.js `require()` function." Things that satisfy this are packages that define a `"main"`, and other javascript files that aren't necessarily stored in packages.

---
## Planning setting up the project
### A **minimum _working_ package**
This is the point at which we'd follow [Creating Node.js modules](https://docs.npmjs.com/creating-node-js-modules). Although it is a nice anchor to other docs that are adjacent to it, it doesn't do much for recommending a good project setup besides saying "have a `package.json` file with a `"name"` and `"version"`, and to include a `console.log` line in "the file". Whilst at this point I'm aware that "the file" is the `"main"` file, and even though two pages that precede it ([About packages and modules](https://docs.npmjs.com/about-packages-and-modules) and [Creating a package.json file](https://docs.npmjs.com/creating-a-package-json-file)) would include steps that would inform the reader of that, it's surprising that the "example" Node package creation at [Creating Node.js modules](https://docs.npmjs.com/creating-node-js-modules) is not a shade more verbose about that. I can definitely see someone jumping straight to this page and potentially being confused. There really should be a "here's all the things you need for a minimum working package". Even if **technically** all you need for a **minimum _working_ package** is a `"name"` and `"version"` in a `package.json` file, it's a fair assumption that there would be a single page guide for slapping together a `package.json` file **AND** the `index.js` file (or whatever else `"main"` is).
### Testing, or the lack of it.
I'd also have figured there'd be a more robust testing example besides what it currently says, which is to **publish the example console log line package to npm**, then swap to another directory and install it, then add a `test.js` file that requires the module and runs it. Even if there isn't a recommended test suite module, that honestly sounds like so large an anti-pattern I'm not convinced it wasn't an off-season April Fools joke. Not solely the use of publishing to test, as there's certainly room to publish an early version to confirm the process, but the part that seems grossly objectionable is that reading only that and not reading further could leave the impression that the order of the process for testing requires a package to be published, before it can then be installed and required and tested. Would the remedy if it then didn't pass that testing phase to yank that version..?
### Demo blogs | Guides
There's a few guides that might be more robut for setting up a good node package. For instance, theres [this snyk blog](https://snyk.io/blog/best-practices-create-modern-npm-package/) ([which addresses this example repo](https://github.com/snyk-labs/modern-npm-package)), a [freecodecamp blog](https://www.freecodecamp.org/news/how-to-make-a-beautiful-tiny-npm-package-and-publish-it-2881d4307f78/) (which is entertaining if not at least for the demonstration of publishing the absolute minimum of a package) (and also links to an interesting aggregating site [packagephobia](https://packagephobia.com/result?p=%40bamblehorse%2Ftiny)), and possibly look at [ESLint](https://eslint.org/docs/latest/user-guide/getting-started) (which may include looking at [Airbnb's .eslintrc](https://www.npmjs.com/package/eslint-config-airbnb), because the [Airbnb JavaScript Style Guide](https://airbnb.io/javascript/) is supposedly noteworthy).

---
## Setting up the CI
### The `setup-node` action
Before jumping into [the snyk blog](https://snyk.io/blog/best-practices-create-modern-npm-package/), lets look more at targetting the [github hosted npm registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-npm-registry) (and [Publishing Node.js packages](https://docs.github.com/en/actions/publishing-packages/publishing-nodejs-packages)). While trying to set up the workflows, I initially added the optional caching in the `setup-node` action but ended up getting an error of "Error: Cache folder path is retrieved for npm but doesn't exist on disk: /home/runner/.npm" in the post-step. Issues [#317](https://github.com/actions/setup-node/issues/317) and [#479](https://github.com/actions/setup-node/issues/479) appear to demonstrate that the action is generally hostile to caching.

---
## Setting up: Support _both_ module systems, by transpiling TypeScript
Per the "two module systems" that can exist in node, to yield a resulting package that can support both "CommonJS modules" (`*.cjs` files) _AND_ "ECMAScript modules" (`*.mjs` files) (with `*.js` files being treated as the module specified in the `package.json`, with CommonJS being default, and ECMAScript being if `"type": "module"` is included). It's worth noting that [V8, the engine Node runs on, recommends ECMAScript modules](https://v8.dev/features/modules#mjs). The approach recommended by [the snyk blog](https://snyk.io/blog/best-practices-create-modern-npm-package/) is to write a TypeScript module, which is then transpiled according to `tsconfig` files and includes a `prepack` script which `tsc` compiles the TypeScript into _BOTH_ `*.cjs` _AND_ `*.mjs` formats.

_**This means that instead of writing JavaScript for this "JavaScript implementation", we'll be writing TypeScript instead.**_

The first part of setting up a TypeScript build environment for multiple build targets, is taking advantage of the extensible [`tsconfig.json`](https://www.typescriptlang.org/docs/handbook/tsconfig-json.html) ([reference](https://www.typescriptlang.org/tsconfig)) [extends](https://www.typescriptlang.org/tsconfig#extends) option, to have a shared config base and diverging config for targetting CommonJS builds and ECMAScript builds. We'll also be replacing the `"main"` field in our `package.json` with an `"exports"` [field](https://nodejs.org/api/packages.html#packages_exports). Although `"exports"` can be an "alternative" to `"main"`, we'll set the `"main"` (and a new `"types"` field) to target the CommonJS build by default. We'll then copy the `"scripts"` suggested by snyk for now, as they seem reasonable. One thing it appears the snyk blog glossed over is actually running `npm install typescript --save-dev` to install TypeScript as a `"devDependencies"`, so we'll do that now. If we got to this stage we should be able to now `npm run build` (or our preferred `make build` which runs `npm pack` which runs `npm run prepack` which runs `npm run build`).

---
## Hiatus
JavaScript still feels alien to set up compared to the other languages, that it's been a few months hiatus since I started on this.
## Add Mocha
Coming back to it to continue on it, the next step in the snyk blog we were following is to add a testing framework. I have previously made changes to `mocha` tests without a greater context for it, but `mocha` as a test runner, `chai` as an assertions library, and `ts-node` to facilitate their operation on TypeScript files rather than plain JavaScript. To acquire these three we'll run `npm i -D mocha @types/mocha chai @types/chai ts-node` to install as developer dependencies. We've also got to include a `~/.mocharc.json` to instruct `mocha` how to run, and a `~/tests/index.spec.ts` to provide the tests to run.
## Emojis
As an intermediate and silly note here, as the scope of this JavaScript implementation, that was originally planned to fit the repository wide expectation of having 3 emojis to symbolise it used 🟨🟩🟥 for the yellow square of JS, the green of Node, and the red square of `npm`, has increases in scope to now rely on TypeScript to transpile to JavaScript, and TypeScript also uses a square logo that is a primary colour, this JavaScript implementation will buck the trend of other implementations and use 4 emojis, 🟨🟦🟩🟥, for JS, TS, Node, and npm.

---
## Continuing the setup
The next step in the snyk blog in CI testing, utilising the `mocha` setup that had been added in the previous step. We'd however _already_ set up exhaustive CI that was using a test step that was echoing a string. Now that the test step actually uses `mocha`, the CI now also does that already. There is a following section on package testing, but as in all other instances we rely on unit testing, we'll forego package testing for now. Following _that_ is a section on using the a snyk custom action for security scanning. It feels somehow rude to use their thoroughly well done guide on how to set up a project and _not_ use their tool at the end of it, but it requires signing up and acquiring an API key, and we're already using GitHub's integrated CodeQL (although snyk's tool might possibly work on a wider variety of languages). Then there is a section on why it's better to automatically bump versions, and explaining semantic versioning. We're specifically intentionally handling the versioning manually. The guide is presenting this in a way that any change merged to the main branch, that runs a publishing CICD workflow, should automate its version and publishing, but we use the manual change of the version, or lack thereof, to manually gate the publishing, if a change does or does not live up to requiring a new package release.

With that all out of the way, we've gotten all the way through implementing what's necessary for us out of the snyk blog, [Best practices for creating a modern npm package](https://snyk.io/blog/best-practices-create-modern-npm-package/). As this marks the end of setting up the core configuration for testing, transpiling, and publishing, we'll release this as a new minor version before we continue on to actually implementing the code.

---
## Starting the implementation
### Mocha isn't transpiling to target ES2020 on Node v12.22.12
Having started the implementation, an error has popped up, which appears to be different between my local and what is running in CI, because the CI is using `node -v` of `v12.22.12` and I'm using `v17.6.0` (`npm -v` of `8.5.5`), so use [`n`](https://www.npmjs.com/package/n) to swap to an older version. A quick `npm list` yields the warning
> npm WARN read-shrinkwrap This version of npm is compatible with lockfileVersion@1, but package-lock.json was generated for lockfileVersion@2. I'll try to do my best with it!

So we've got to regenerate the `package-lock.json` with a new `npm install`, followed by an `npm ci` to see what it spits out as a warning / error. The `npm ci` command is not erroring, but the `npm list` command is now unhappy for a different reason;
> ├── UNMET PEER DEPENDENCY @types/node@*

> npm ERR! peer dep missing: @types/node@*, required by ts-node@10.9.1

There are some articles that mention npm at this version does not automatically install **peer** dependencies, so we'll need to `npm i -D @types/node`. This gets rid of the error message of the missing peer dependency on the `npm list`, but does not alleviate the issue of `mocha` complaining about.
> TSError: ⨯ Unable to compile TypeScript:

With an example error such as
> tests/index.spec.ts:30:22 - error TS2737: BigInt literals are not available when targeting lower than ES2020.

### I don't know how TS targets are limited by Node versions
Before we dig into how `mocha` is choosing which `tsconfig.*.json` file to use to know what [target](https://www.typescriptlang.org/tsconfig#target) to transpile for, in such a way as to believe that it isn't being told to `"target": "ES2020"` (when both `tsconfig.cjs.json` and `tsconfig.esm.json` _**are**_ set to `"target": "ES2020"`), it's worth addressing that we originally chose version 12 as the base dependency version as it was the version that introduced ECMAScript support. Yet, there is a [Recommended Node TSConfig settings](https://github.com/microsoft/TypeScript/wiki/Node-Target-Mapping) page which recommends node version 14 as the first version with which to use `"target": "ES2020"`. At this stage, still have relatively no idea what I'm doing in a JavaScript, let alone a TypeScript, environment, I find it bizarre that an often spruiked feature of TypeScript is its ability to simplify JavaScript development through its supposed ability to transpile any TypeScript you write into any JavaScript target, yet through this process so far, in an attempt to use JavaScript's `BigInt`, (see [Mozilla](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/BigInt), [V8](https://v8.dev/features/bigint), and [V8 blog](https://v8.dev/blog/bigint)) we've had to upgrade from `"target": "ES6"` (circa 2015, [currently the recommended year to target up to](https://github.com/tsconfig/bases/blob/7db25a41bc5a9c0f66d91f6f3aa28438afcb2f18/bases/recommended.json#L3)) to `"target": "ES2020"`, but attempting to figure out now why `mocha` is unhappy, I've stumbled across not only [a list of what is apparently a reasonable target per Node version](https://github.com/microsoft/TypeScript/wiki/Node-Target-Mapping), but also [a whole collection of different tsconfig's to use for different use cases](https://github.com/tsconfig/bases/). Reading into these at a surface level, I feel like the use of TypeScript has not decreased the amount of contextual awareness required to understand what it being developed, but a lot more. Part of that is likely the learning curve, but at this stage it feels incredibly counter intuitive.

For now, we'll take the recommendation of saying the minimum supported node version is 14, not 12. This appears to have solved the issue with `mocha` not being able to automatically know to transpile to a target it thought would accept bigints.
### Hard limit the engine this installs on.
But it leaves me with the question of, knowing what features you want in your JavaScript, let alone what features you want in your TypeScript, how do you use that to determine what Node version (let alone what TypeScript target..) you'll require. Which sounds like an unreasonable thing for someone to be concerned about, i.e. more generally, knowing what you want to use, how do you determine what version of _the thing_ you'll need, would be something you'd expect someone trying to build with something to be able to determine. I am simply struck at what feels like the use of TypeScript being antithetical to requiring less of me, when I'm not even sure why I've picked the configuration I have other than some TypeScript repository that is community maintained vaguely suggests it as the most appropriate to use, without any rhyme or reason as to how it determined that appropriateness -- and to understand that and feel empowered to properly weild TypeScript, I'd have to understand its internal machincations. To close off this choice of using Node version 14, which comes with npm version 6, we'll also add an ["engines"](https://docs.npmjs.com/cli/v6/configuring-npm/package-json?v=true#engines) setting in our package file, and add an [`.npmrc` file](https://docs.npmjs.com/cli/v6/configuring-npm/npmrc?v=true) so that we can set the [`engine-strict` config](https://docs.npmjs.com/cli/v6/using-npm/config#engine-strict) there.

---
## Add linting
### Choose a linter
At this stage of having the first "Function" present in the TypeScript, we should consider investing in a linter. Using a combination of the code snippets from the java, julia, and python implementations and gluing them together here has probably led already to some gross stylisation that would require eye-bleach after looking at it. Previously it was mentioned;
> and possibly look at [ESLint](https://eslint.org/docs/latest/user-guide/getting-started) (which may include looking at [Airbnb's .eslintrc](https://www.npmjs.com/package/eslint-config-airbnb), because the [Airbnb JavaScript Style Guide](https://airbnb.io/javascript/) is supposedly noteworthy).

Along with this, there is also a [TSLint](https://palantir.github.io/tslint/) ([archived repo](https://github.com/palantir/tslint)), although per their [roadmap](https://github.com/palantir/tslint/issues/4534) and [blog](https://blog.palantir.com/tslint-in-2019-1a144c2317a9), in an effort to make TypeScript and JavaScript development more cohesive, they now recommend [typescript-eslint](https://typescript-eslint.io/) which _is_ ESLint running on TypeScript code, such that ESLint is the "standard" linter. So I guess that's likely the best choice.
### Install [typescript-eslint](https://typescript-eslint.io/)
To start with we'll look at [typescript-eslint's "Getting Started"](https://typescript-eslint.io/getting-started), which begins with the developer dependency installation `npm install --save-dev @typescript-eslint/parser @typescript-eslint/eslint-plugin eslint typescript`; which immediately pops out an error of;
> npm ERR! notsup Required: {"node":"^12.22.0 || ^14.17.0 || >=16.0.0"}

So I guess we've gotta take the intersection of that and the current requirement of being `>=14.0.0` to limit to engines in `{"node":"^14.17.0 || >=16.0.0"}`. Aftering a quick `n 4.17.0` the installation works fine. Before seeing if we want to use [Airbnb's .eslintrc](https://www.npmjs.com/package/eslint-config-airbnb), we'll try out the recommended config from [typescript-eslint's "Getting Started"](https://typescript-eslint.io/getting-started).
### [ESLint Environments](https://eslint.org/docs/latest/use/configure/language-options#specifying-environments)
First running the `npx eslint .` that is suggested yields an error
> /mnt/c/Workspaces/GitHub_Skenvy/Collatz/javascript/.eslintrc.js  
1:1  error  'module' is not defined  no-undef

Google reveals that this issue likely comes from not having told ESLint via its rc that we want to run this in a node environement, and must add `env: {"node": true}`. This does get rid of that warning. I imagine for the popularity of ESLint as the recommended tool, it's surprising [the stackoverflow question](https://stackoverflow.com/a/52094784) to this doesn't have more traffic.
### `.eslintignore`
Secondary to the `.eslintrc.*` file, we can also add a `.eslintignore` to prevent files we don't want to lint from being included. This would include the `./node_modules` folder as well as the folder our transpiled JavaScript result goes into.
### `npm run lint`
I was temporarily confused as I also tried to run `eslint .` without `npx` as some sites offer in snippets, and it was not working. I was relying on the assumption that because my devDependency of TypeScript allows me to use `tsc` in the `scripts` that can be used with `npm run ...` I should be able to also use ESLint in a similar manner, but was only trying to do so in my terminal rather than adding it to my `scripts`. It took a while of googling around to stumble on [the simple answer](https://docs.npmjs.com/cli/v8/commands/npm-run-script?v=true) that `./node_modules/.bin`, which contains these invocable scripts, is added to the `PATH` when invoking `npm run ...`. Sure enough, `tsc` which has been working for while in my `npm run ...`'s also does not work as "just" `tsc` outside of `npm run ...`. So we can easily add an `npm run ...` that will use the version installed by the package lock. So we can now simply use an `npm run lint`.
### Add [Airbnb's .eslintrc](https://www.npmjs.com/package/eslint-config-airbnb)
As we've followed the instructions up until here, we'll swap to the recommendations of [this blog](https://khalilstemmler.com/blogs/typescript/eslint-for-typescript/), as it uses json for the `.eslintrc`, and provides an explanation for adding "rules" to it. We can also use this to try and add [Airbnb's .eslintrc](https://www.npmjs.com/package/eslint-config-airbnb).

We'll use `npx install-peerdeps --dev eslint-config-airbnb`, which generates the "peerDeps" installation command `npm install eslint-config-airbnb@19.0.4 eslint@^8.2.0 eslint-plugin-import@^2.25.3 eslint-plugin-jsx-a11y@^6.5.1 eslint-plugin-react@^7.28.0 eslint-plugin-react-hooks@^4.3.0 --save-dev`. We also need to add `"airbnb"` to the `"extends"` of the `.eslintrc`.
### Refine linting with rules
Well, now we've got some linting set up, and using an extensive collection of recommended rules, it's time to run it and iteratively see what I've done differently from what the [Airbnb's .eslintrc](https://www.npmjs.com/package/eslint-config-airbnb) recommends. These differences can be added as modifications to the sets of rules that are extended in the `./.eslintrc` through a `"rules"` map. One that I will definitely allow is [`object-curly-newline`](https://eslint.org/docs/latest/rules/object-curly-newline). Although [`no-underscore-dangle`](https://eslint.org/docs/latest/rules/no-underscore-dangle) is something that I've avoided changing where possible, I have removed the "private" underscores from some previous implementations.

One that is was a slight problem was a bunch of lines in my `./tests/index.spec.ts` popping up with;
>   23:3   error  'it' is not defined                                    no-undef
### [ESLint Environments](https://eslint.org/docs/latest/use/configure/language-options#specifying-environments) 2: Electric Boogaloo
The [`no-undef`](https://eslint.org/docs/latest/rules/no-undef) error appears to be complaining that the `it` inside the function blocks of a `describe` (as well as the `describe` in other linter errors) are not declared and or defined. An answer on [this stackoverflow question](https://stackoverflow.com/a/38667441) provides the context and a link to some ESLint docs on [Specifying Environments](https://eslint.org/docs/latest/use/configure/language-options#specifying-environments) with the context being that there are _many_ environments, and;
> An environment provides predefined global variables.

Which means we can add a `/* eslint-env mocha */` comment at the top of our `./tests/index.spec.ts` and get rid of these errors.
### Import resolution errors
I'm still routinely getting the errors;
> 6:26  error  Unable to resolve path to module '../src/index'  import/no-unresolved  
6:26  error  Missing file extension for "../src/index"        import/extensions  
7:27  error  Unable to resolve path to module '../src/index'  import/no-unresolved  
7:27  error  Missing file extension for "../src/index"        import/extensions

The `import/no-unresolved` error can be avoided by adding this to the `.eslintrc`.
```json
"settings": {
  "import/resolver": {
    "node": {
      "extensions": [".js", ".jsx", ".ts", ".tsx"]
    }
  }
}
```
Followed by setting `import/extensions` to a warning.

---
## Setting up documentation
Now that there is some relevant code in here, as TS being consistently transpiled to JS, tested with mocha and linted with eslint, it's time we look at adding the last main "feature" of all (or _most_) of the implementations; **documentation comments** and tools that compile generated documentation as webpages that we can add to our GitHub pages -- similar to our [GoDoc](https://skenvy.github.io/Collatz/go/), [JavaDoc](https://skenvy.github.io/Collatz/java/apidocs/io/github/skenvy/package-summary.html), [Documenter.jl](https://skenvy.github.io/Collatz/julia/), [Roxygen+Pkgdown](https://skenvy.github.io/Collatz/R/), and [RDoc](https://skenvy.github.io/Collatz/ruby/) sites.
### How do you even document JS or TS code??
A long standing project to standardise JS documentation comments is [JSDoc](https://github.com/jsdoc/jsdoc). TypeScript has a similarly named [TSDoc](https://github.com/microsoft/tsdoc). Whilst it would be interesting to serve documentation generated for both the transpiled JS code as well as the source TS code, as we are directly controllowing the source (although from what I've seen the comments are 1-to-1 copied to the transpiled output) our _target_ will be to write TSDoc styled comments. Although without testing either out, purely from reading their descriptions, JSDoc actually generates docs pages, but TSDoc simply specifies a recommended format to be consumed by other tools that will use the TSDoc format to do the docs generation. So while JSDoc just "does the whole thing", if we want to pick TSDoc as a "standard" to document the source, being TS, we'll still need to pick one of the tools that will read the TSDoc comments to generate the docs pages. Besides both of these, there also appears to be an [ESDoc](https://github.com/esdoc/esdoc), which claims to be a JS documenter.
### Compile TSDoc comments into _something_
The [TSDoc site](https://tsdoc.org/) links to several "popular tools" that use TSDoc comments, one of which is eslint, and another vs code, but the first tool mentioned is [TypeDoc](https://typedoc.org/) ([repo](https://github.com/TypeStrong/typedoc)), a;
> Documentation generator for TypeScript projects.

_So our primary goal is to write TSDoc styled comments, and use TypeDoc to compile them into the generated documentation._

Further down the page, rather visually hidden, is mention of, and not a link to, an `eslint-plugin-tsdoc` ([repo](https://github.com/bafolts/eslint-plugin-tsdoc), though), an eslint plugin to, I assume, lint the TSDoc comments. That repository has not been touched in a few years, but it appears from visitng the [npm page for eslint-plugin-tsdoc](https://www.npmjs.com/package/eslint-plugin-tsdoc), which links back to the [Microsoft TSDoc repo](https://github.com/microsoft/tsdoc), that it is indeed a _monorepo_, which contains as a project within it, the most recent state of the plugin [`eslint-plugin-tsdoc`](https://github.com/microsoft/tsdoc/tree/main/eslint-plugin). So I guess we'll be able to use that!
### Setup TSDoc and TypeDoc
The two new packages we want to add can be included with `npm install --save-dev typedoc eslint-plugin-tsdoc`

After adding both of these and following the [current ReadMe for `eslint-plugin-tsdoc`](https://github.com/microsoft/tsdoc/blob/c758984fb4e088e69d7ea34ccab07e9def01448d/eslint-plugin/README.md) (adding the plugin and rule), it's not immediately obvious why it isn't flashing up warnings about the documentation styling that currently exists. If we look at [what it appears to currently be doing](https://github.com/microsoft/tsdoc/blob/dc670ecf835b1305d246c69609f2a67a16370b61/eslint-plugin/src/index.ts#L84-L122), the first thing it's doing is not linting any comment that is _not_ a block comment; none of my comments are block comments. So to get it to comment on anything we need to add some block comments `/*<comment>*/` but we need to style it as `/**<comment>*/`.

With comments now in place, we'll just need to keep using [these sorts of references](https://tsdoc.org/pages/tags/param/).
### JSDoc?
I tried testing jsdoc, `npm install --save-dev jsdoc`, however when I tested it on the ECMAScript version, `npx jsdoc lib/esm/index.mjs -d docs/esm`, I got;
> There are no input files to process.

And when I tested it on the CommonJS version, `npx jsdoc lib/cjs/index.js -d docs/cjs`, it returns;
> Do not know how to serialize a BigInt

So JSDoc is already too much of an uphill battle to work with.
### Evaluate the TypeDoc output
We can install a simple server with `npm install --save-dev http-server`, run it with `npx http-server`, and navigate to http://127.0.0.1:8080/docs/tsdoc.
### Empty Orphan
We're now ready to add once again create an empty orphan branch;
1. `git checkout --orphan gh-pages-javascript`
1. `rm .git/index ; git clean -fdx`
1. `git commit -m "Initial empty orphan" --allow-empty`
1. `git push --set-upstream origin gh-pages-javascript`

### "Destructured Parameters" + "Object Literal", or interfaces?
Apparently, specifying an input in the ["destructured" format](https://typedoc.org/tags/param/#destructured-parameters) bound to an interface type, like `({ n, P = 2n, a = 3n, b = 1n }: CollatzParameters)` (where `CollatzParameters` is `{n:bigint, P?:bigint, a?:bigint, b?:bigint}`), will lead to the name of the input being inferred by TypeDoc as `__namedParameters`. Any set of `@param` comments on a function that don't address this specific case will be ignored, but not necessarily in the order mentioned by the TypeDoc example, or at least, not in the order I would assume, with the acknowledgement that I suffice the user acceptance testing role of "as a stupid user" per the KISS principle. So it's more probable the TypeDoc examples are fine, I'm just reading something extra that isn't there. So let's experiment a bit.

For example, in [this case](https://github.com/Skenvy/Collatz/blob/559c27e2595ea4ad980582ae2a037f79091f4913/javascript/src/index.ts#L124-L137) where there are four `@param`'s, the output TypeDoc yielded was [this](https://github.com/Skenvy/Collatz/blob/gh-pages/javascript/functions/Function.html#L27-L31), which simply lists `__namedParameters` as the name of the only input. Which is where I have now just seen and realised I got my `@param`'s wrong, for accurately displaying the inputs in TypeDoc's output. So now, how can this be fixed?

Well, testing this locally, there appear to be two ways to correctly yield a different name rather than `__namedParameters`. Either a single `@param`, for the one object input, _or_, a single `@param` that renames the top level object, along with the following lines obeying the [@param Object Literal](https://typedoc.org/tags/param/#object-literals) style, i.e. `* @param AnyNameHere - various options` followed by `* @param AnyNameHere.abc - property abc` will correctly yield renaming the `__namedParameters` to `AnyNameHere`, but I cannot get any way of rewriting the params underneath to yield their comments in the resulting site. Perhaps this is because it's not parsing the type of the object literal far enough to see the names of the parameters of the interface, and using the name of the interface instead of the "Object Literal" is a foot-gun? It would appear this is the case, because replacing the name of the interface with the "object literal" version of the interface, `{n:bigint, P?:bigint, a?:bigint, b?:bigint}`, allowed TypeDoc to yield the full documentation, as written on the function.

I'm not sure if there's a more preferred style one way or the other whether to use named interfaces or not, it would certainly uphold the notion of minimising the amount of repeated code, or at least repeated comments. But using a named interface rather than an "anonymous interface" ("object literal" as the type parameter) means the doc comments won't appear for each function. I think given these, I'd rather get rid of the named interface and swap over to object literals for each function's singular input's type parameter.

It turns out though, that doing this leads to two issues. Although the docs appear nice in the generated TypeDoc site, they don't appear when hovering over the symbol in the editor, and every `@param` is creating an ESLint warning from the `tsdoc/syntax` rules;
> tsdoc-param-tag-with-invalid-name: The @param block should be followed by a valid parameter name: The identifier cannot non-word characters

So it looks like, the trade off of not having a nice TypeDoc site is a better in-editor experience, and the "TSDoc" way of doing it.

## Coverage
One thing I haven't added yet is code coverage to report on how tested the code is. It'd be nice to have. Jest has coverage itself, but we're already set up with mocha and I have no idea if they are interoperable at all. Googling "mocha coverage" lands us on [this SO](https://stackoverflow.com/questions/16633246/code-coverage-with-mocha), which recommends [instanbul](https://istanbul.js.org/), but via [`npm install --save-dev nyc`](https://github.com/istanbuljs/nyc).
