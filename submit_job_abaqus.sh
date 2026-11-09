#!/bin/bash
#SBATCH -N 1            # Number of nodes (default 1)
#SBATCH -n 1            # Number of processes (default 1)
#SBATCH -c 12            # Number of cpus per task (--cpus-per-task)
#SBATCH -t 1-00:00:00   # Max time: D-HH:MM:SS (default 1 day)
#SBATCH -A C3SE2025-1-4 
#SBATCH -p vera
#SBATCH -C ICELAKE


# Setup environment
cp -pr *.inp *.txt *.env *.o *.mod $TMPDIR
module load ABAQUS/2024-hotfix-2450
module load intel/2025a
cd $TMPDIR

# Setup backup
while sleep 1m; do
  rsync -q  rollover.sta rollover.dat $SLURM_SUBMIT_DIR/.
done & 
LOOPPID1=$!
 
while sleep 10m; do
  rsync -q rollover.msg rollover.dat rollover.odb $SLURM_SUBMIT_DIR/.
done &
LOOPPID2=$!

abaqus cpus=$SLURM_CPUS_PER_TASK job=rollover.inp user=usub_rollover_intel.o interactive

kill $LOOPPID1 $LOOPPID2

cp -prf rollover.msg rollover.dat rollover.odb rollover.prt rollover.sta rollover.pes $SLURM_SUBMIT_DIR/.