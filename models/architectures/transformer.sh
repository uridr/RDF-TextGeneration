#!/bin/bash

while [[ "$#" -gt 0 ]]; do
  case "$1" in
    # Parse configuration file path
    -c|--c) CONFIG="$2"; shift 2;;
    # Parse data path
    -f|--f) FORMAT="$2"; shift 2;;
    # Parse pretrained embeddings path
    -e|--e) EMB="$2"; shift 2;;
    # Parse pretrained embeddings dimension
    -d|--d) DIM="$2"; shift 2;;
    # Parse specified checkpoints directory
    -checkpoints|--checkpoints) CHECKPOINTS="$2"; shift 2;;
    # Parse whether to use optimized fp16 training
    -fp16|--fp16) FP16="$2"; shift 2;;
    # Handle unknown parameters
    -*|--*|*) echo "Unknown parameter: $1"; exit 2;;
    # Store positional arguments
    #*) POSITIONAL+=("$1"); shift 1;;
  esac
done


# Global parameters
ARCHITECTURE=transformer

# Source config file variables to current bash session
. "$CONFIG"

# Whether to use optimized fp16 training
if [ "$FP16" == "True" ]; then
  FP16="--fp16"
else
  FP16=""
fi

# CHECKPOINTS="checkpoints/$ARCHITECTURE/hyper"


determineVersion ()
{
    # Count number of architecture executions
    N=($(ls $CHECKPOINTS | wc -l))
    VERSION="$CHECKPOINTS/v$N"
    # Make version directory
    mkdir $VERSION
    
    # Sub checkpoint and log directories
    SUB_LOG="$VERSION/log"
    SUB_CHE="$VERSION/che"
    mkdir $SUB_LOG
    mkdir $SUB_CHE
}


# Create text file and write all the configuration parameters
writeVersionConfig ()
{
    # Echo the training parameters
    echo "Training parameters:" >> $VERSION/config.txt
    echo "---------------------" >> $VERSION/config.txt
    echo "Training epochs: $1" >> $VERSION/config.txt
    echo "Batch size: $2" >> $VERSION/config.txt
    echo "Label smoothing: $3" >> $VERSION/config.txt
    echo "Norm clipping: $4" >> $VERSION/config.txt
    echo "Adam betas: ($5, $6)" >> $VERSION/config.txt
    echo "Learning rate: $7" >> $VERSION/config.txt
    echo "Learning rate scheduler: $8" >> $VERSION/config.txt
    echo "Warmup steps: $9" >> $VERSION/config.txt
    echo "Initial lr: ${10}" >> $VERSION/config.txt
    # Echo the network parameters
    echo -e "\nNetwork parameters:" >> $VERSION/config.txt
    echo "---------------------" >> $VERSION/config.txt
    echo "Activation function: ${11}" >> $VERSION/config.txt
    echo "Dropout: ${12}" >> $VERSION/config.txt
    echo "Number of encoder/decoder layers: ${13}" >> $VERSION/config.txt
    echo "Embedding dimension: ${14}" >> $VERSION/config.txt
    echo "Learned encoder position embeddings: ${15}" >> $VERSION/config.txt
    echo "Learned decoder position embeddings: ${16}" >> $VERSION/config.txt
    echo "FFN dimension: ${17}" >> $VERSION/config.txt
    echo "Attention heads: ${18}" >> $VERSION/config.txt
    echo "Use cross + self-attention: ${19}" >> $VERSION/config.txt
}

###
# Train the network

