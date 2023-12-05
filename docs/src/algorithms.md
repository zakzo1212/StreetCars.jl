# Algorithims

## Directed Random Walk

We use a directed random walk as our exploration strategy. For each car at each timestep, we execute the following procedure:

- get the current junction
- get all of the street that are connected to the current junction and filter out those that would lead the duration to exceed our threshold
- for each valid street, we extract those that have not been seen by any of the cars yet
- if there are any streets that have not been seen, we randomly select one of them to use as the next street and add it to the seen streets set
- if there are no unseen streets, we randomly select a valid seen street to use as the next street


With our current implementation, the worst case scenario would lead to a performance slightly that matches a normal random walk. This is the scenario where we never have any seen streets to skip. Our performance would match random walk in this case because with no streets populating our set of seen streets, we wont have any additional overhead of checking whether each candidate street has been seen or not. Other than this scenario, our algorithm should surpass a normal random walk since by avoiding seen streets whenever possible, we increase the probability of visiting more streets overall and therefore covering more total distance. It's worth noting that there will be a slight additional overhead since at each timestep and for each car, we are checking whether each candidate street in within our set of seen streets, leading to an additional ```O(num_cars * num_candidate_streets * 1(lookup time))``` overhead.

