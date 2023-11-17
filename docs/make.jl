using StreetCars
using Documenter
using HashCode2014: Junction, Street
include("RouteGrid.jl")

DocMeta.setdocmeta!(StreetCars, :DocTestSetup, :(using StreetCars); recursive=true)

makedocs(;
    modules=[StreetCars, Junction, Street, RouteGrid],
    authors="Zachary Zhang <zakzo1212@gmail.com> and contributors",
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
    ],
)

deploydocs(;
    repo="github.com/zakzo1212/StreetCars.jl",
    devbranch="main",
)
