using Documenter, Collatz
# https://juliadocs.github.io/Documenter.jl/stable/man/hosting/#Overview
# https://juliadocs.github.io/Documenter.jl/stable/lib/public/#Documenter.deploydocs
const _devurl = "dev"
@time deploydocs(
    repo = "github.com/Skenvy/Collatz.git",
    deploy_config = Documenter.GitHubActions(),
    # A special branch for hosting the built docs
    branch = "gh-pages-julia-docs-test-dirname",
    dirname = "julia",
    # Where to deploy to from a non-tagged commit?
    devurl = _devurl,
    devbranch = "main",
    versions = ["stable" => "v^", "v#.#", _devurl => _devurl],
    push_preview = true,
)
