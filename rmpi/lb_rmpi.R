# ----------------------------------------------------------------------------

#       Filename: lb_rmpi.R

# ----------------------------------------------------------------------------
# 
# This script should illustrate the use of the "Rmpi" package on the
# HP-Cluster of GFZ (GLIC)
#
# Of course, a basic knowledge of R is required. 
#
# The "doMPI" package, together with the foreach package, is an easy to apply
# framework for parallel processing. 
# ----------------------------------------------------------------------------

library("Rmpi")
library("dplyr")
# ----------------------------------------------------------------------------

# Function the workers will call
worker = function(i) {
    rank = mpi.comm.rank(comm = 0)
    host = mpi.get.processor.name()
    total_cpu = mpi.comm.size(comm = 0)
    start_time = Sys.time()
    Sys.sleep(i)
    end_time = Sys.time()
    output = data.frame(mpi_rank = rank,
                   mpi_host = host,
                   mpi_total_cpu = total_cpu,
                   mpi_task_id = i,
                   mpi_processing_time = i,
                   mpi_start_time = start_time,
                   mpi_end_time = end_time)
   }
# -----------------------------------------------------------------------------


# Generate sample data we want to use 
# x = seq(from = 5, to = 75, by = 5)
x = rev(c(rep(1, 10),10, 5, 5))

# apply the function
result = mpi.applyLB(x, worker)


# shut down the workers
mpi.close.Rslaves()

# turn the list into a data.frame
result = dplyr::bind_rows(result)

#print the results
print(result)


saveRDS(result, "../plots/rmpi_results.rds")
# shut down the process
mpi.quit(save = "no")
# -----------------------------------------------------------------------------


