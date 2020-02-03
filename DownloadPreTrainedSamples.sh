#!/bin/bash
mkdir /data/sample
wget -O /data/sample/deepspeech-0.6.1-models.tar.gz -r -N -c https://github.com/mozilla/DeepSpeech/releases/download/v0.6.1/deepspeech-0.6.1-models.tar.gz 
wget -O /data/sample/audio-0.6.1.tar.gz -r -N -c https://github.com/mozilla/DeepSpeech/releases/download/v0.6.1/audio-0.6.1.tar.gz
cd /data/sample
tar xvf deepspeech-0.6.1-models.tar.gz
tar xvf audio-0.6.1.tar.gz

mkdir /data/server_config
wget -O /data/server_config/en_config.json https://raw.githubusercontent.com/bodaay/MyDeepSpeech/master/server/configs/en_config.json
wget -O /data/server_config/ar_config.json https://raw.githubusercontent.com/bodaay/MyDeepSpeech/master/server/configs/ar_config.json
wget -O /data/server_config/de_config.json https://raw.githubusercontent.com/bodaay/MyDeepSpeech/master/server/configs/de_config.json
wget -O /data/server_config/fr_config.json https://raw.githubusercontent.com/bodaay/MyDeepSpeech/master/server/configs/fr_config.json
