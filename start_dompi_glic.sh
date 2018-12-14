#!/bin/bash
# show commands being executed, per debug
set -x

# Set job parameters
######################################################################
## check what MPI implementation is loaded before setting the parameter
## module list ??
#BSUB -a openmpi

# Set number of CPUs
#BSUB -n 4


# Start R MPI job
mpirun.lsf ./dompi_example.R
