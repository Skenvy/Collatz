# push!(LOAD_PATH,"../src/")
using Documenter, Collatz
# ~ Frob the operational context of jldoctest blocks with a using <this>
DocMeta.setdocmeta!(Collatz, :DocTestSetup, :(using Collatz); recursive=true)
@time makedocs(
    sitename="Collatz",
    modules=[Collatz],
    checkdocs = :exports,
    strict = true,
    format = Documenter.HTML(collapselevel = 1),
    pages = [
        "Introduction" => "index.md",
        "Functions" => "functions.md",
        "Extra" => [
            "Internal Modules" => "internal_modules.md",
            "Constants" => "constants.md",
            "Internal Functions" => "internal_functions.md"
        ]
    ],
)
