#!/bin/bash
wget -O DownloadImport_Arabic.sh https://raw.githubusercontent.com/bodaay/MyDeepSpeech/master/DownloadImport_Arabic.sh
wget -O DownloadImport_Germany.sh https://raw.githubusercontent.com/bodaay/MyDeepSpeech/master/DownloadImport_Germany.sh
wget -O DownloadImport_France.sh https://raw.githubusercontent.com/bodaay/MyDeepSpeech/master/DownloadImport_France.sh
wget -O Train_Arabic.sh https://raw.githubusercontent.com/bodaay/MyDeepSpeech/master/Train_Arabic.sh
chmod +x Train_*
chmod +x DownloadImport*
wget -O DownloadPreTrainedSamples.sh https://raw.githubusercontent.com/bodaay/MyDeepSpeech/master/DownloadPreTrainedSamples.sh
chmod +x DownloadPreTrainedSamples*
