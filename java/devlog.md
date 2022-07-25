# Devlog
Java is obviously a pretty mature language, which unfortunately means there's a bit of an oversaturation of content. These links aren't in the order that they are inherently relevant to deciding how to choose which jdk version or release. They try to be a mix of "how to java" and "how to maven", to coalesce the best way of actually publishing a java project onto maven central. For such a ubiquitous language that's impossible to not find guides on how to _use_ it, because the language, the primary tool for deployment, and the hosting of packages, are all managed by distinct entities, it is surprisingly unintuitive and anti-cohesive an experienve compared to something like python.
* [OpenJDK](https://openjdk.java.net/) | [mvn: upload to central repository](https://maven.apache.org/repository/guide-central-repository-upload.html) |
* [Sonatype Publishing](https://central.sonatype.org/publish/publish-guide/) | [Sonatype Publishing: Maven](https://central.sonatype.org/publish/publish-maven/) |
* [gh-actions: setup-java action](https://github.com/marketplace/actions/setup-java-jdk) | [GitHub Packages Maven Repository](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-apache-maven-registry) |
* [gh-actions: build and test with mvn](https://docs.github.com/en/actions/automating-builds-and-tests/building-and-testing-java-with-maven) | [gh-actions: publishing with mvn](https://docs.github.com/en/actions/publishing-packages/publishing-java-packages-with-maven) |
* [vs-code:java](https://code.visualstudio.com/docs/java/java-tutorial) | [mvn in 5 minutes](https://maven.apache.org/guides/getting-started/maven-in-five-minutes.html) | [mvn getting-started](https://maven.apache.org/guides/getting-started/) | [mvn spring](https://spring.io/guides/gs/maven/) |

Although I'm trying to keep consistently versioned installations across both my windows and WSL environments, it looks like I have several previous temurian installations and java paths injected into system environment variables that it might take a while to clean up. Although for years I'd assumed there was some benefit to sticking with Oracle's release of JDK 8, it looks like I'd previously been using temurian 11, so we'll start off setting up in WSL with a quick `sudo apt update && apt install openjdk-11-jre-headless maven`, only to find that for some reason, WSL has hashed the `mvn` command's path to my window's mvn. So despite `which mvn` yielding `/usr/bin/mvn`; `mvn -v` would indicate `Maven home: /mnt/c/Apache/Maven/3.6.1` (although curiously it dynamically determined the java path to be `/usr/lib/jvm/java-11-openjdk-amd64`, correct for this context, instead of the windows installation of temurian), `type mvn` came back with a `mvn is hashed (/mnt/c/Apache/Maven/3.6.1/bin/mvn)`. A quick `hash -r mvn`, and `mvn -v` is successfully giving us `Maven home: /usr/share/maven`. We can now initiate the project with;
```
mvn archetype:generate -DgroupId=org.skenvy.collatz -DartifactId=Collatz -DarchetypeArtifactId=maven-archetype-quickstart -DarchetypeVersion=1.4 -DinteractiveMode=false -e
```
Which will have created a `~/java/Collatz/` folder, but we want to bring that down one (after the above created the pom using that artifact ID), so we'll just `mv Collatz/* .` and ` rmdir Collatz/`.  

It turns out though that to [set up a project on sonatype](https://central.sonatype.org/publish/publish-guide/#introduction) to host the repository that gets synced with [maven central](https://mvnrepository.com/repos/central), the java-esque style of naming a project/package in reverse DNS order is strongly enforced, so we'll have to immediately recreate the project to [follow these groupID naming requirements](https://central.sonatype.org/publish/requirements/coordinates/) which suggests for instance naming the groupID according to the hosting platform along the lines of `io.github.myusername`.
```
mvn archetype:generate -DgroupId=io.github.skenvy -DartifactId=Collatz -DarchetypeArtifactId=maven-archetype-quickstart -DarchetypeVersion=1.4 -DinteractiveMode=false -e
```
To acquire the rights to use the `io.github.myusername`-eqsue groupID on sonatype, there's also the additional required step, after having made a ticket to request the registration, to;
* _if you want to use io.github.myusername you must create the public repository OSSRH-TICKETNUMBER like this github.com/myusername/OSSRH-TICKETNUMBER_

I've created [the ticket](https://issues.sonatype.org/browse/OSSRH-81108), but the [Bot Central-OSSRH](https://issues.sonatype.org/secure/ViewProfile.jspa?name=central-ossrh) hasn't yet automatically commented requesting the existence of `github.com/myusername/OSSRH-TICKETNUMBER` yet, so I'll just go create it anyway I guess.

A day later, the ticket has been sorted out, so we can start addressing the  additional [publishing requirements](https://central.sonatype.org/publish/requirements/).

Now we'll want to set up the release and deployment of the built JAR to OSSRH and GitHub. This'll include adding two profiles to the `pom.xml` to swap between them within the `distributionManagement`'s `repository`. We'll also need to add the javadoc and gpg plugins to the pom. The [gh-actions: publishing with mvn](https://docs.github.com/en/actions/publishing-packages/publishing-java-packages-with-maven) appears to be incomplete when compared to [Sonatype Publishing: Maven](https://central.sonatype.org/publish/publish-maven/), and it's not clear without looking into it if the github guide is suggesting that set up it automatically handled or not, but the setup java action has input options for gpg, so it seems like we'll need to at least [set up a gpg key for sonatype](https://central.sonatype.org/publish/requirements/gpg/). We can `gpg --gen-key` and pick a passphrase, then `gpg --list-keys` to get the key-id, in this case `F398EA6448A7708EAABBB0DEC203EA8449D06C1B`, and send it with;
* `gpg --keyserver keyserver.ubuntu.com --send-keys F398EA6448A7708EAABBB0DEC203EA8449D06C1B`
* `gpg --keyserver keys.openpgp.org --send-keys F398EA6448A7708EAABBB0DEC203EA8449D06C1B`
* `gpg --keyserver pgp.mit.edu --send-keys F398EA6448A7708EAABBB0DEC203EA8449D06C1B`

With the key sent to the 3 servers the central repository uses, we can `gpg --armor --export-secret-keys F398EA6448A7708EAABBB0DEC203EA8449D06C1B > private.gpg`, and upload the `MAVEN_GPG_PASSPHRASE`, `MAVEN_GPG_PRIVATE_KEY` (the exported key from the last step), `OSSRH_USERNAME`, and `OSSRH_TOKEN` (account password) to github secrets.

Frustratingly, there's a few pieces of this setup that aren't in either the GitHub example, or in any sonatype example, and if you encounter any of a handful of bugs, the only places answers appear to be readily available without digging deeper are in several personal blogs, like the options and profile wrapping of gpg in the pom, and the gpg key phrasing and passing to the github actions. Although that could obviously be gleaned from the setup-java action, it's frustrating that where other github quickstarts to deployment generally work much more out of the box, the maven deployment feels only half baked.

Snapshots on OSSRH are uploaded to [here](https://s01.oss.sonatype.org/content/repositories/snapshots/io/github/skenvy/collatz/), and releases [here](https://s01.oss.sonatype.org/content/repositories/releases/io/github/skenvy/collatz/).

By this stage, I've pushed a `0.1.0` version to ossrh and github, but [nexus-search;collatz](https://s01.oss.sonatype.org/#nexus-search;quick~collatz) shows only the snapshots. And visiting [the ossrh upload destination](https://s01.oss.sonatype.org/service/local/staging/deploy/maven2/io/github/skenvy/collatz) yields;
```
<nexus-error>
  <errors>
    <error>
      <id>*</id>
      <msg>Staging of Repository within profile ID='{some profile ID}' is not yet started!</msg>
    </error>
  </errors>
</nexus-error>
```
It took several attempts of logging in and logging out amid error messages every time I clicked anything on nexus showing 5xx or 4xx errors (perhaps from slow internet), but eventually the [Staging Repositories](https://s01.oss.sonatype.org/#stagingRepositories) showed more than a blank screen. It shows my automatically generated staging repository and the content within that staging repository shows the `0.1.0` version uploaded last night. So now we need to have a look at [sonatype releasing](https://central.sonatype.org/publish/release/). It appears that we must manually "close" the staging area, which will trigger a test against its contents. If everything was done right up to this point, all the tests should pass, and option to "Release" will be available. I'm not sure how long the "SBOM report" will be available for, so this link but expire, but the "closing" stage emailed me [this report](https://sbom.lift.sonatype.com/report/T1-a0368c8f29fdaa555824-9040f98e50aa54-1653640676-298e7ba4b7434494879cb1fb6c8f8dd1). With that done, we've finally deployed the packaged jar to the sonatype release page [here](https://s01.oss.sonatype.org/content/repositories/releases/io/github/skenvy/collatz/), which will eventually sync with the maven central repository.

Now that the code seems essentially adequate, it's time to look into adding/parallel-publishing of documentation. [`mvn site`](https://maven.apache.org/plugins/maven-site-plugin/) is the default/generic maven plugin for building the "site" (and [`mvn site:run`](https://maven.apache.org/plugins/maven-site-plugin/run-mojo.html)) will preview the contents of the site in a localhost webserver. To deploy the docs generated by `mvn site:stage`, we have [`mvn scm-publish`](https://maven.apache.org/plugins/maven-scm-publish-plugin/index.html), which can be used to deploy the site to GitHub Pages. There's a lot of blogs about how this `scm-publish` plugin is lacking in documentation or that it isn't all entirely accurate, so thank goodness it appears there's a `-Dscmpublish.dryRun=true` option to only test its functionality while figuring out how to use it. It's also apparent the list of options/inputs to the plugin step for publishing aren't mentioned on the website, for some reason, unlike the other plugins used so far, so will have to rely on `mvn scm-publish:help -Ddetail=true -Dgoal=publish-scm` to get the list of inputs.

Following on from the way we published docs in the julia iteration, we want to be able to deploy the site to a `gh-pages-java`, with the site's root index in a `java` folder, which can then be merged to the actual `gh-pages` branch with the [GitHub 🐱‍👤 Pages 📄 Merger 🧬](https://github.com/Skenvy/Collatz/blob/main/.github/workflows/github-pages.yaml) workflow. From the list of inputs from the help command, we can see a few parameters worth mention;
* `checkinComment`
  * (Default: Site checkin for project ${project.name})
  * User property: scmpublish.checkinComment
* `pubScmUrl` **Required**
  * (Default: ${project.distributionManagement.site.url})
  * User property: scmpublish.pubScmUrl
* `scmBranch`
  * User property: scmpublish.scm.branch
* `subDirectory`
  * Location where the content is published inside the ${checkoutDirectory}.
  * User property: scmpublish.subDirectory

Knowing this, we can try setting `scmpublish.subDirectory` to `"java"`, use the [tips](https://maven.apache.org/plugins/maven-scm-publish-plugin/various-tips.html) on the plugin for setting the `project.distributionManagement.site.url` which is used as the default for `scmpublish.pubScmUrl`, and add a `plugin.configuration.scmBranch` on the `maven-scm-publish-plugin` plugin, despite that being different from the "User property" `scmpublish.scm.branch`? The only thing that will likely need to be added on the command line in the make recipe that is run by the CI step will be the value passed to `checkinComment` so as to mimic the same behaviour provided by the julia docs generating, which is to add the short sha of the commit from which the docs were built in the checkin comment.

Once again we create an empty orphan branch;
1. `git checkout --orphan gh-pages-java`
1. `rm .git/index ; git clean -fdx`
1. `git commit -m "Initial empty orphan" --allow-empty`
1. `git push --set-upstream origin gh-pages-java`
