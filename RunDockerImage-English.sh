#!/bin/bash
docker run --gpus all -d -it -v /data:/data -p 55580:8080 bodaay/mydeepspeech:1.0 deepspeech-server --config /data/server_config/en_config.json
