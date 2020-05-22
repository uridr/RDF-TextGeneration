#!/bin/bash

#SBATCH --gres=gpu:2
#SBATCH --cpus-per-task 2
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=40G
#SBATCH --output=runmodel_%j.log

# Architecture to be used
ARCH="$1"
CHECKPOINTS="checkpoints/$ARCH"
ARCHITECTURE="architectures/$ARCH.sh"
# Configuration file
CONFIG="$2"

# Check if model architecture is defined
if [ ! -f "$ARCHITECTURE" ]; then
	echo "Specified architecture does not exist!"
	echo "Available architectures are:"
	ls architectures/
	exit 9999
fi

# Create checkpoints directory if needed
if [ ! -d "$CHECKPOINTS" ]; then
	mkdir $CHECKPOINTS
fi

bash $ARCHITECTURE $CONFIG
