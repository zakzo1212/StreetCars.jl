using Random: AbstractRNG
using HashCode2014: City, Solution, is_street_start, get_street_end
include("RouteGrid.jl")

"""
    upper_bound(city)

Estimates the upper bound on the total distance that can be covered by 8 cars for a given city. Note that the city
includes the total duration, the number of cars, the starting junction, and the streets.

The method involves sorting the city's streets by their distance to duration ratio and then greedily choosing the streets
that have the greatest ratio until the total duration of the city is reached. Note that since we have 8 cars, we can 
consider the total duration to be 8 times the duration of the city.
"""
function upper_bound(city::RouteGrid)

    time_limit = city.total_duration * 8
    streets = city.streets
    sorted_streets = sort(streets, by=street -> street.distance / street.duration, rev=true)
    total_distance = 0

    for street in sorted_streets
        if street.duration <= time_limit
            total_distance += street.distance
            time_limit -= street.duration
        end
    end

    return total_distance

end
