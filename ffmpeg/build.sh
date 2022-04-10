#!/bin/bash
#
## docs:
# https://gist.github.com/johzzy/d6d3503df2d0b9d0a0d44cc9b7874ed8
# https://github.com/ksvc/FFmpeg/wiki/hevcpush
#
## usage:
# git clone https://github.com/johzzy/ffmpeg FFmpeg
# ./build.sh johnny/colorful
#
## FFmpeg
# git:(master) git checkout johnny/colorful
# git:(johnny/colorful) git rebase master
# branch:
# -   master
#     -  johnny/colorful
# 
# build
# ./build.sh master
#       - a487635b85 ok 
#       - 072101bd52 ok
#
# ./build.sh johnny/colorful
#       - 0d9b275eb7 ok
#       - 011c33931a ?
#

set -e

curr_dir=$(cd $(dirname $0); pwd)
cd ${curr_dir}/FFmpeg

branch=${1}

case $branch in
        master)
                ext_configure=''
                ;;
        johnny/colorful)
                ext_configure='--enable-encoder=libx265  --enable-libx265 --enable-encoder=libopus --enable-decoder=libopus --enable-libopus'
                ;;
        *)
                echo "param 'master' or 'johnny/colorful'"
                exit -1
esac

echo $ext_configure
git status
git checkout $branch

./configure --prefix=$(cd ..; echo $(pwd)/out) --enable-static --enable-pic --enable-gpl \
        --disable-encoders --enable-encoder=aac --enable-encoder=libx264  --enable-libx264  \
        --disable-decoders --enable-decoder=aac --enable-decoder=h264 --enable-decoder=hevc  \
        --disable-demuxers --enable-demuxer=aac --enable-demuxer=mov --enable-demuxer=mpegts \
        --enable-demuxer=flv --enable-demuxer=h264 --enable-demuxer=hevc --enable-demuxer=hls  \
        --disable-muxers --enable-muxer=h264  --enable-muxer=flv --enable-muxer=f4v  --enable-muxer=mp4 \
        --disable-doc ${ext_configure}

make -j8
make install