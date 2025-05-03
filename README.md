# Social Network Analysis for Company Departments

This repository contains an R script for analyzing and visualizing the social network within a company using the `igraph` and `circlize` packages. The analysis includes centrality measures, network metrics, dendrograms, and chord diagrams to explore employee connections and departmental interactions.

## Features

- **Social Network Visualization**: Plot employee connections and departmental clusters.
- **Centrality Analysis**: Calculate degree, betweenness, and closeness centrality.
- **Network Metrics**: Compute network density and average path length.
- **Dendrogram**: Hierarchical clustering of employees based on connections.
- **Chord Diagram**: Visualize inter-departmental connections.

## Key Outputs

-    Centrality Measures:

      -  `degree_centrality`: Number of direct connections per employee.

      -  `betweenness_centrality`: Bridge potential between groups.

      -  `closeness_centrality`: Proximity to all other employees.

-    Network Metrics:

      -  `network_density`: Overall connectivity (0 = sparse, 1 = fully connected).

      -  `avg_path_length`: Average steps between any two employees.

-    Visualizations:

     -   Social network plot colored by department.

     -   Dendrogram of employee clusters.

     -   Chord diagram of inter-departmental connections.
