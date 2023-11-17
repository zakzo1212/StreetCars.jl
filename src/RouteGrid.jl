using Random
using HashCode2014: City, Solution, is_street_start, get_street_end, Junction, Street
using Artifacts: @artifact_str

"""
RouteGrid

Store a city along with additional instance parameters.

# Fields
- city::City: the city
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

Create a new [`RouteGrid`](@ref) with a different `total_duration` and everything else equal.
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

Add a street to the set of seen streets in a city.
"""
function add_street_to_seen(rg::RouteGrid, street::Int)
    push!(rg.seen_streets, street)
end


"""
    get_seen_and_unseen_canditates(rg, current_junction, duration)

Get the seen and unseen candidates for the next street to take in a city.
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

Create a solution from a City by letting each car follow a walk from its starting point given a search function.
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

Create a solution from a City by letting each car follow a random walk from its starting point.
"""
function directed_random_walk(rg::RouteGrid)
    print("Starting directed random walk")
    rng = MersenneTwister(0)
    search_function = (candidates) -> rand(rng, candidates)
    generic_walk(rg, search_function)
end
