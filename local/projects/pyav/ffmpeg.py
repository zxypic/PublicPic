# coding=utf8
import os,sys,av
import av.datasets

def kh_music_frame(mp4_dir,outfile):
    input_file = av.open(mp4_dir)
    input_audio = next((s for s in input_file.streams if s.type=='audio'),None)
    input_video = next((s for s in input_file.streams if s.type=='video'),None)

    audio_byte = b''
    wav_container = av.open(outfile,'w')
    pcm_s16le_streams = wav_container.add_stream(codec_name ='pcm_s16le',rate = input_audio.rate)

    for packet in input_file.demux([s for s in (input_audio,input_video) if s]):
        if (packet.stream.type==b'audio'):
            for frame in packet.decode():
                print("packet.frame: %s\n" % frame)
                pcm_s16le_packet = pcm_s16le_streams.decode(frame)
                for pack in pcm_s16le_packet:
                    audio_byte += pack.tobytes()


# kh_music_frame("/Users/xnder/Desktop/1541735292311939.mp4","/Users/xnder/Desktop/go.wav")

def pyav_basic_demux(mp4_dir):
    input_file = av.open(av.datasets.curated(mp4_dir))
    output = av.open('/Users/xnder/Desktop/remuxed.wav', 'wb')

    # Make an output stream using the input as a template. This copies the stream
    # setup from one to the other.
    in_stream = input_file.streams.video[0]
    out_stream = output.add_stream(codec_name ='pcm_s16le') # ,template=in_stream

    for packet in input_file.demux(in_stream):
        print(packet)
        # We need to skip the "flushing" packets that `demux` generates.
        if packet.dts is None:
            continue
        # We need to assign the packet to the new stream.
        packet.stream = out_stream
        output.mux(packet)
    output.close()

pyav_basic_demux("/Users/xnder/Desktop/1541735292311939.mp4")