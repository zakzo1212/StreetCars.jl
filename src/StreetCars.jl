"""
    StreetCars

Package designed to interact with the data of the 2014 Google Hash Code Project
"""
module StreetCars

using Artifacts: @artifact_str
using Random: AbstractRNG
using Documenter
using LibGit2_jll
using JuliaFormatter
using Aqua
using PythonCall
using JET

export directed_random_walk
export upper_bound
export RouteGrid

include("directed_random_walk.jl")
include("UpperBound.jl")
include("RouteGrid.jl")

end
