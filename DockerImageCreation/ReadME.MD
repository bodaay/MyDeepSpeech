docker build -t bodaay/mydeepspeech:1.0 .


docker push bodaay/mydeepspeech:1.0

# Test
docker run --gpus all -it bodaay/mydeepspeech:1.0 deepspeech --version && nvidia-smi
