using HashCode2014
using Random: MersenneTwister
using PythonCall

#####################################
# Using our own improvements (directed_random_walk)
#include("directed_random_walk.jl")
include("UpperBound.jl")
include("RouteGrid.jl")

rng = MersenneTwister(0);

city = read_city()
city.junctions[1]
city.streets[1]

rg = RouteGrid(city)

# Find Upper Bound on Solutions
println("City duration: ", rg.city.total_duration)
println("Upper bound: ", upper_bound(rg))

five_hour_rg= change_duration(rg, 18000)
println("City duration: ", five_hour_rg.city.total_duration)
println("Upper bound: ", upper_bound(five_hour_rg))

solution = directed_random_walk(rg)

# sol_benchmark = @benchmark random_walk(rng, city)
# sol_benchmark

feas = is_feasible(solution, rg.city; verbose=true)
dist = total_distance(solution, rg.city)

println("Feasible: ", feas)
println("Distance: ", dist)

# write_solution(solution, joinpath(tempdir(), "solution.txt"))
city_map = plot_streets(rg.city, solution; path="city_map.html")

#####################################
# The code below uses the base template code to find a solution
#####################################

# rng = MersenneTwister(0);

# city = read_city()
# city.junctions[1]
# city.streets[1]

# solution = random_walk(rng, city)
# # sol_benchmark = @benchmark random_walk(rng, city)
# # sol_benchmark

# is_feasible(solution, city; verbose=true)
# total_distance(solution, city)

# # write_solution(solution, joinpath(tempdir(), "solution.txt"))
# city_map = plot_streets(city, solution; path="city_map.html")