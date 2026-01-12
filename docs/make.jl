using Documenter
using YAMLconfigs

makedocs(
    sitename = "YAMLconfigs.jl",
    authors = "Jeffrey Sarnoff",
    modules = [YAMLconfigs],
    format = Documenter.HTML(
        prettyurls = get(ENV, "CI", nothing) == "true",
        canonical = "https://your-username.github.io/YAMLconfigs.jl",
    ),
    pages = [
        "Home" => "index.md",
        "API Reference" => "api.md",
        "P3109 Concepts" => "p3109.md",
        "Configuration Files" => "configfiles.md",
        "Contributing" => "contributing.md",
    ],
)

# Uncomment for GitHub Pages deployment
# deploydocs(
#     repo = "github.com/your-username/YAMLconfigs.jl.git",
#     devbranch = "main",
# )
