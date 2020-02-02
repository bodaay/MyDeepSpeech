#!/bin/bash
language="ar"
path="/deepspeech"
pathRepo="$path/DeepSpeech"
models="$path/models"
checkpoints="$path/checkpoints"
deactivate
source $path/bin/activate
cd $path
mkdir $models
mkdir $models/$language
mkdir $checkpoints
mkdir $checkpoints/$language
cd $pathRepo
$pathRepo/DeepSpeech.py --train_files $path/data/CV/$language/clips/train.csv --dev_files $path/data/CV/$language/clips/dev.csv --test_files $path/data/CV/$language/clips/test.csv --utf8 true --export_dir $models/$language/ --use_allow_growth true --use_cudnn_rnn true --checkpoint_dir $checkpoints/$language/

