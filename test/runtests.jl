using Aqua
using Documenter
using HashCode2014
using StreetCars
using JET
using JuliaFormatter
using PythonCall
using Test
using Random: MersenneTwister

DocMeta.setdocmeta!(StreetCars, :DocTestSetup, :(using StreetCars); recursive=true)

@testset verbose = true "StreetCars.jl" begin

    @testset "Doctests (Documenter.jl)" begin
        doctest(StreetCars)
    end

    @testset "Small instance" begin
        input_path = joinpath(@__DIR__, "data", "example_input.txt")
        output_path = joinpath(@__DIR__, "data", "example_output.txt")
        city = read_city(input_path)
        solution = read_solution(output_path)
        open(input_path, "r") do file
            @test string(city) == read(file, String)
        end
        open(output_path, "r") do file
            @test string(solution) == read(file, String)
        end
        @test is_feasible(solution, city)
        @test total_distance(solution, city) == 450
    end

    @testset "Large instance" begin
        city = read_city()
        rng = MersenneTwister(0);
        solution = directed_random_walk(rng, city)
        @test city.total_duration == 54000
        @test is_feasible(solution, city)
    end

    @testset "RouteGrid" begin
        city = read_city()
        rg = RouteGrid(city)
        solution = directed_random_walk(rg)
        @test rg.city.total_duration == 54000
        @test is_feasible(solution, rg.city)
    end
    
    @testset "add_street_to_seen" begin
        city = read_city()
        rg = RouteGrid(city)
        StreetCars.add_street_to_seen(rg, 4440)
        StreetCars.add_street_to_seen(rg, 5755)
        @test rg.seen_streets == Set{Int64}([4440, 5755])
    end

    @testset "get_seen_and_unseen_canditates" begin
        city = read_city()
        rg = RouteGrid(city)
        current_junction = 1
        duration = 0
        candidates, unseen_candidates = StreetCars.get_seen_and_unseen_canditates(rg, current_junction, duration)

        expected_candidates = Tuple{Int64, Street}[(4440, Street(1, 4943, false, 25, 277)), (5755, Street(1, 1080, true, 13, 113)), (13613, Street(2913, 1, true, 23, 178))]
        expected_unseen_candidates = Tuple{Int64, Street}[(4440, Street(1, 4943, false, 25, 277)), (5755, Street(1, 1080, true, 13, 113)), (13613, Street(2913, 1, true, 23, 178))]
        @test candidates == expected_candidates
        @test unseen_candidates == expected_unseen_candidates

        StreetCars.add_street_to_seen(rg, 4440)
        StreetCars.add_street_to_seen(rg, 5755)
        candidates, unseen_candidates = StreetCars.get_seen_and_unseen_canditates(rg, current_junction, duration)
        expected_candidates = Tuple{Int64, Street}[(4440, Street(1, 4943, false, 25, 277)), (5755, Street(1, 1080, true, 13, 113)), (13613, Street(2913, 1, true, 23, 178))]
        expected_unseen_candidates = Tuple{Int64, Street}[(13613, Street(2913, 1, true, 23, 178))]
        @test candidates == expected_candidates
        @test unseen_candidates == expected_unseen_candidates

    end

end