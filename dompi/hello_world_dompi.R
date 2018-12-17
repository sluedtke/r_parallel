# ----------------------------------------------------------------------------

#       Filename: dompi.R

# ----------------------------------------------------------------------------
# 
# This script should illustrate the use of the "doMPI" package on the
# HP-Cluster of GFZ (GLIC)
#
# Of course, a basic knowledge of R is required. 
#
# The "doMPI" package, together with the foreach package, is an easy to apply
# framework for parallel processing. 
# ----------------------------------------------------------------------------


# framework for the Rmpi package to link MPI and foreach
# it will load 'foreach', 'Rmpi' and 'iterators' additionally
library(doMPI)
# ----------------------------------------------------------------------------


# We do not give a number here, which means we take as much as we get- managed
# by the startup script
cl = startMPIcluster()
# register cl for the foreach framework
registerDoMPI(cl)
# ----------------------------------------------------------------------------


result = foreach(i = c(1:10), .inorder = FALSE) %dopar% {
    # The Rmpi package gets loaded with the doMPI package so we have access to
    # some functions to get the properties of the workers.
    # startMPIcluster uses 0 as the default communicator. A communicator
    # is something like a channel the workers and master use to exchange
    # information.
    rank = mpi.comm.rank(comm = 0)
    host = mpi.get.processor.name()
    total_cpu = mpi.comm.size(comm = 0)
    output = paste("Hello, I am worker", rank,
                   "on host", host,
                   "from", total_cpu, "cpu's in total",
                   "processing task ID", i)
}
# ----------------------------------------------------------------------------


closeCluster(cl)
# ----------------------------------------------------------------------------


print(result)
# ----------------------------------------------------------------------------
