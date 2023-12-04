using Random
using HashCode2014: City, Solution, is_street_start, get_street_end
using Artifacts: @artifact_str

"""
    RouteGrid

A immutable custom type that stores both a HashCode2014 City along with a set of streets that have been seen by street cars that are 
exploring that City.

# Fields
- city::City: the HashCode2014 City instance that represents the current problem
- seen_streets::Set{Int}: the set of streets that have been seen
"""
@kwdef struct RouteGrid
    city::City
    seen_streets::Set{Int}
end

function Base.show(io::IO, rg::RouteGrid)
    (; total_duration, nb_cars, starting_junction, junctions, streets) = rg.city
    return print(
        io,
        "RouteGrid with $(length(junctions)) junctions and $(length(streets)) streets, where $nb_cars cars must start from junction $starting_junction and travel for at most $total_duration seconds",
    )
end

function RouteGrid(city::City)
    return RouteGrid(;
        city=city,
        seen_streets=Set{Int}()
    )
end

function Base.string(rg::RouteGrid)
    city = rg.city
    N, M = length(city.junctions), length(city.streets)
    T, C, S = city.total_duration, city.nb_cars, city.starting_junction - 1
    s = "$N $M $T $C $S\n"
    for junction in city.junctions
        s *= string(junction) * "\n"
    end
    for street in city.streets
        s *= string(street) * "\n"
    end
    return chop(s; tail=1)
end

"""
    change_duration(rg, total_duration)

Create and returns a new [`RouteGrid`](@ref) with the specified `total_duration`. All other fields should be the same as the given RouteGrid `rg`.
"""
function change_duration(rg::RouteGrid, total_duration)
    new_city = City(;
        total_duration=total_duration,
        nb_cars=rg.city.nb_cars,
        starting_junction=rg.city.starting_junction,
        junctions=copy(rg.city.junctions),
        streets=copy(rg.city.streets)
    )
    new_rg = RouteGrid(;
        city=new_city,
        seen_streets=Set{Int}()
    )
    return new_rg
end

""" 
    add_street_to_seen(rg, street)

Add the given street to the set of seen streets in the given RouteGrid.
"""
function add_street_to_seen(rg::RouteGrid, street::Int)
    push!(rg.seen_streets, street)
end


"""
    get_seen_and_unseen_canditates(rg, current_junction, duration)

Given a RouteGrid `rg`, a current junction `current_junction`, and a duration `duration`, 
return a tuple of two arrays of tuples. The first array contains all the candidates for the next street to take in a city. 
A candidate is any street that starts at the current junction and whose duration does not exceed the total duration of the city. 
The second returned array contains all of the candidates streets that have not been seen in `rg`.
"""
function get_seen_and_unseen_canditates(rg::RouteGrid, current_junction::Int, duration::Int)
    candidates = [
        (s, street) for (s, street) in enumerate(rg.city.streets) if (
            is_street_start(current_junction, street) &&
            duration + street.duration <= rg.city.total_duration
        )
    ]
    unseen_candidates = [
        (s, street) for (s, street) in candidates if !(s in rg.seen_streets)
    ]
    return candidates, unseen_candidates
end

"""
    generic_walk(rg, search_function)

Create a solution from a RouteGrid by letting each car follow a walk from its starting point given a search function. The search
function should take in an array of candidates and return a tuple of the index of the chosen candidate and the candidate itself.

The walk algorithm works as follows:
1. Initialize the itinerary of each car to be a list containing only the starting junction.
2. While there are still streets that can be explored for a current car:
    a. Get the current junction of the car.
    b. Get the candidates and unseen candidates for the next street to take.
    c. If there are no unseen candidates, then use the seen candidates. If there are no seen candidates, then break out of the loop.
    d. Use the search function to choose the next street to take.
    e. Add the chosen street to the itinerary of the car.
    f. Add the chosen street to the set of seen streets.
"""
function generic_walk(rg::RouteGrid, search_function)
    (; total_duration, nb_cars, starting_junction, streets) = rg.city
    itineraries = Vector{Vector{Int}}(undef, nb_cars)
    for c in 1:nb_cars
        println("WORKING ON CAR $c")
        itinerary = [starting_junction]
        duration = 0
        while true
            current_junction = last(itinerary)
            candidates, unseen_candidates = get_seen_and_unseen_canditates(rg, current_junction, duration)

            if isempty(unseen_candidates)
                # use seen candidates
                if isempty(candidates)
                    break
                else
                    s, street = search_function(candidates)
                    next_junction = get_street_end(current_junction, street)
                    push!(itinerary, next_junction)
                    duration += street.duration
                    add_street_to_seen(rg, s)
                end
            else
                s, street = search_function(unseen_candidates)
                next_junction = get_street_end(current_junction, street)
                push!(itinerary, next_junction)
                duration += street.duration
                add_street_to_seen(rg, s)
            end
        end
        itineraries[c] = itinerary
    end
    return Solution(itineraries)
end

"""
    random_walk(rg)

Create a solution from a RouteGrid by letting each car follow a random walk from its starting point. 
Calls [`generic_walk`](@ref) with a search function that chooses a random candidate.
"""
function directed_random_walk(rg::RouteGrid)
    println("Starting directed random walk")
    rng = MersenneTwister(0)
    search_function = (candidates) -> rand(rng, candidates)
    generic_walk(rg, search_function)
end