# Training optimization
for epoch in "${EPOCHS[@]}"; do
  for b in "${BATCH_SIZE[@]}"; do
    for max_token in "${MAX_TOKEN[@]}"; do
      for patience in "${PATIENCE[@]}"; do
        # Gradient flow
        for ls in "${LABEL_SMOOTHING[@]}"; do
          for clip in "${CLIP_NORM[@]}"; do
            # Optimizer parameters (Adam)
            for beta1 in "${BETA1[@]}"; do
              for beta2 in "${BETA2[@]}"; do
                # Learning rate and scheduler
                for lr in "${LR[@]}"; do
                  for lr_scheduler in "${LR_SCHEDULER[@]}"; do
                    # Learning rate warmup
                    for warmup_updates in "${WARMUP_UPDATES[@]}"; do
                      for warmup_init_lr in "${WARMUP_INIT_LR[@]}"; do
                        # Network parameters
                        for act in "${ACTIVATION[@]}"; do
                          for drop in "${DROPOUT[@]}"; do
                            for act_drop in "${ACTIVATION_DROPOUT[@]}"; do
                              for att_drop in "${ATTENTION_DROPOUT[@]}"; do
                                for layers in "${LAYERS[@]}"; do
                                  for emb_dim in "${EMB_DIM[@]}"; do
                                    for enc_pos in "${ENC_POS[@]}"; do
                                      for dec_pos in "${DEC_POS[@]}"; do
                                        for ffn_dim in "${FFN_DIM[@]}"; do
                                          for heads in "${ATT_HEADS[@]}"; do
                                            for cross in "${CROSS[@]}"; do
                                              # Determine version and build directories
                                              determineVersion
                                              # Write config version into .txt file
                                              writeVersionConfig "$epoch" "$b" "$ls" "$clip" "$beta1" "$beta2" "$lr" \
                                                                 "$lr_scheduler" "$warmup_updates" "$warmup_init_lr" \
                                                                 "$act" "$drop" "$layers" "$emb_dim" "$enc_pos" \
                                                                 "$dec_pos" "$ffn_dim" "$heads" "$cross"

                                              if [ ! -z "$EMB" ]; then
                                                pretrained="--encoder-embed-path $EMB --decoder-embed-path $EMB"
                                                # Determine embedding dimension
                                                use_emb_dim="$DIM"
                                              else
                                                pretrained=""
                                                use_emb_dim="$emb_dim"
                                              fi

                                              # Determine loss criterion to be used
                                              if (( $(echo "$ls > 0.0" |bc -l) )); then
                                                criterion="--criterion label_smoothed_cross_entropy --label-smoothing $ls" 
                                              else
                                                criterion="--criterion cross_entropy"
                                              fi

                                              # Determine learned position embeddings flags
                                              if [[ "$enc_pos" == "True" && "$dec_pos" == "True" ]]; then
                                                learned_pos="--encoder-learned-pos --decoder-learned-pos"
                                              elif [ "$enc_pos" == "True" ]; then
                                                learned_pos="--encoder-learned-pos"
                                              elif [ "$dec_pos" == "True" ]; then
                                                learned_pos="--decoder-learned-pos"
                                              else
                                                learned_pos=""
                                              fi

                                              # Perform cross+self-attention
                                              if [ "$cross" == "True" ]; then
                                                cross="--cross-self-attention"
                                              else
                                                cross=""
                                              fi

                                              # Train the model
                                              fairseq-train $FORMAT $FP16 \
                                                            --task translation -s triple -t lex \
                                                            --max-epoch $epoch --batch-size $b --max-tokens $max_token $criterion \
                                                            --optimizer adam --adam-betas "(${beta1}, ${beta2})" --clip-norm $clip \
                                                            --lr $lr --lr-scheduler $lr_scheduler --warmup-updates $warmup_updates --warmup-init-lr $warmup_init_lr \
                                                            --arch transformer_iwslt_de_en --share-all-embeddings $learned_pos $pretrained \
                                                            --activation-fn $act --dropout $drop --activation-dropout $act_drop --attention-dropout $att_drop $cross \
                                                            --encoder-layers $layers --decoder-layers $layers \
                                                            --encoder-embed-dim $use_emb_dim --decoder-embed-dim $use_emb_dim \
                                                            --encoder-ffn-embed-dim $ffn_dim --decoder-ffn-embed-dim $ffn_dim \
                                                            --encoder-attention-heads $heads --decoder-attention-heads $heads \
                                                            --save-dir $SUB_CHE --no-epoch-checkpoints \
                                                            --tensorboard-logdir $SUB_LOG --log-format json

done; done; done; done; done; done; done; done; done; done; done; done; done; done; done; done; done; done; done; done; done; done; done
