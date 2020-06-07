#!/bin/bash

#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task 1
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=16G
#SBATCH --job-name=fairseq
#SBATCH --output=logs/fairseq_%j.log

# Parse architecture command line options
ARCH=${1:-"transformer"}
# Determine architecture
ARCHITECTURE=architectures/$ARCH.sh
# Check if model architecture is defined
if [ ! -f "$ARCHITECTURE" ]; then
	echo "Specified architecture does not exist!"
	echo "Available architectures are:"
	ls architectures/
	exit 9999
fi

# Use the last config file as the default configuration
N=($(ls config_files/$ARCH | wc -l))
# Parse configuration file command line options
CONF=${2:-$N}
# Determine config file
CONFIG_FILES=config_files/$ARCH/$CONF.config
if [ ! -f "$CONFIG_FILES" ]; then
	echo "'$CONFIG_FILES' configuration file does not exist!"
	echo "Available configuration files are:"
	ls config_files/$ARCH/
	exit 9999
fi

# Parse data command line options
FORMAT=${3:-"delex"}
PARAMS=${4:-"1000"}
# Delexicalised data format options
if [ "$FORMAT" == "delex" ]; then
	FORMAT_VERSION=../format_delex
	# Determine number of BPE words
	if [ "$PARAMS" == "1000" ]; then
		FORMAT_VERSION=$FORMAT_VERSION/BPE_1_000
	elif [ "$PARAMS" == "5000" ]; then
		FORMAT_VERSION=$FORMAT_VERSION/BPE_5_000
	elif [ "$PARAMS" == "500" ]; then
		FORMAT_VERSION=$FORMAT_VERSION/BPE_500
	# Handle incorrect inputs
	else
		echo "Number of BPE words not supported!"
		exit 9999
	fi
# Lexicalised data format options
elif [ "$FORMAT" == "lex" ]; then
	FORMAT_VERSION=../format_lex
	EMBEDDING_PATH=../embeddings
	# Determine lexicalised data version to be used
	if [ "$ARCH" == "back_transformer" ]; then
		FORMAT_VERSION=$FORMAT_VERSION/LOW_CAMEL_FULL_BT_MONO
	else
		FORMAT_VERSION=$FORMAT_VERSION/LOW_CAMEL
	fi
	# Determine embeddings to be used
	if [ "$PARAMS" == "glove" ]; then
		EMBEDDING_PATH=$EMBEDDING_PATH/glove.6B.200d.txt
	elif [ "$PARAMS" == "enwiki" ]; then
		EMBEDDING_PATH=$EMBEDDING_PATH/enwiki_20180420_100d.txt
	# Handle incorrect inputs
	else
		echo "Embeddings not supported!"
		exit 9999
	fi
# Handle incorrect inputs
else
	echo "Specified data version is not supported!"
	exit 9999
fi

# Determine checkpoints directory
CHECKPOINTS=checkpoints/$ARCH
# Create it if it does not exist
if [ ! -d "$CHECKPOINTS" ]; then
	mkdir $CHECKPOINTS
fi


echo "Training model: $ARCHITECTURE with config file: $CONFIG_FILES, data version: $FORMAT_VERSION, " \
     "and pretrained embeddings: $EMBEDDING_PATH"

bash $ARCHITECTURE $CONFIG_FILES $FORMAT_VERSION $EMBEDDING_PATH
