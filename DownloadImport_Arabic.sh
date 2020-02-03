#!/bin/bash
language="ar"
tarFileName="$language.tar.gz"
path="/data"
DownloadBaseLink="https://voice-prod-bundler-ee1969a6ce8178826482b88e843c335139bd3fb4.s3.amazonaws.com/cv-corpus-4-2019-12-10"
mkdir -p $path/CV/$language
wget -O $path/CV/$language/$tarFileName -r -N -c $DownloadBaseLink/$tarFileName
cd $path/CV/$language
tar xzvf $tarFileName
cd /DeepSpeech
bin/import_cv2.py $path/CV/$language/


