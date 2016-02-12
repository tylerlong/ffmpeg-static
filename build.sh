#!/bin/sh

set -e
set -u

jval=4

cd `dirname $0`
ENV_ROOT=`pwd`
. ./env.sh

#if you want a rebuild
rm -rf "$BUILD_DIR" "$TARGET_DIR" "$DOWNLOAD_DIR" "$BIN_DIR"
mkdir -p "$BUILD_DIR" "$TARGET_DIR" "$DOWNLOAD_DIR" "$BIN_DIR"

#download and extract package
download() {
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

# download \
#   "master" \
#   "libass.tar.gz" \
#   "" \
#   "https://github.com/libass/libass/tarball"

# download \
#   "libffi-3.2.1.tar.gz" \
#   "" \
#   "" \
#   "ftp://sourceware.org/pub/libffi"

# download \
#   "glib-2.47.5.tar.xz" \
#   "" \
#   "" \
#   "http://ftp.gnome.org/pub/GNOME/sources/glib/2.47"

# download \
#   "harfbuzz-1.1.3.tar.bz2" \
#   "" \
#   "" \
#   "https://www.freedesktop.org/software/harfbuzz/release"

download \
  "libvorbis-1.3.5.tar.gz" \
  "" \
  "" \
  "http://downloads.xiph.org/releases/vorbis"

download \
  "libogg-1.3.2.tar.gz" \
  "" \
  "" \
  "http://downloads.xiph.org/releases/ogg"

download \
  "libtool-2.4.6.tar.gz" \
  "" \
  "" \
  "http://mirror.pregi.net/gnu/libtool"

download \
  "libpng-1.6.21.tar.gz" \
  "" \
  "" \
  "http://netassist.dl.sourceforge.net/project/libpng/libpng16/1.6.21"

# download \
#   "gettext-latest.tar.gz" \
#   "" \
#   "" \
#   "http://ftp.gnu.org/pub/gnu/gettext"

# download \
#   "freetype-2.6.3.tar.gz" \
#   "" \
#   "" \
#   "http://download.savannah.gnu.org/releases/freetype"

download \
  "SDL2-2.0.4.tar.gz" \
  "" \
  "" \
  "https://www.libsdl.org/release"

download \
  "libtheora-1.1.1.tar.bz2" \
  "" \
  "" \
  "http://downloads.xiph.org/releases/theora"

download \
  "libiconv-1.14.tar.gz" \
  "" \
  "" \
  "http://ftp.gnu.org/pub/gnu/libiconv"

download \
  "bzip2-1.0.6.tar.gz" \
  "" \
  "" \
  "http://www.bzip.org/1.0.6"

download \
  "xz-5.2.2.tar.gz" \
  "" \
  "" \
  "http://tukaani.org/xz"

download \
  "zlib-1.2.8.tar.gz" \
  "" \
  "" \
  "http://zlib.net"

download \
  "yasm-1.3.0.tar.gz" \
  "" \
  "fc9e586751ff789b34b1f21d572d96af" \
  "http://www.tortall.net/projects/yasm/releases/"

download \
  "last_x264.tar.bz2" \
  "" \
  "" \
  "http://download.videolan.org/pub/x264/snapshots/"

download \
  "master" \
  "x265.tar.gz" \
  "" \
  "https://github.com/videolan/x265/tarball"

download \
  "master" \
  "fdk-aac.tar.gz" \
  "" \
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

download \
  "libvpx-1.5.0.tar.bz2" \
  "" \
  "49e59dd184caa255886683facea56fca" \
  "http://storage.googleapis.com/downloads.webmproject.org/releases/webm"

download \
  "master" \
  "ffmpeg.tar.gz" \
  "" \
  "https://github.com/FFmpeg/FFmpeg/tarball"

# echo "*** Building libffi ***"
# cd $BUILD_DIR/libffi-*
# autoreconf -fiv
# ./configure --prefix=$TARGET_DIR --enable-static --disable-shared
# make -j $jval
# make install

echo "*** Building libvorbis ***"
cd $BUILD_DIR/libvorbis*
./configure --prefix=$TARGET_DIR --enable-static --disable-shared
make -j $jval
make install

echo "*** Building libogg ***"
cd $BUILD_DIR/libogg*
autoreconf -fiv
./configure --prefix=$TARGET_DIR --enable-static --disable-shared
make -j $jval
make install

echo "*** Building libtool ***"
cd $BUILD_DIR/libtool*
./configure --prefix=$TARGET_DIR --enable-static --disable-shared
make -j $jval
make install

echo "*** Building libpng ***"
cd $BUILD_DIR/libpng*
autoreconf -fiv
./configure --prefix=$TARGET_DIR --enable-static --disable-shared
make -j $jval
make install

# echo "*** Building gettext ***"
# cd $BUILD_DIR/gettext-*
# autoreconf -fiv
# ./configure --prefix=$TARGET_DIR --enable-static --disable-shared
# make -j $jval
# make install

# echo "*** Building glib ***"
# cd $BUILD_DIR/glib-*
# autoreconf -fiv
# ./configure --prefix=$TARGET_DIR --enable-static --disable-shared
# make -j $jval
# make install

# echo "*** Building harfbuzz ***"
# cd $BUILD_DIR/harfbuzz-*
# autoreconf -fiv
# ./configure --prefix=$TARGET_DIR --enable-static --disable-shared
# make -j $jval
# make install
#
# echo "*** Building freetype ***"
# cd $BUILD_DIR/freetype-*
# ./configure --prefix=$TARGET_DIR --enable-static --disable-shared
# make -j $jval
# make install

echo "*** Building SDL2 ***"
cd $BUILD_DIR/SDL2-*
./configure --prefix=$TARGET_DIR --enable-static --disable-shared
make -j $jval
make install

echo "*** Building libtheora ***"
cd $BUILD_DIR/libtheora-*
./configure --prefix=$TARGET_DIR --enable-static --disable-shared \
  --disable-oggtest --disable-dependency-tracking --disable-vorbistest \
  --disable-examples
make -j $jval
make install

echo "*** Building iconv ***"
cd $BUILD_DIR/libiconv-*
./configure --prefix=$TARGET_DIR --enable-static --disable-shared
make -j $jval
make install

echo "*** Building bzip2 ***"
cd $BUILD_DIR/bzip2-*
make -j $jval
make PREFIX=$TARGET_DIR && make install PREFIX=$TARGET_DIR

echo "*** Building xz utils ***"
cd $BUILD_DIR/xz-*
./configure --prefix=$TARGET_DIR --enable-static --disable-shared
make -j $jval
make install

echo "*** Building zlib ***"
cd $BUILD_DIR/zlib*
./configure --prefix=$TARGET_DIR --static
make -j $jval
make install

echo "*** Building yasm ***"
cd $BUILD_DIR/yasm*
./configure --prefix=$TARGET_DIR --bindir=$BIN_DIR --enable-static --disable-shared
make -j $jval
make install

echo "*** Building x264 ***"
cd $BUILD_DIR/x264*
PATH="$BIN_DIR:$PATH" ./configure --prefix=$TARGET_DIR --enable-static --disable-shared --disable-opencl
PATH="$BIN_DIR:$PATH" make -j $jval
make install

echo "*** Building x265 ***"
cd $BUILD_DIR/videolan-x265*
cd build/linux
PATH="$BIN_DIR:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$TARGET_DIR" -DENABLE_SHARED:bool=off ../../source
make -j $jval
make install

echo "*** Building fdk-aac ***"
cd $BUILD_DIR/mstorsjo-fdk-aac*
autoreconf -fiv # autoreconf: 'configure.ac' or 'configure.in' is required
./configure --prefix=$TARGET_DIR --enable-static --disable-shared
make -j $jval
make install

echo "*** Building mp3lame ***"
cd $BUILD_DIR/lame*
./configure --prefix=$TARGET_DIR --enable-nasm --enable-static --disable-shared
make
make install

echo "*** Building opus ***"
cd $BUILD_DIR/opus*
./configure --prefix=$TARGET_DIR --enable-static --disable-shared
make
make install

echo "*** Building libvpx ***"
cd $BUILD_DIR/libvpx*
PATH="$BIN_DIR:$PATH" ./configure --prefix=$TARGET_DIR --enable-static --disable-shared --disable-examples --disable-unit-tests
PATH="$BIN_DIR:$PATH" make -j $jval
make install

# echo "*** Building libass ***"
# cd $BUILD_DIR/libass-libass*
# autoreconf -fiv
# ./configure --prefix=$TARGET_DIR --enable-static --disable-shared
# make -j $jval
# make install
#

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
  --disable-doc \
  --disable-ffplay \
  --disable-ffserver \
  --disable-ffprobe \
  --enable-gpl \
  --enable-nonfree \
  --enable-libfdk-aac \
  --enable-libmp3lame \
  --enable-libopus \
  --enable-libtheora \
  --enable-libvorbis \
  --enable-libvpx \
  --enable-libx264 \
  --enable-libx265 \
  --disable-securetransport \
  --disable-indev=qtkit \
  --disable-xlib \
  --disable-indev=x11grab_xcb \
  --disable-indev=x11grab \
  --disable-x11grab \
  --disable-libxcb \
  --disable-libxcb-shm \
  --disable-libxcb-xfixes \
  --disable-libxcb-shape \
  --disable-libvorbis \
  --enable-static \
  --disable-shared
PATH="$BIN_DIR:$PATH" make
make install
make distclean
hash -r
