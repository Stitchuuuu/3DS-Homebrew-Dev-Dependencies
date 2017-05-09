#!/bin/bash

#############################################
# Script containing informations about portlibs:
# - name of the compiled lib file
# - direct download link
# - deb pkg corresponding for emulation mode
#
# Version: 1.0
#############################################

_PORTLIBS=()
_PORTLIBS_FILE=()
_PORTLIBS_FILE_EMU=()
_PORTLIBS_LINK=()
_PORTLIBS_DPKG=()

### Only for PC
_PORTLIBS+=("sfml");             _PORTLIBS_FILE+=("");                 _PORTLIBS_LINK+=("");                                                                                          _PORTLIBS_FILE_EMU+=("libsfml-system");    _PORTLIBS_FILE_H_EMU+=("SFML/Main.hpp");             _PORTLIBS_DPKG+=("libsfml-dev");
_PORTLIBS+=("glew");             _PORTLIBS_FILE+=("");                 _PORTLIBS_LINK+=("");                                                                                          _PORTLIBS_FILE_EMU+=("libGLEW");           _PORTLIBS_FILE_H_EMU+=("GL/glew.h");                 _PORTLIBS_DPKG+=("libglew-dev");
_PORTLIBS+=("qt5");              _PORTLIBS_FILE+=("");                 _PORTLIBS_LINK+=("");                                                                                          _PORTLIBS_FILE_EMU+=("libQt5Widgets");     _PORTLIBS_FILE_H_EMU+=("");                          _PORTLIBS_DPKG+=("qt5-default");
_PORTLIBS+=("openal");           _PORTLIBS_FILE+=("");                 _PORTLIBS_LINK+=("");                                                                                          _PORTLIBS_FILE_EMU+=("libopenal");         _PORTLIBS_FILE_H_EMU+=("AL/al.h");                   _PORTLIBS_DPKG+=("libopenal-dev");
_PORTLIBS+=("gtest");            _PORTLIBS_FILE+=("");                 _PORTLIBS_LINK+=("");                                                                                          _PORTLIBS_FILE_EMU+=("gtest");             _PORTLIBS_FILE_H_EMU+=("");                          _PORTLIBS_DPKG+=("libgtest-dev");

