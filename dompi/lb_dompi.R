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


result = foreach(i = c(5:15), .inorder = FALSE,
                 .combine = "rbind") %dopar% {
    # The Rmpi package gets loaded with the doMPI package so we have access to
    # some functions to get the properties of the workers.
    # startMPIcluster uses 0 as the default communicator. A communicator
    # is something like a channel the workers and master use to exchange
    # information.
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
                   mpi_end_time = end_time
    )
}
# ----------------------------------------------------------------------------


closeCluster(cl)
# ----------------------------------------------------------------------------


print(result)
# ----------------------------------------------------------------------------
library(tidyverse)

result %>% dplyr::select(mpi_rank, mpi_task_id, mpi_host, contains("start_time"), contains("end_time")) %>%
           tidyr::gather(key, mpi_time, -mpi_rank, -mpi_host, -mpi_task_id ) %>%
           dplyr::mutate(mpi_task_id = as.factor(mpi_task_id)) %>%
           dplyr::mutate(mpi_rank = as.factor(mpi_rank)) %>%
ggplot(aes(y = mpi_rank, x = mpi_time)) +
  # geom_point(size = 3, aes( color = time_slot, group = group)) +
  geom_path(size = 3, aes(color = mpi_task_id, group = mpi_rank)) +
  geom_text(size = 3, aes(label = mpi_task_id)) +
  # xkcdaxis(xrange, yrange) +
  ylab("CPU # ") +
  # xlab("elapsed time in some unit") +
  # theme_xkcd() +
  theme(legend.position = "right",
        legend.title=element_blank(),
        text = element_text(size=25),
        axis.ticks.length=unit(0.5,"cm")
        )
# ----------------------------------------------------------------------------
