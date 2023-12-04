using HashCode2014
using Random: MersenneTwister
using PythonCall
using Revise
using BenchmarkTools

include("UpperBound.jl")
include("RouteGrid.jl")

rng = MersenneTwister(0);

###################
# 15 HOUR EXAMPLE #
###################
city = read_city()
city.junctions[1]
city.streets[1]
rg = RouteGrid(city)

# Find Upper Bound on Solutions
println("City duration: ", rg.city.total_duration)
println("Upper bound: ", upper_bound(rg))

# perform directed random walk to find solution
solution = directed_random_walk(rg)

# check feasibility and distance of solution
feas = is_feasible(solution, rg.city; verbose=true)
dist = total_distance(solution, rg.city)
println("Feasible: ", feas)
println("Distance: ", dist)

# visualize solution
city_map = plot_streets(rg.city, solution; path="city_map.html")

###################
# 5 HOUR EXAMPLE  #
###################

city = read_city()
city.junctions[1]
city.streets[1]
rg = RouteGrid(city)
five_hour_rg= change_duration(rg, 18000)

# Find Upper Bound on Solutions
println("City duration: ", five_hour_rg.city.total_duration)
println("Upper bound: ", upper_bound(five_hour_rg))

# perform directed random walk to find solution
five_hour_solution = directed_random_walk(five_hour_rg)

# check feasibility and distance of solution
feas = is_feasible(five_hour_solution, five_hour_rg.city; verbose=true)
dist = total_distance(five_hour_solution, five_hour_rg.city)
println("Feasible: ", feas)
println("Distance: ", dist)

# visualize solution
city_map = plot_streets(five_hour_rg.city, five_hour_solution; path="city_map.html")

################
# Benchmarking #
################

# you can benchmark the directed random walk function using the following code
sol_benchmark = @benchmark directed_random_walk(rg)
elapsed = @elapsed directed_random_walk(rg)
five_hour_sol_benchmark = @benchmark directed_random_walk(five_hour_rg)
five_hour_elapsed = @elapsed directed_random_walk(five_hour_rg)
