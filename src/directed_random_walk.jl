using Random: AbstractRNG
using HashCode2014: City, Solution, is_street_start, get_street_end
"""
    directed_random_walk(rng, city)
    directed_random_walk(city)

Create a solution from a [`City`](@ref) by letting each car follow a random walk from its starting point. 
Bias is given to streets that have not been seen yet.
"""
function directed_random_walk(rng::AbstractRNG, city::City)
    (; total_duration, nb_cars, starting_junction, streets) = city
    itineraries = Vector{Vector{Int}}(undef, nb_cars)
    seen_streets = Set{Int}()
    for c in 1:nb_cars
        println("WORKING ON CAR $c")
        itinerary = [starting_junction]
        duration = 0
        while true
            current_junction = last(itinerary)
            candidates = [
                (s, street) for (s, street) in enumerate(streets) if (
                    is_street_start(current_junction, street) &&
                    duration + street.duration <= total_duration
                )
            ]
            unseen_candidates = [
                (s, street) for (s, street) in candidates if !(s in seen_streets)
            ]

            if isempty(unseen_candidates)
                # use seen candidates
                if isempty(candidates)
                    break
                else
                    s, street = rand(rng, candidates)
                    next_junction = get_street_end(current_junction, street)
                    push!(itinerary, next_junction)
                    duration += street.duration
                    push!(seen_streets, s)
                end
            else
                s, street = rand(rng, unseen_candidates)
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

directed_random_walk(city::City) = directed_random_walk(default_rng(), city)