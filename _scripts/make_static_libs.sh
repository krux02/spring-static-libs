#!/bin/bash

set -e
source $(dirname $0)/make_static_libs_common.sh

# zlib
wget https://www.zlib.net/zlib-1.2.11.tar.gz
CFLAGS=$PICFLAGS ./configure --prefix ${WORKDIR}
${MAKE}
${MAKE} install

# libpng
wget https://prdownloads.sourceforge.net/libpng/libpng-1.6.34.tar.gz
CFLAGS=$PICFLAGS ${MAKE} -f scripts/makefile.linux ZLIBLIB=${LIBDIR} ZLIBINC=${INCLUDEDIR} prefix=${WORKDIR}
${MAKE} -f scripts/makefile.linux prefix=${WORKDIR} install


# libjpeg
wget http://www.ijg.org/files/jpegsrc.v9b.tar.gz
CFLAGS=$PICFLAGS ./configure --prefix ${WORKDIR}
${MAKE}
${MAKE} install

# libtiff
wget https://download.osgeo.org/libtiff/tiff-4.0.8.tar.gz
CFLAGS=$PICFLAGS ./configure --disable-lzma --disable-jbig --prefix ${WORKDIR}
${MAKE}
${MAKE} install

# libIL (DevIL)
wget https://api.github.com/repos/spring/DevIL/tarball/d46aa9989f502b89de06801925d20e53d220c1b4
${CMAKE} DevIL -DCMAKE_CXX_FLAGS="$PICFLAGS"  -DBUILD_SHARED_LIBS=0 -DCMAKE_INSTALL_PREFIX=${WORKDIR} \
	        -DPNG_PNG_INCLUDE_DIR=${INCLUDEDIR} -DPNG_LIBRARY_RELEASE=${LIBDIR}/libpng.a \
	        -DJPEG_INCLUDE_DIR=${INCLUDEDIR} -DJPEG_LIBRARY=${LIBDIR}/libjpeg.a \
	        -DTIFF_INCLUDE_DIR=${INCLUDEDIR} -DTIFF_LIBRARY_RELEASE=${LIBDIR}/libtiff.a \
	        -DZLIB_INCLUDE_DIR=${INCLUDEDIR} -DZLIB_LIBRARY_RELEASE=${LIBDIR}/libz.a \
		-DGLUT_INCLUDE_DIR=${INCLUDEDIR}
${MAKE}
${MAKE} install


# libunwind
APTGETSOURCE libunwind-dev
CFLAGS=$PICFLAGS ./configure --enable-shared=no --enable-static=yes --prefix ${WORKDIR}
${MAKE}
${MAKE} install

# glew
wget https://sourceforge.net/projects/glew/files/glew/2.1.0/glew-2.1.0.tgz
${MAKE} GLEW_PREFIX=${WORKDIR} GLEW_DEST=${WORKDIR} LIBDIR=${LIBDIR}
${MAKE} GLEW_PREFIX=${WORKDIR} GLEW_DEST=${WORKDIR} LIBDIR=${LIBDIR} install

# openssl
wget https://www.openssl.org/source/openssl-1.1.1c.tar.gz
CFLAGS=$PICFLAGS ./config no-ssl3 no-comp no-shared no-dso no-weak-ssl-ciphers no-tests no-deprecated --prefix=${WORKDIR}
${MAKE}
${MAKE} install_sw

# curl
wget https://curl.haxx.se/download/curl-7.65.3.tar.gz
CFLAGS=$PICFLAGS ./configure --disable-shared --disable-manual --disable-dict --disable-file --disable-ftp --disable-ftps --disable-gopher --disable-imap --disable-imaps --disable-pop3 --disable-pop3s --disable-rtsp --disable-smb --disable-smbs --disable-smtp --disable-smtps --disable-telnet --disable-tftp --disable-unix-sockets --with-ssl=${WORKDIR} --prefix ${WORKDIR}
${MAKE}
${MAKE} install

#libvorbis
wget https://github.com/xiph/vorbis/releases/download/v1.3.7/libvorbis-1.3.7.tar.gz
CFLAGS=$PICFLAGS ./configure --prefix ${WORKDIR} \
--enable-shared=no \
--enable-static=yes \
--disable-oggtest
${MAKE}
${MAKE} install

#libuuid
wget https://downloads.sourceforge.net/project/libuuid/libuuid-1.0.3.tar.gz
CFLAGS=$PICFLAGS ./configure --prefix ${WORKDIR} \
--enable-shared=no \
--enable-static=yes \
--disable-oggtest
${MAKE}
${MAKE} install

APTGETSOURCE liblzma-dev
if [ -f autogen.sh ]; then
  ./autogen.sh
fi
CFLAGS=$PICFLAGS ./configure --prefix ${WORKDIR} \
--enable-shared=no \
--enable-static=yes \
--disable-xz  \
--disable-xzdec  \
--disable-scripts  \
--disable-doc
#--disable-lzmadec 
#--disable-lzmainfo
#--disable-lzma-links
$MAKE
$MAKE install

#libminizip-dev
APTGETSOURCE libminizip-dev
autoreconf -i
CFLAGS=$PICFLAGS ./configure --prefix ${WORKDIR}
${MAKE}
${MAKE} install

# libogg-dev
APTGETSOURCE libogg-dev
CFLAGS=$PICFLAGS ./configure --prefix ${WORKDIR} \
--enable-shared=no \
--enable-static=yes

$MAKE
$MAKE install


# Finalize()
cd ${WORKDIR}
rm -rf ${WORKDIR}/download
rm -rf ${WORKDIR}/tmp

