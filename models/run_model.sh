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
# Delexicalised data format options
if [ "$FORMAT" == "delex" ]; then
	FORMAT_VERSION=../format_delex
	# Parse number of BPE words to be used
	BPE=${4:-"1000"}
	# Determine data version relative path
	if [ "$BPE" == "500" ]; then
		FORMAT_VERSION=$FORMAT_VERSION/BPE_500
	elif [ "$BPE" == "1000" ]; then
		FORMAT_VERSION=$FORMAT_VERSION/BPE_1_000
	elif [ "$BPE" == "5000" ]; then
		FORMAT_VERSION=$FORMAT_VERSION/BPE_5_000
	elif [ "$BPE" == "7000" ]; then
		FORMAT_VERSION=$FORMAT_VERSION/BPE_7_000
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
	# Parse embedding options to be used
	EMB_SOURCE=${4:-glove}
	EMB_DIM=${5:-"300"}
	# Determine embeddings to be used
	if [ "$EMB_SOURCE" == "glove" ]; then
		EMBEDDING_PATH=$EMBEDDING_PATH/glove
		# Determine dimension
		if [ "$EMB_DIM" == "50" ]; then
			EMBEDDING_PATH=$EMBEDDING_PATH/glove.6B.50d.txt
		elif [ "$EMB_DIM" == "100" ]; then
			EMBEDDING_PATH=$EMBEDDING_PATH/glove.6B.100d.txt
		elif [ "$EMB_DIM" == "200" ]; then
			EMBEDDING_PATH=$EMBEDDING_PATH/glove.6B.200d.txt
		elif [ "$EMB_DIM" == "300" ]; then
			EMBEDDING_PATH=$EMBEDDING_PATH/glove.6B.300d.txt
		else
			echo "Embedding dimension not supported for $EMB_SOURCE embeddings!"
			exit 9999
		fi
	elif [ "$EMB_SOURCE" == "enwiki" ]; then
		EMBEDDING_PATH=$EMBEDDING_PATH/enwiki
		# Determine dimension
		if [ "$EMB_DIM" == "100" ]; then
			EMBEDDING_PATH=$EMBEDDING_PATH/enwiki_20180420_100d.txt
		elif [ "$EMB_DIM" == "300" ]; then
			EMBEDDING_PATH=$EMBEDDING_PATH/enwiki_20180420_300d.txt
		else
			echo "Embedding dimension not supported for $EMB_SOURCE embeddings!"
			exit 9999
		fi
	else
		echo "Embeddings source is not supported!"
		exit 9999
	fi
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

# Verbose some useful info
echo "Training model: $ARCHITECTURE with config file: $CONFIG_FILES and data version: $FORMAT_VERSION"
if [ ! -z "$EMBEDDING_PATH" ]; then
	echo "Using pretrained embeddings: $EMBEDDING_PATH"
fi

bash $ARCHITECTURE $CONFIG_FILES $FORMAT_VERSION $EMBEDDING_PATH