### 3ds portlibs and equivalent in Ubuntu packages
_PORTLIBS+=("bz2");            _PORTLIBS_FILE+=("libbz2.a");           _PORTLIBS_LINK+=("https://github.com/Naxann/3ds_portlibs/releases/download/v1.0/bzip2-1.0.6.tar.gz");          _PORTLIBS_FILE_EMU+=("libbz2");            _PORTLIBS_FILE_H_EMU+=("bzlib.h");                   _PORTLIBS_DPKG+=("libbz2-dev");
_PORTLIBS+=("freetype");       _PORTLIBS_FILE+=("libfreetype.a");      _PORTLIBS_LINK+=("https://github.com/Naxann/3ds_portlibs/releases/download/v1.0/freetype-2.6.2.tar.gz");       _PORTLIBS_FILE_EMU+=("libfreetype");       _PORTLIBS_FILE_H_EMU+=("freetype2/ft2build.h");      _PORTLIBS_DPKG+=("libfreetype6-dev");
_PORTLIBS+=("jpeg");           _PORTLIBS_FILE+=("libjpeg.a");          _PORTLIBS_LINK+=("https://github.com/Naxann/3ds_portlibs/releases/download/v1.0/libjpeg-turbo-1.4.2.tar.gz");  _PORTLIBS_FILE_EMU+=("libjpeg");           _PORTLIBS_FILE_H_EMU+=("jpeglib.h");                 _PORTLIBS_DPKG+=("libjpeg-dev");
_PORTLIBS+=("ogg");            _PORTLIBS_FILE+=("libogg.a");           _PORTLIBS_LINK+=("https://github.com/Naxann/3ds_portlibs/releases/download/v1.0/libogg-1.3.2.tar.gz");         _PORTLIBS_FILE_EMU+=("libogg");            _PORTLIBS_FILE_H_EMU+=("ogg/ogg.h");                 _PORTLIBS_DPKG+=("libogg-dev");
_PORTLIBS+=("png");            _PORTLIBS_FILE+=("libpng.a");           _PORTLIBS_LINK+=("https://github.com/Naxann/3ds_portlibs/releases/download/v1.0/libpng-1.6.21.tar.gz");        _PORTLIBS_FILE_EMU+=("libpng16");          _PORTLIBS_FILE_H_EMU+=("libpng16/png.h");            _PORTLIBS_DPKG+=("libpng-dev");
_PORTLIBS+=("speex");          _PORTLIBS_FILE+=("libspeex.a");         _PORTLIBS_LINK+=("https://github.com/Naxann/3ds_portlibs/releases/download/v1.0/speex-1.2rc1.tar.gz");         _PORTLIBS_FILE_EMU+=("libspeex");          _PORTLIBS_FILE_H_EMU+=("speex/speex.h");             _PORTLIBS_DPKG+=("libspeex-dev");
_PORTLIBS+=("speexdsp");       _PORTLIBS_FILE+=("libspeexdsp.a");      _PORTLIBS_LINK+=("https://github.com/Naxann/3ds_portlibs/releases/download/v1.0/speex-1.2rc1.tar.gz");         _PORTLIBS_FILE_EMU+=("libspeexdsp");       _PORTLIBS_FILE_H_EMU+=("speex/speex_preprocess.h");  _PORTLIBS_DPKG+=("libspeexdsp-dev");
_PORTLIBS+=("archive");        _PORTLIBS_FILE+=("libarchive.a");       _PORTLIBS_LINK+=("https://github.com/Naxann/3ds_portlibs/releases/download/v1.0/libarchive-3.1.2.tar.gz");     _PORTLIBS_FILE_EMU+=("libarchive");        _PORTLIBS_FILE_H_EMU+=("archive.h");                 _PORTLIBS_DPKG+=("libarchive-dev");
_PORTLIBS+=("vorbis");         _PORTLIBS_FILE+=("libvorbis.a");        _PORTLIBS_LINK+=("https://github.com/Naxann/3ds_portlibs/releases/download/v1.0/libvorbis-1.3.5.tar.gz");      _PORTLIBS_FILE_EMU+=("libvorbis");         _PORTLIBS_FILE_H_EMU+=("vorbis/codec.h");            _PORTLIBS_DPKG+=("libvorbis-dev");
_PORTLIBS+=("vorbisfile");     _PORTLIBS_FILE+=("libvorbisfile.a");    _PORTLIBS_LINK+=("https://github.com/Naxann/3ds_portlibs/releases/download/v1.0/libvorbis-1.3.5.tar.gz");      _PORTLIBS_FILE_EMU+=("libvorbisfile");     _PORTLIBS_FILE_H_EMU+=("vorbis/vorbisfile.h");       _PORTLIBS_DPKG+=("libvorbis-dev");
_PORTLIBS+=("vorbisenc");      _PORTLIBS_FILE+=("libvorbisenc.a");     _PORTLIBS_LINK+=("https://github.com/Naxann/3ds_portlibs/releases/download/v1.0/libvorbis-1.3.5.tar.gz");      _PORTLIBS_FILE_EMU+=("libvorbisenc");      _PORTLIBS_FILE_H_EMU+=("vorbis/vorbisenc.h");        _PORTLIBS_DPKG+=("libvorbis-dev");
_PORTLIBS+=("vorbisidec");     _PORTLIBS_FILE+=("libvorbisidec.a");    _PORTLIBS_LINK+=("https://github.com/Naxann/3ds_portlibs/releases/download/v1.0/tremor-2a1a8f6.tar.gz");       _PORTLIBS_FILE_EMU+=("libvorbis");         _PORTLIBS_FILE_H_EMU+=("vorbis/codec.h");            _PORTLIBS_DPKG+=("libvorbis-dev");
_PORTLIBS+=("fmt");            _PORTLIBS_FILE+=("libfmt.a");           _PORTLIBS_LINK+=("https://github.com/Naxann/3ds_portlibs/releases/download/v1.0/fmt-3.0.1.tar.gz");            _PORTLIBS_FILE_EMU+=("libfmt");            _PORTLIBS_FILE_H_EMU+=("fmt/format.h");              _PORTLIBS_DPKG+=("libfmt3-dev");
_PORTLIBS+=("faad");           _PORTLIBS_FILE+=("libfaad.a");          _PORTLIBS_LINK+=("https://github.com/Naxann/3ds_portlibs/releases/download/v1.0/faad-2.7.tar.gz");             _PORTLIBS_FILE_EMU+=("libfaad");           _PORTLIBS_FILE_H_EMU+=("faad.h");                    _PORTLIBS_DPKG+=("libfaad-dev");
_PORTLIBS+=("z");              _PORTLIBS_FILE+=("libz.a");             _PORTLIBS_LINK+=("https://github.com/Naxann/3ds_portlibs/releases/download/v1.0/zlib-1.2.8.tar.gz");           _PORTLIBS_FILE_EMU+=("libz");              _PORTLIBS_FILE_H_EMU+=("zlib.h");                    _PORTLIBS_DPKG+=("zlib1g-dev");
_PORTLIBS+=("mbedtls");        _PORTLIBS_FILE+=("libmbedtls.a");       _PORTLIBS_LINK+=("https://github.com/Naxann/3ds_portlibs/releases/download/v1.0/mbedtls-2.2.1.tar.gz");        _PORTLIBS_FILE_EMU+=("libssl");            _PORTLIBS_FILE_H_EMU+=("openssl/ssl.h");             _PORTLIBS_DPKG+=("libssl-dev");
_PORTLIBS+=("mbedx509");       _PORTLIBS_FILE+=("libmbedx509.a");      _PORTLIBS_LINK+=("https://github.com/Naxann/3ds_portlibs/releases/download/v1.0/mbedtls-2.2.1.tar.gz");        _PORTLIBS_FILE_EMU+=("libhx509");          _PORTLIBS_FILE_H_EMU+=("openssl/x509.h");            _PORTLIBS_DPKG+=("libssl-dev");
_PORTLIBS+=("mbedcrypto");     _PORTLIBS_FILE+=("libmbedcrypto.a");    _PORTLIBS_LINK+=("https://github.com/Naxann/3ds_portlibs/releases/download/v1.0/mbedtls-2.2.1.tar.gz");        _PORTLIBS_FILE_EMU+=("libcrypto");         _PORTLIBS_FILE_H_EMU+=("openssl/crypto.h");          _PORTLIBS_DPKG+=("libssl-dev");
