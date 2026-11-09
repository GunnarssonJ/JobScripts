#!/bin/bash
#SBATCH -N 1            # Number of nodes (default 1)
#SBATCH -n 1            # Number of processes (default 1)
#SBATCH -t 1-00:00:00   # Max time: D-HH:MM:SS (default 1 day)
#SBATCH -A C3SE2026-1-24
#SBATCH -p vera

# Setup backup

julia  --project=. -t $SLURM_NTASKS$ script.jl
