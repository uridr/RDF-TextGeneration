#!/bin/bash

#SBATCH --gres=gpu:2
#SBATCH --cpus-per-task 2
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=64G
#SBATCH --job-name=fairseq
#SBATCH --output=logs/fairseq_%j.log

# POSITIONAL=()
while [[ "$#" -gt 0 ]]; do
	case "$1" in
		# Parse the architecture to be used
		-a|--architecture) ARCH="$2"; shift 2;;
		-a=*|--architecture=*) ARCH="${1#*=}"; shift 1;;
		# Parse the configuration file to be used
		-c|--config-file) CONF="$2"; shift 2;;
		-c=*|--config-file=*) CONF="${1#*=}"; shift 1;;

		# Define the relative path to the data to be used
		-p|--data-path) DATAPATH="$2"; shift 2;;
		-p=*|--data-path=*) DATAPATH="$2"; shift 1;;

		# Parse embeddings source
		-s|--emb-source) SOURCE="$2"; shift 2;;
		-s=*|--emb-source=*) SOURCE="${1#*=}"; shift 1;;
		# Parse embedding dimension
		-d|--emb-dimension) DIMENSION="$2"; shift 2;;
		-d=*|--emb-dimension=*) DIMENSION="${1#*=}"; shift 1;;

		# Use optimized fp16 precision training
		-fp16|--fp16) FP16="True"; shift 1;;
		
		# Handle unknown parameters
		-*|--*|*) echo "Unknown parameter: $1"; exit 2;;
		# Store positional arguments
		# *) POSITIONAL+=("$1"); shift 1;;
	esac
done

# Determine architecture
ARCHITECTURE=architectures/$ARCH.sh
# Check if model architecture is defined
if [ ! -f "$ARCHITECTURE" ]; then
	echo "Unknown architecture: $ARCH"
	echo "Available architectures are:"
	ls architectures/
	exit 2
fi

# Whether to use optimized training or not
if [ ! -z "$FP16" ]; then
	FP16="$FP16"
else
	FP16="False"
fi

# Determine config file
CONFIG=config_files/$ARCH/$CONF.config
if [ ! -f "$CONFIG" ]; then
	echo "Unknown configuration file: $CONF"
	echo "Available configuration files are:"
	ls config_files/$ARCH/
	exit 2
fi

# Determine data to be used
if [ ! -z "$DATAPATH" ]; then
	FORMAT="$DATAPATH"
else
	echo "Datapath must be specified!"
	exit 2
fi
# Check if data path exists
if [ ! -d "$FORMAT" ]; then
	echo "Unknown data format: $FORMAT"
	exit 2
fi

# Determine checkpoints directory
CHECKPOINTS=checkpoints/$ARCH/new
# Create it if it does not exist
if [ ! -d "$CHECKPOINTS" ]; then
	mkdir $CHECKPOINTS
fi

# Output some useful information
echo "Training model: $ARCHITECTURE"
echo "Configuration file: $CONFIG"
echo "Data: $FORMAT"
echo "Saving checkpoints at: $CHECKPOINTS"
echo "Using optimized fp16 training: $FP16"

# Train with pretrained embeddings
if [ ! -z "$SOURCE" ]; then
	EMB="../embeddings/$SOURCE"
	if [ "$SOURCE" == "glove" ]; then
		EMB="$EMB/glove.6B.${DIMENSION}d.txt"
	else
		EMB="$EMB/enwiki_20180420_${DIMENSION}d.txt"
	fi
	# Check if embeddings exist
	if [ ! -f "$EMB" ]; then
		echo "Unknown pretrained embeddings path: $EMB"
		exit 2
	fi
	echo "Pretrained embeddings: $EMB"
	sh $ARCHITECTURE -c $CONFIG -f $FORMAT -e $EMB -d $DIMENSION --checkpoints $CHECKPOINTS --fp16 $FP16
# Train without pretrained embeddings
else
	sh $ARCHITECTURE -c $CONFIG -f $FORMAT --checkpoints $CHECKPOINTS --fp16 $FP16
fi
