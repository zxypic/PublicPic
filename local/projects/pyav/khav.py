# coding=utf8
import os,sys,av
import av.datasets


def kh_music_frame(mp4_dir,outfile):
    input_file = av.open(mp4_dir)
    input_audio = next((s for s in input_file.streams if s.type=='audio'),None)
    input_video = next((s for s in input_file.streams if s.type=='video'),None)

    audio_byte = b''
    wav_container = av.open(outfile,'w')
    pcm_s16le_streams = wav_container.add_stream(rate = 44100,codec_name='wav')

    for packet in input_file.demux([s for s in (input_audio,input_video) if s]):
        if (packet.stream.type==b'audio'):
            # for frame in packet.decode():
            #     print("packet.frame: %s\n" % frame)
            #     pcm_s16le_packet = pcm_s16le_streams.decode(frame)
            #     for pack in pcm_s16le_packet:
            #         audio_byte += pack.tobytes()
            packet.stream = pcm_s16le_streams
            wav_container.mux(packet)
        wav_container.close()

kh_music_frame("/Users/xnder/Desktop/1541735292311939.mp4","/Users/xnder/Desktop/go.wav")
