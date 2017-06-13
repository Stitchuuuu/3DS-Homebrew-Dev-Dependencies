Shell scripts which helps to install development dependencies for Homebrew using classic libctru or cpp3ds in Linux

* `install.sh` : install devkitARM, libctru, citro3d and portlibs needed for the project
* `install-emu.sh` : cpp3ds only, install dependencies for the emulation part of cpp3ds. Recommanded OS : XUbuntu / Ubuntu / LUbuntu 17.04+

## Implementation in a Homebrew project ##

Add this git repository as a submodule with the following command :

```bash
git submodule add https://github.com/Naxann/3DS-Homebrew-Dev-Dependencies.git dev
```
Then add a file on the root of your project called `.install-dev3DS-dependencies.sh` and configure the portlibs used :

```bash
#!/bin/bash

PORTLIBS=("sfil" "sftd" "freetype" "png" "z" "sf2d")
```

If you are using cpp3ds, add cpp3ds as the first portlib, like this :
```bash
#!/bin/bash

PORTLIBS=("cpp3ds" "mbedtls" "mbedx509" "mbedcrypto" "freetype" "png" "z")
```

**Don't add `ctrulib`, `citro3d` and `m` portlibs, they are automatically included**

## Portlibs available ##

Here is the list of the portlibs available for automatic download (portlibs are precompiled) :

| Name to use in the bash file | Library |
| ---------------------------- | ------- |
| bz2 | bzip2 1.0.6 |
| freetype | freetype 2.6.2 |
| jpeg | libjpeg-turbo 1.4.2 |
| ogg | libogg 1.3.2 |
| png | libpng 1.6.21 |
| speex | speex 1.2rc1 |
| speexdsp | speex 1.2rc1 |
| archive | libarchive 3.1.2 |
| vorbis | libvorbis 1.3.5 |
| vorbisfile | libvorbis 1.3.5 |
| vorbisenc | libvorbis 1.3.5 |
| vorbisidec | tremor |
| fmt | libfmt 3.0.1 |
| faad | libfaad2 2.7 |
| z | zlib 1.2.8 |
| mbedtls | mbedtls 2.2.1 |
| mbedx509 | mbedtls 2.2.1 |
| mbedcrypto | mbedtls 2.2.1 |
| sftd | 3ds lib for using custom font. Not available for cpp3ds |
| sf2d | 3ds lib for drawing easily 2D graphics. Not available for cpp3ds |
| sfil | 3ds lib for drawing easily image. Not available for cpp3ds |

## Usage ##

Before compiling the project, just use the command line :

```bash
./dev/install.sh
```

And if it is a cpp3ds project, and user want to compile the emulated app : 
```bash
./dev/install-emu.sh
```

## Limitation ##

At this moment, those scripts only works with **libctru 1.2.1** and **citro3d 1.2.0** but can be enhanced in the future to support older or newer version of those libs.