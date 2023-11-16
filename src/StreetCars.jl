"""
    StreetCars

Package designed to interact with the data of the 2014 Google Hash Code Project
"""
module StreetCars

using Artifacts: @artifact_str
using Random: AbstractRNG, default_rng

export directed_random_walk
export upper_bound

include("directed_random_walk.jl")
include("UpperBound.jl")

end