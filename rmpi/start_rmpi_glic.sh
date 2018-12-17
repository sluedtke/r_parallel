#---------------------------------------
# Set job parameters
#BSUB -a openmpi

# Set number of cpus
#BSUB -n 4

# Distribute the cpus equally over the host
#BSUB -R "span[ptile=2]"

# output file - overwrite if exists
#BSUB -oo _output.txt

# error file - overwrite if exists
#BSUB -eo _error.txt


#---------------------------------------
# Start R MPI job
mpirun.lsf Rscript hello_world_dompi.R
