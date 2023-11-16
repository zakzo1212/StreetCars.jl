var documenterSearchIndex = {"docs":
[{"location":"","page":"Home","title":"Home","text":"CurrentModule = StreetCars","category":"page"},{"location":"#StreetCars","page":"Home","title":"StreetCars","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Documentation for StreetCars.","category":"page"},{"location":"","page":"Home","title":"Home","text":"","category":"page"},{"location":"","page":"Home","title":"Home","text":"Modules = [StreetCars]","category":"page"},{"location":"#StreetCars.StreetCars","page":"Home","title":"StreetCars.StreetCars","text":"StreetCars\n\nPackage designed to interact with the data of the 2014 Google Hash Code Project\n\n\n\n\n\n","category":"module"},{"location":"#StreetCars.directed_random_walk-Tuple{Random.AbstractRNG, HashCode2014.City}","page":"Home","title":"StreetCars.directed_random_walk","text":"directed_random_walk(rng, city)\ndirected_random_walk(city)\n\nCreate a solution from a City by letting each car follow a random walk from its starting point.  Bias is given to streets that have not been seen yet.\n\n\n\n\n\n","category":"method"},{"location":"#StreetCars.upper_bound-Tuple{HashCode2014.City}","page":"Home","title":"StreetCars.upper_bound","text":"upper_bound(city)\n\nEstimates the upper bound on the total distance that can be covered by 8 cars for a given city. Note that the city includes the total duration, the number of cars, the starting junction, and the streets.\n\nThe method involves sorting the city's streets by their distance to duration ratio and then greedily choosing the streets that have the greatest ratio until the total duration of the city is reached. Note that since we have 8 cars, we can  consider the total duration to be 8 times the duration of the city.\n\n\n\n\n\n","category":"method"}]
}
