# push!(LOAD_PATH,"../src/")
using Documenter, Collatz
@time makedocs(
    sitename="Collatz",
    modules=[Collatz],
    checkdocs = :exports,
    # strict = true,
    format = Documenter.HTML(collapselevel = 1),
    pages = [
        "Introduction" => "index.md",
        "Functions" => "functions.md",
        "Extra" => [
            "Internal Modules" => "internal_modules.md",
            "Constants" => "constants.md",
            "Internal functions" => "internal_functions.md"
        ]
    ],
)

# @time deploydocs(
#     repo = "github.com/Skenvy/Collatz.git",
#     push_preview = true,
# )
