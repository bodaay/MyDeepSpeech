# MyDeepSpeech

docker run --gpus all -it -v /data:/data bodaay/mydeepspeech:1.0 /bin/bash

# Download My Scripts File

wget -O DownloadMyScripts.sh https://raw.githubusercontent.com/bodaay/MyDeepSpeech/master/DownloadMyScripts.sh && chmod +x DownloadMyScripts.sh

# Run My Scripts:
/DeepSpeech/DownloadMyScripts.sh


# Deepspeech Server from: https://github.com/MainRo/deepspeech-server

# Convert Any Audio File to 16khz Mono
ffmpeg -i source.mp3 -acodec pcm_s16le -ac 1 -ar 16000 out.wav
