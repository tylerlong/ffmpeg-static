#!/bin/sh

set -e
set -u

jflag=
jval=2

while getopts 'j:' OPTION
do
  case $OPTION in
  j)	jflag=1
        	jval="$OPTARG"
	        ;;
  ?)	printf "Usage: %s: [-j concurrency_level] (hint: your cores + 20%%)\n" $(basename $0) >&2
		exit 2
		;;
  esac
done
shift $(($OPTIND - 1))

if [ "$jflag" ]
then
  if [ "$jval" ]
  then
    printf "Option -j specified (%d)\n" $jval
  fi
fi

cd `dirname $0`
ENV_ROOT=`pwd`
. ./env.source

#if you want a rebuild
#rm -rf "$BUILD_DIR" "$TARGET_DIR"
mkdir -p "$BUILD_DIR" "$TARGET_DIR" "$DOWNLOAD_DIR" "$BIN_DIR"

#download and extract package
download(){
filename="$1"
if [ ! -z "$2" ];then
	filename="$2"
fi
../download.pl "$DOWNLOAD_DIR" "$1" "$filename" "$3" "$4"
#disable uncompress
CACHE_DIR="$DOWNLOAD_DIR" ../fetchurl "http://cache/$filename"
}

echo "#### FFmpeg static build ####"

#this is our working directory
cd $BUILD_DIR

download \
	"yasm-1.3.0.tar.gz" \
	"" \
	"fc9e586751ff789b34b1f21d572d96af" \
	"http://www.tortall.net/projects/yasm/releases/"

download \
	"last_x264.tar.bz2" \
	"" \
	"47c7d13d0b4ad4d46dc31c3d8e1df7b4" \
	"http://download.videolan.org/pub/x264/snapshots/"

download \
	"x265_1.9.tar.gz" \
	"" \
	"f34a1c4c660ff07511365cb0983cf164" \
	"https://bitbucket.org/multicoreware/x265/downloads/"

download \
	"master" \
	"fdk-aac.tar.gz" \
	"4c6cd99146dbe9f624da7e9d8ee72a46" \
	"https://github.com/mstorsjo/fdk-aac/tarball"

download \
	"lame-3.99.5.tar.gz" \
	"" \
	"84835b313d4a8b68f5349816d33e07ce" \
	"http://downloads.sourceforge.net/project/lame/lame/3.99"

download \
	"opus-1.1.2.tar.gz" \
	"" \
	"1f08a661bc72930187893a07f3741a91" \
	"http://downloads.xiph.org/releases/opus"

../fetchurl "http://storage.googleapis.com/downloads.webmproject.org/releases/webm/libvpx-1.4.0.tar.bz2"

download \
	"2.8.tar.gz" \
	"ffmpeg2.8.tar.gz" \
	"c02957939955fe26dbdf9fd765913141" \
	"https://github.com/FFmpeg/FFmpeg/archive/release"

echo "*** Building yasm ***"
cd $BUILD_DIR/yasm*
./configure --prefix=$TARGET_DIR --bindir=$BIN_DIR
make -j $jval
make install

echo "*** Building x264 ***"
cd $BUILD_DIR/x264*
PATH="$BIN_DIR:$PATH" ./configure --prefix=$TARGET_DIR --enable-static --disable-shared --disable-opencl
PATH="$BIN_DIR:$PATH" make -j $jval
make install

echo "*** Building x265 ***"
cd $BUILD_DIR/x265*
cd build/linux
PATH="$BIN_DIR:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$TARGET_DIR" -DENABLE_SHARED:bool=off ../../source
make -j $jval
make install

echo "*** Building fdk-aac ***"
cd $BUILD_DIR/mstorsjo-fdk-aac*
autoreconf -fiv
./configure --prefix=$TARGET_DIR --disable-shared
make -j $jval
make install

echo "*** Building mp3lame ***"
cd $BUILD_DIR/lame*
./configure --prefix=$TARGET_DIR --enable-nasm --disable-shared
make
make install

echo "*** Building opus ***"
cd $BUILD_DIR/opus*
./configure --prefix=$TARGET_DIR --disable-shared
make
make install

echo "*** Building libvpx ***"
cd $BUILD_DIR/libvpx*
PATH="$BIN_DIR:$PATH" ./configure --prefix=$TARGET_DIR --disable-examples --disable-unit-tests
PATH="$BIN_DIR:$PATH" make -j $jval
make install

# FFMpeg
echo "*** Building FFmpeg ***"
cd $BUILD_DIR/FFmpeg*
PATH="$BIN_DIR:$PATH" \
PKG_CONFIG_PATH="$TARGET_DIR/lib/pkgconfig" ./configure \
  --prefix="$TARGET_DIR" \
  --pkg-config-flags="--static" \
  --extra-cflags="-I$TARGET_DIR/include" \
  --extra-ldflags="-L$TARGET_DIR/lib" \
  --bindir="$BIN_DIR" \
  --enable-ffplay \
  --enable-ffserver \
  --enable-gpl \
  --enable-libass \
  --enable-libfdk-aac \
  --enable-libfreetype \
  --enable-libmp3lame \
  --enable-libopus \
  --enable-libtheora \
  --enable-libvorbis \
  --enable-libvpx \
  --enable-libx264 \
  --enable-libx265 \
  --enable-nonfree \
  --disable-securetransport \
  --disable-indev=qtkit \
  --disable-sdl \
  --enable-static \
  --disable-shared \
  --disable-libvorbis \
  --disable-libtheora \
  --disable-libfribidi \
  --disable-fontconfig \
  --disable-libass \
  --disable-libfreetype
PATH="$BIN_DIR:$PATH" make
make install
make distclean
hash -r
