using Random
using HashCode2014: City, Solution, is_street_start, get_street_end

"""
RouteGrid

Store a city made of [`Junction`](@ref)s and [`Street`](@ref)s, along with additional instance parameters.

# Fields
- `total_duration::Int`: total time allotted for the car itineraries (in seconds)
- `nb_cars::Int`: number of cars in the fleet
- `starting_junction::Int`: junction at which all the cars are located initially
- `junctions::Vector{Junction}`: list of junctions
- `streets::Vector{Street}`: list of streets
"""
@kwdef struct RouteGrid
    total_duration::Int
    nb_cars::Int
    starting_junction::Int
    junctions::Vector{Junction}
    streets::Vector{Street}
    seen_streets::Set{Int}
end

function Base.show(io::IO, city::RouteGrid)
    (; total_duration, nb_cars, starting_junction, junctions, streets) = city
    return print(
        io,
        "RouteGrid with $(length(junctions)) junctions and $(length(streets)) streets, where $nb_cars cars must start from junction $starting_junction and travel for at most $total_duration seconds",
    )
end

function RouteGrid(city_string::AbstractString)
    lines = split(city_string, "\n")
    N, M, T, C, S = map(s -> parse(Int, s), split(lines[1]))

    junctions = Vector{Junction}(undef, N)
    for i in 1:N
        latᵢ, longᵢ = map(s -> parse(Float64, s), split(lines[1 + i]))
        junctions[i] = Junction(; latitude=latᵢ, longitude=longᵢ)
    end
    streets = Vector{Street}(undef, M)
    for j in 1:M
        Aⱼ, Bⱼ, Dⱼ, Cⱼ, Lⱼ = map(s -> parse(Int, s), split(lines[1 + N + j]))
        streets[j] = Street(;
            endpointA=Aⱼ + 1,
            endpointB=Bⱼ + 1,
            bidirectional=Dⱼ == 2,
            duration=Cⱼ,
            distance=Lⱼ,
        )
    end
    city = RouteGrid(;
        total_duration=T,
        nb_cars=C,
        starting_junction=S + 1,
        junctions=junctions,
        streets=streets,
        seen_streets=Set{Int}()
    )
    return city
end

function Base.string(city::RouteGrid)
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
    change_duration(city, total_duration)

Create a new [`RouteGrid`](@ref) with a different `total_duration` and everything else equal.
"""
function change_duration_route_grid(city::RouteGrid, total_duration)
    new_city = RouteGrid(;
        total_duration=total_duration,
        nb_cars=city.nb_cars,
        starting_junction=city.starting_junction,
        junctions=copy(city.junctions),
        streets=copy(city.streets),
    )
    return new_city
end

""" 
    add_street_to_seen(city, street)

Add a street to the set of seen streets in a city.
"""
function add_street_to_seen(city::RouteGrid, street::Street)
    push!(city.seen_streets, street)
    return city
end

"""
    reset_fields(grid::RouteGrid)

Function to reset all fields of a RouteGrid struct to their default values.
"""
function get_seen_and_unseen_canditates(city::RouteGrid, current_junction::Int)
    candidates = [
        (s, street) for (s, street) in enumerate(city.streets) if (
            is_street_start(current_junction, street) &&
            duration + street.duration <= total_duration
        )
    ]
    unseen_candidates = [
        (s, street) for (s, street) in candidates if !(s in seen_streets)
    ]
    return candidates, unseen_candidates
end

# function to perform a generic walk on a city with a search function passed as an arg
function generic_walk(city::RouteGrid, search_function)
    (; total_duration, nb_cars, starting_junction, streets, seen_streets) = city
    itineraries = Vector{Vector{Int}}(undef, nb_cars)
    for c in 1:nb_cars
        println("WORKING ON CAR $c")
        itinerary = [starting_junction]
        duration = 0
        while true
            current_junction = last(itinerary)
            candidates, unseen_candidates = get_seen_and_unseen_canditates(city, current_junction)

            if isempty(unseen_candidates)
                # use seen candidates
                if isempty(candidates)
                    break
                else
                    s, street = search_function(candidates)
                    next_junction = get_street_end(current_junction, street)
                    push!(itinerary, next_junction)
                    duration += street.duration
                    push!(seen_streets, s)
                end
            else
                s, street = search_function(unseen_candidates)
                next_junction = get_street_end(current_junction, street)
                push!(itinerary, next_junction)
                duration += street.duration
                push!(seen_streets, s)
            end
        end
        itineraries[c] = itinerary
    end
    return Solution(itineraries)
end


function directed_random_walk(city::RouteGrid)
    print("Starting directed random walk")
    rng = MersenneTwister(0)
    search_function = (candidates) -> rand(rng, candidates)
    generic_walk(city, search_function)
end

function change_duration(city::RouteGrid, total_duration)
    new_city = RouteGrid(;
        total_duration=total_duration,
        nb_cars=city.nb_cars,
        starting_junction=city.starting_junction,
        junctions=copy(city.junctions),
        streets=copy(city.streets),
        seen_streets=Set{Int}()
    )
    return new_city
end
