using StreetCars
using HashCode2014
using Documenter

DocMeta.setdocmeta!(StreetCars, :DocTestSetup, :(using StreetCars); recursive=true)

makedocs(;
    modules=[StreetCars, HashCode2014],
    authors="Zachary Zhang <zakzhang@mit.edum> and Andrew Jenkins <awj@mit.edu>",
    repo="https://github.com/zakzo1212/StreetCars.jl/blob/{commit}{path}#{line}",
    sitename="StreetCars.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://zakzo1212.github.io/StreetCars.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md", 
        "Tutorial" => "tutorial.md", 
        "API reference" => "api.md",
        "Algorithms" => "algorithms.md",
    ],
)

deploydocs(;
    repo="github.com/zakzo1212/StreetCars.jl",
    devbranch="main",
)
