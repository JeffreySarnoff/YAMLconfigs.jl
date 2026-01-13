using Documenter
using YAMLconfigs

makedocs(
    sitename = "YAMLconfigs.jl",
    authors = "Jeffrey Sarnoff",
    modules = [YAMLconfigs],
    format = Documenter.HTML(
        prettyurls = get(ENV, "CI", nothing) == "true",
        canonical = "https://jeffreysarnoff.io/YAMLconfigs.jl",
    ),
    pages = [
        "Home" => "index.md",
        "API Reference" => "api.md",
        "P3109 Concepts" => "p3109.md",
        "Configuration Files" => "configfiles.md",
        "YAML References and Tools" => "yaml.md",
        "Contributing" => "contributing.md",
    ],
)

# Uncomment for GitHub Pages deployment
deploydocs(
     repo = "github.com/JeffreySarnoff/YAMLconfigs.jl.git",
     devbranch = "main",
)
