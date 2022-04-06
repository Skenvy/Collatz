include("make.jl")

# https://juliadocs.github.io/Documenter.jl/stable/lib/public/#Documenter.deploydocs
@time deploydocs(
    repo = "github.com/Skenvy/Collatz.git",
    deploy_config = GitHubActions(),
    # A special branch for hosting the built docs
    branch = "gh-pages-julia-docs",
    # Where to deploy to from a non-tagged commit?
    devurl = "dev",
    devbranch = "main",
    versions = ["stable" => "v^", "v#.#", devurl => devurl],
    push_preview = true,
)
