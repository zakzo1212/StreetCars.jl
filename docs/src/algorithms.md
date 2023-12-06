# Algorithms

## Directed Random Walk

We use a directed random walk as our exploration strategy. For each car at each timestep, we execute the following procedure:

- Get the current junction.
- Get all the streets connected to the current junction and filter out those that would exceed our threshold duration.
- Extract the valid streets that have not been seen by any of the cars yet.
- If there are any unseen streets, randomly select one of them as the next street and add it to the set of seen streets.
- If there are no unseen streets, randomly select a valid seen street as the next street.

With our current implementation, the worst-case scenario would lead to a performance slightly worse than that of a normal random walk. This occurs when we never have any unseen streets. In this case, we would have the additional overhead of always checking if street is in our seen streets set for all streets, for all cars. However, in other scenarios, our algorithm should outperform a normal random walk. By avoiding seen streets whenever possible, we increase the probability of visiting more streets overall and covering more total distance. It's worth noting that there will be a slight additional overhead since, at each timestep and for each car, we are checking whether each candidate street is within our set of seen streets, resulting in an additional `O(num_cars * num_candidate_streets * 1(lookup time))` overhead.