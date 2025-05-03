# Install igraph if you haven't already
install.packages("igraph")
library(igraph)

# Install readxl if you haven't already
install.packages("readxl")
library(readxl)


################
# Social Network
################

# Load data from Excel
# file_path <- "/path/to/Company_Social_Network.xlsx" # Sesuaikan dengan lokasi file
employees <- read_excel(file_path, sheet = "Employees")
connections <- read_excel(file_path, sheet = "Connections")

# Create the graph from the edges (connections) data frame
g <- graph_from_data_frame(d = connections, vertices = employees, directed = FALSE)

# Make sure that the 'name' attribute for vertices is correctly set
V(g)$name <- employees$Name

# Plot the Network
plot(g,
     vertex.label = V(g)$name, vertex.size = 10, vertex.label.cex = 0.7, edge.width = 0.5, main = "Company Social Network"
     # Display names of employees
     # Adjust node size
     # Adjust label size
     # Edge thickness
)

# Degree Centrality: Measures how many direct connections each node has, identifying the most connected individuals.
degree_centrality <- degree(g)
degree_centrality

# Betweenness Centrality: Measures how often a node lies on the shortest path between other nodes, indicating who might be a key connector between groups.
betweenness_centrality <- betweenness(g)
betweenness_centrality

# Closeness Centrality: Indicates how close a node is to all other nodes in the network.
closeness_centrality <- closeness(g)
closeness_centrality

# Combine centrality measures into a data frame
centrality_measures <- data.frame(
  name = V(g)$name,
  degree_centrality = degree_centrality,
  betweenness_centrality = betweenness_centrality,
  closeness_centrality = closeness_centrality
)

# Print centrality measures
print(centrality_measures)

# Density: Measures how tightly knit the network is.
network_density <- edge_density(g)
network_density

# Average Path Length: Measures the average number of steps it takes to reach one node from another, indicating the "small-world" nature of the network.
avg_path_length <- mean_distance(g, directed = FALSE)
avg_path_length

# This step colors each department differently in the plot, making it easier to identify cross-departmental connections.
V(g)$color <- as.factor(employees$Department) # Assign colors based on department
plot(g,
     vertex.label = V(g)$name,
     vertex.size = 10,
     vertex.label.cex = 0.7,
     edge.width = 0.5,
     main = "Company Social Network by Department"
)


###########
# Dendogram
###########

# Calculate the adjacency matrix from the igraph object
adj_matrix <- as.matrix(as_adjacency_matrix(g))

# Compute hierarchical clustering on the adjacency matrix
hc <- hclust(dist(adj_matrix), method = "ward.D2")

# Plot the dendrogram
plot(hc, labels = V(g)$name, main = "Clustered Dendrogram of Employees")


###############
# Chord Diagram
###############

# Each segment on the circle represents a department. Arcs between segments represent connections between departments, with thicker arcs showing more connections.
# Install package
install.packages("circlize")
library(circlize)

# Aggregate the number of connections between departments
department_connections <- as.data.frame(table(
  from = employees$Department[match(connections$From, employees$ID)],
  to = employees$Department[match(connections$To, employees$ID)]
))

# Remove self-loops and duplicates (count only unique flows)
department_connections <- department_connections[department_connections$from != department_connections$to,]

# Prepare data as a matrix
dept_matrix <- xtabs(Freq ~ from + to, data = department_connections)
dept_matrix <- as.matrix(dept_matrix)

# Plot the Chord Diagram
chordDiagram(dept_matrix, transparency = 0.5, annotationTrack = "grid",
             preAllocateTracks = list(track.height = 0.05))

# Add labels for each sector (department) with adjusted positioning
circos.trackPlotRegion(track.index = 1, panel.fun = function(x, y) {
  sector.name <- get.cell.meta.data("sector.index")
  circos.text(CELL_META$xcenter, CELL_META$ylim[1] + mm_y(2), sector.name,
              facing = "clockwise", niceFacing = TRUE, adj = c(0, 0.5), cex = 0.8)
}, bg.border = NA)