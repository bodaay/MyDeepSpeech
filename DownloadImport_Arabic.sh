#!/bin/bash
language="ar"
tarFileName="$language.tar.gz"
DownloadBaseLink="https://voice-prod-bundler-ee1969a6ce8178826482b88e843c335139bd3fb4.s3.amazonaws.com/cv-corpus-4-2019-12-10"
mkdir -p /deepspeech/data/CV
wget -O /deepspeech/data/CV/$tarFileName $DownloadBaseLink/$tarFileName
cd /deepspeech/data/CV/
tar xzvf $tarFileName
cd /deepspeech/DeepSpeech
bin/import_cv2.py /deepspeech/data/CV/$language/


