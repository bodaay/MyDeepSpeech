#!bin/bash
wget -O /data/sample/deepspeech-0.6.1-models.tar.gz -r -N -c https://github.com/mozilla/DeepSpeech/releases/download/v0.6.1/deepspeech-0.6.1-models.tar.gz 
wget -O /data/sample/audio-0.6.1.tar.gz -r -N -c https://github.com/mozilla/DeepSpeech/releases/download/v0.6.1/audio-0.6.1.tar.gz
cd /data/sample
tar xvf deepspeech-0.6.1-models.tar.gz
tar xvf audio-0.6.1.tar.gz

