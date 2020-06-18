#!/bin/bash

#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task 1
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=16G
#SBATCH --job-name=fairseq
#SBATCH --output=logs/fairseq_%j.log

while [[ "$#" -gt 0 ]]; do
	case "$1" in
		# Parse the architecture to be used
		-a|--architecture) ARCH="$2"; shift 2;;
		-a=*|--architecture=*) ARCH="${1#*=}"; shift 1;;
		# Parse the configuration file to be used
		-c|--config-file) CONF="$2"; shift 2;;
		-c=*|--config-file=*) CONF="${1#*=}"; shift 1;;
		# Parse format to be used
		-f|--format) FORMAT="$2"; shift 2;;
		-f=*|--format=*) FORMAT="${1#*=}"; shift 1;;
		# Parse BPE number of words
		-b|--bpe) BPE="$2"; shift 2;;
		-b=*|--bpe=*) BPE="${1#*=}"; shift 1;;
		# Parse embeddings source
		-s|--emb-source) SOURCE="$2"; shift 2;;
		-s=*|--emb-source=*) SOURCE="${1#*=}"; shift 1;;
		# Parse embedding dimension
		-d|--emb-dimension) DIMENSION="$2"; shift 2;;
		-d=*|--emb-dimension=*) DIMENSION="${1#*=}"; shift 1;;
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

# Determine config file
CONFIG=config_files/$ARCH/$CONF.config
if [ ! -f "$CONFIG" ]; then
	echo "Unknown configuration file: $CONF"
	echo "Available configuration files are:"
	ls config_files/$ARCH/
	exit 2
fi

# Determine data to be used
FORMAT="../format/$FORMAT"
if [ "$FORMAT" == "delex" ]; then
	FORMAT="$FORMAT/BPE_$BPE"
else
	if [ "$ARCH" == "back_transformer" ]; then
		FORMAT="$FORMAT/LOW_CAMEL_FULL_BT_MONO"
	else
		FORMAT="$FORMAT/LOW_CAMEL"
	fi
fi
if [ ! -d "$FORMAT" ]; then
	echo "Unknown data format: $FORMAT"
	exit 2
fi

# Determine checkpoints directory
CHECKPOINTS=checkpoints/$ARCH
# Create it if it does not exist
if [ ! -d "$CHECKPOINTS" ]; then
	mkdir $CHECKPOINTS
fi

# Output some useful information
echo "Training model: $ARCHITECTURE"
echo "Configuration file: $CONFIG"
echo "Data: $FORMAT"

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
	sh $ARCHITECTURE -c $CONFIG -f $FORMAT -e $EMB -d $DIMENSION
# Train without pretrained embeddings
else
	sh $ARCHITECTURE -c $CONFIG -f $FORMAT
fi
