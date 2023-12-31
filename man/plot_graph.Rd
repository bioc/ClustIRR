\name{plot_graph}
\alias{plot_graph}
\title{Plot ClustIRR graph}
\usage{plot_graph(clust_irr, as_visnet=FALSE)}
\arguments{
\item{clust_irr}{S4 object of type \code{clust_irr}, result of \code{clust_irr} 
function}
\item{as_visnet}{logical, if as_visnet=TRUE we plot an interactive graph with 
visNetwork. If as_visnet=FALSE, we plot a static graph with igraph.}}
\value{
The output is an igraph plot.

Vertices are clones and edges represent local or global similarities. Edge 
attributes 'color', 'linetype' and 'thickness' can be interpreted as follows:

\itemize{
\item Edge colors
    \itemize{
        \item purple: local CDR3 similarity
        \item green: global CDR3 similarity
        \item black: local + global CDR3 similarity
    }
\item Edge linetypes
    \itemize{
        \item dashed: similarity between CDR3\eqn{\beta}, CDR3\eqn{\delta}, 
        CDR3H
        \item dotted: similarity between CDR3\eqn{\alpha}, CDR3\eqn{\gamma}, 
        CDR3L
        \item solid: similarity between CDR3s from both chains (e.g. 
        CDR3\eqn{\alpha} and CDR3\eqn{\beta})
    }
\item Edge thickness: number of edges between two clones
}

The size of the vertices increases linearly as the logarithm of the degree of 
the clonal expansion (number of cells per clone) in the corresponding clones.
}


\description{
This this function visualizes a graph. The input is \code{clust_irr} object
created by the function \code{cluster_irr}.
}

\examples{
# load package input data
data("CDR3ab")
s <- base::data.frame(CDR3b = CDR3ab[1:1000, "CDR3b"])
r <- base::data.frame(CDR3b = CDR3ab[1:5000, "CDR3b"])

# artificially enrich motif 'RWGW' inside sample dataset
base::substr(x = s$CDR3b[1:20], start = 6, stop = 9) <- "RWGW"

# add an artificial clonal expansion of two sequences to the sample dataset
s <- rbind(s, base::data.frame(CDR3b = rep(x = c("CATSRADKPDGLDALETQYF",
                                "CATSRAAKPDGLAALSTQYF"),
                                times = 5)))

# run analysis
out <- cluster_irr(s = s,
                   r = r,
                   version = 2,
                   ks = 4,
                   cores = 1,
                   control = list(
                        global_max_dist = 1,
                        local_max_fdr = 0.05,
                        local_min_ove = 2,
                        local_min_o = 1,
                        trim_flank_aa = 3,
                        global_pairs = NULL,
                        low_mem = FALSE))

# plot graph with vertices as clones
p1 <- plot_graph(out, as_visnet=FALSE)
p1

# access nodes and edges of the graph as data.frame
n <- p1$x$nodes
str(n)
class(n)
head(n)

e <- p1$x$edges
str(e)
class(e)
head(e)
}
