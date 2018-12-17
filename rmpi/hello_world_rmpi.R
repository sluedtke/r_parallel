# -----------------------------------------------------------------------------
#
#       Filename: hello_world_rmpi.R 
#
# -----------------------------------------------------------------------------
# 
# This script should illustrate the use of the "Rmpi" package on the
# HP-Cluster of GFZ (GLIC)
#
# Of course, a basic knowledge of R is required. 
#
# The "doMPI" package, together with the foreach package, is an easy to apply
# framework for parallel processing. 

library("Rmpi")
# -----------------------------------------------------------------------------


# Function the workers will call
worker = function(i) {
    rank = mpi.comm.rank(comm = 0)
    host = mpi.get.processor.name()
    total_cpu = mpi.comm.size(comm = 0)
    output = paste("Hello, I am worker", rank,
                   "on host", host,
                   "from", total_cpu, "cpu's in total",
                   "processing task ID", i)
}
# -----------------------------------------------------------------------------


# Generate sample data we want to use 
x = seq(from = 1, to = 10, by = 1)


# apply the function
result = mpi.applyLB(x, worker)


# shut down the workers
mpi.close.Rslaves()


#print the results
print(result)


# shut down the process
mpi.quit(save = "no")
# -----------------------------------------------------------------------------
