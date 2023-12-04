# Tutorial

## Getting started

This package is not registered.
You need to install it from the GitHub repo with

```julia
using Pkg
Pkg.add(url="https://github.com/zakzo1212/StreetCars.jl.git")
```

## Instance and solutions

A problem instance is encoded in an object of type [`City`](@ref).
You can create one for the setting of the challenge (the streets of Paris) as follows:

```jldoctest tuto
julia> using HashCode2014

julia> city = read_city()

julia> city.junctions[1]

julia> city.streets[1]
```

You can then create a RouteGrid object from the City object, which will be used to generate a solution.

```jldoctest tuto
julia> route_grid = RouteGrid(city)
```

You can access attributes of the City within RouteGrid as well as find the upper bound on the distance of a solution within the RouteGrid's allowed duration.

```jldoctest tuto
julia> rg.city.total_duration
julia> upper_bound(rg)
```

A problem solution is encoded in an object of type [`Solution`](@ref).
You can generate a solution using a directed random walk like this:

```jldoctest tuto
julia> solution = directed_random_walk(rg)
```

Then, you can check its feasibility and objective value:

```jldoctest tuto
feas = is_feasible(solution, rg.city; verbose=true)
dist = total_distance(solution, rg.city)
```

You can export it to a text file and visualize the solution:

```jldoctest tuto
julia> write_solution(solution, joinpath(tempdir(), "solution.txt"))
true
```

You can also change the duration of the RouteGrid object and generate a new solution.

```jldoctest tuto
julia> change_duration(rg, 18000)
julia> solution = directed_random_walk(rg)
```

## Visualization

If you load the package [PythonCall.jl](https://github.com/JuliaPy/PythonCall.jl), you will be able to visualize a `City` and its `Solution` with a nice HTML map.
The code below yields an object that is displayed automatically in a Jupyter or Pluto notebook.
If you are working outside of a notebook, just open the resulting file `"city_map.html"` in your favorite browser.

```julia
using PythonCall
julia> city_map = plot_streets(rg.city, solution; path="city_map.html")
```
