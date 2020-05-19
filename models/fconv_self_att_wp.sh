#!/bin/bash

# Architecture to be used
ARCH="fconv_self_att_wp"
CHECKPOINTS="checkpoints/$ARCH"

# Load specific configuration file
CONFIG="architectures/cnn_config1.config"
# Source config file variables to current bash session
. "$CONFIG"


determineVersion ()
{
	# Count number of architecture executions
	N=($(ls checkpoints/fconv_self_att_wp | wc -l))
	VERSION="$CHECKPOINTS/v$N"
	# Make version directory
	mkdir $VERSION
	
	# Sub checkpoint and log directories
	SUB_LOG="$VERSION/log"
	SUB_CHE="$VERSION/che"
	mkdir $SUB_LOG
	mkdir $SUB_CHE
}

writeVersionConfig ()
{
	# Create text file and write all the configuration parameters
	echo "Training epochs: $1" >> $VERSION/config.txt
	echo "Batch size: $2" >> $VERSION/config.txt
	echo "Activation function: $3" >> $VERSION/config.txt
	echo "Dropout: $4" >> $VERSION/config.txt
	echo "Number of encoder/decoder layers: $5" >> $VERSION/config.txt
	echo "Embedding dimension: $6" >> $VERSION/config.txt
	echo "FFN dimension: $7" >> $VERSION/config.txt
	echo "Attention heads: $8" >> $VERSION/config.txt
}


# Train the network
for epoch in "${EPOCHS[@]}"; do
	for b in "${BATCH_SIZE[@]}"; do
		for drop in "${DROPOUT[@]}"; do
			for layers in "${LAYERS[@]}"; do
				for emb_dim in "${EMB_DIM[@]}"; do
					for heads in "${ATT_HEADS[@]}"; do
						# Determine version and build directories
						determineVersion
						# Write config version into .txt file
						writeVersionConfig "$epoch" "$b" "$act" "$drop" "$layers" "$emb_dim" "$heads"
						# Train the model
						fairseq-train ../format/BPE_1_000 \
						              --criterion cross_entropy \
									  --optimizer adam --lr 1e-03 --clip-norm 0.1 --weight-decay .0000001\
									  --max-epoch $epoch --batch-size $b \
									  --task translation -s triple -t lex \
									  --save-dir $SUB_CHE --no-epoch-checkpoints \
									  --no-progress-bar --log-interval 1000 --log-format json --tensorboard-logdir $SUB_LOG \
									  --arch $ARCH --share-input-output-embed \
									  --dropout $drop \
									  --encoder-layers $layers --decoder-layers $layers \
									  --encoder-embed-dim $emb_dim --decoder-embed-dim $emb_dim \
									  --decoder-out-embed-dim $emb_dim \
									  --multihead-self-attention-nheads $heads \
									  --gated-attention True --self-attention True
done; done; done; done; done; done
						