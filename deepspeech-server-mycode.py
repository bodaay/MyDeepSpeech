import io
import logging
from collections import namedtuple
import scipy.io.wavfile as wav

import rx
import av
import sys
import os
import uuid
from cyclotron import Component
from cyclotron_std.logging import Log
from deepspeech import Model


Sink = namedtuple('Sink', ['speech'])
Source = namedtuple('Source', ['text', 'log'])

# Sink events
FeaturesParameters = namedtuple('FeaturesParameters', ['beam_width', 'lm_alpha', 'lm_beta'])
FeaturesParameters.__new__.__defaults__ = (500, 0.75, 1.85)

Initialize = namedtuple('Initialize', ['model', 'lm', 'trie', 'features'])
SpeechToText = namedtuple('SpeechToText', ['data', 'context'])

# Sourc eevents
TextResult = namedtuple('TextResult', ['text', 'context'])
TextError = namedtuple('TextError', ['error', 'context'])

def convert(inputstreamfile, outputstream, format,codec, channel_layout, rate):
    try:
        # set input/output locations
        inp = av.open(inputstreamfile)
        #out = av.open(f"{outputfile}", 'w')
        out = av.open(outputstream,'w')
        #out_stream = out.add_stream(f"{codec}",rate=16000)
        out_stream = out.add_stream(codec_name=codec, rate=rate)

        # resampler object details how we want to change frame information
        resampler = av.AudioResampler(
            format=av.AudioFormat(format).packed,
            layout=channel_layout,
            rate=rate
        )

 
        # decode frames and start re-encoding into new file
        for frame in inp.decode(audio=0):
            frame.pts = None  # pts is presentation time-stamp. Not relevant here.

            frame = resampler.resample(frame)  # get current working frame and re-sample it for encoding

            for p in out_stream.encode(frame):  # encode the re-sampled frame
                out.mux(p)

        out.close()

    except Exception as ex:
        exc_type, exc_obj, exc_tb = sys.exc_info()
        fname = os.path.split(exc_tb.tb_frame.f_code.co_filename)[1]
        print(exc_type, fname, exc_tb.tb_lineno)


def make_driver(loop=None):
    def driver(sink):
        ds_model = None
        log_observer = None

        def on_log_subscribe(observer, scheduler):
            nonlocal log_observer
            log_observer = observer

        def log(message, level=logging.DEBUG):
            if log_observer is not None:
                log_observer.on_next(Log(
                    logger=__name__,
                    level=level,
                    message=message,
                ))

        def setup_model(model_path, lm, trie, features):
            log("creating model {} with features {}...".format(model_path, features))
            ds_model = Model(
                model_path,
                features.beam_width)

            if lm and trie:
                ds_model.enableDecoderWithLM(
                    lm, trie,
                    features.lm_alpha, features.lm_beta)
            log("model is ready.")
            return ds_model

        def subscribe(observer, scheduler):
            def on_deepspeech_request(item):
                nonlocal ds_model

                if type(item) is SpeechToText:
                    if ds_model is not None:
                        out = None
                        try:
                            # _, audio = wav.read(io.BytesIO(item.data))
                            unique_filename = str(uuid.uuid4())
                            out='/tmp/' + unique_filename + '.wav'
                            convert(io.BytesIO(item.data),out,'s16','pcm_s16le',"mono",16000)
                            _, audio = wav.read(out)
                            # convert to mono.
                            # todo: move to a component or just a function here
                            if len(audio.shape) > 1:
                                audio = audio[:, 0]
                            text = ds_model.stt(audio)
                            log("STT result: {}".format(text))
                            observer.on_next(rx.just(TextResult(
                                text=text,
                                context=item.context,
                            )))
                        except Exception as e:
                            log("STT error: {}".format(e), level=logging.ERROR)
                            observer.on_next(rx.throw(TextError(
                                error=e,
                                context=item.context,
                            )))
                        finally:
                            if os.path.exists(out):
                                os.remove(out)
                elif type(item) is Initialize:
                    log("initialize: {}".format(item))
                    ds_model = setup_model(
                        item.model, item.lm, item.trie, item.features or FeaturesParameters())
                else:
                    log("unknown item: {}".format(item), level=logging.CRITICAL)
                    observer.on_error(
                        "Unknown item type: {}".format(type(item)))

            sink.speech.subscribe(lambda item: on_deepspeech_request(item))

        return Source(
            text=rx.create(subscribe),
            log=rx.create(on_log_subscribe),
        )

    return Component(call=driver, input=Sink)
