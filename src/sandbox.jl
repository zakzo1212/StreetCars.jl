using HashCode2014
using Random: MersenneTwister
using PythonCall

#####################################
# Using our own improvements (directed_random_walk)
include("directed_random_walk.jl")

rng = MersenneTwister(0);

city = read_city()
city.junctions[1]
city.streets[1]

solution = directed_random_walk(rng, city)
# sol_benchmark = @benchmark random_walk(rng, city)
# sol_benchmark

is_feasible(solution, city; verbose=true)
total_distance(solution, city)

# write_solution(solution, joinpath(tempdir(), "solution.txt"))
city_map = plot_streets(city, solution; path="city_map.html")

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