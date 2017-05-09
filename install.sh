#!/bin/bash

############################################
# Installer script for cpp3ds development
#
# Install all tools and libs needed for app to be working
# The script will grab a copy of latest
# libs needed for development
#
# It includes:
# - devkitARM (v46)
# - ctrulib (1.2.1)
# - citro3d (1.2.0)
# - 3dstools (for linux)
# - cpp3ds (0.4.0)
# - portlibs
#
# It will also add environment var on ~/.profile if the user
# want
#
# Needed libs can be configured in install.var.sh
#
# Version: 1.0
############################################

VERSION_CTRULIB="1.2.1"
VERSION_CITRO3D="1.2.0"

DIR_INSTALL="$HOME/devkitPro"

DEVKITARM_DOWNLOAD="https://sourceforge.net/projects/devkitpro/files/devkitARM/devkitARM_r46/devkitARM_r46-x86_64-linux.tar.bz2/download"
LIBCTRU_DOWNLOAD="https://sourceforge.net/projects/devkitpro/files/libctru/1.2.1/libctru-1.2.1.tar.bz2/download"
LIBCITRO3D_DOWNLOAD="https://sourceforge.net/projects/devkitpro/files/citro3d/1.2.0/citro3d-1.2.0.tar.bz2/download"
TOOLS_3DS_DOWNLOAD="https://github.com/cpp3ds/3ds-tools/releases/download/r6/3ds-tools-linux-r6.tar.gz"
CPP3DS_DOWNLOAD="https://github.com/Naxann/cpp3ds/releases/download/v0.4/cpp3ds-0.4.0-linux-x64.tar.gz"
SHELL_PROFILE=~/.profile

SHELL_PROFILE_CHANGED=0
SETUP_ENVIRONMENT_DEVKITARM="setted"
SETUP_ENVIRONMENT_CPP3DS="setted"
AUTO_CHANGE_SHELL_PROFILE=0

PORTLIBS_MUST_GET=()
PORTLIBS_HAVE_TO_GET=0

BUILD_COMMANDS_REQUIREMENT=("make" "cmake" "pkg-config" "git")

TOOLS_3DS_EXECUTABLES=("3dsxtool" "bannertool" "makerom" "nihstro-assemble" "nihstro-disassemble")
BASEDIR=$(dirname "$0")

source $BASEDIR/install.portlibs.sh

FILENAME_VAR=.install-dev3DS-dependencies.sh

if [ -f $FILENAME_VAR ]; then # In current directory
	FILEPATH_VARS=./$FILENAME_VAR
elif [ -f $BASEDIR/../$FILENAME_VAR ]; then # In script parent directory
	FILEPATH_VARS=$BASEDIR/../$FILENAME_VAR
elif [ -f $BASEDIR/$FILENAME_VAR ]; then # In script directory
	FILEPATH_VARS=$BASEDIR/$FILENAME_VAR
elif [ -f "$1" ]; then # as an argument
	$FILEPATH_VARS=$1
else
	printf "Error ! File $FILENAME_VAR was not found.\n"
	printf "Please pass $FILENAME_VAR as an argument.\n"
	exit
fi

source $FILEPATH_VARS


commandExists() {
	return $(command -v $1 >/dev/null 2>&1);
}

hasEnvironmentShellProfile() {
	return $(test -f ~/.profile;echo $?)
}

libctru_libpath() {
	echo $DEVKITPRO/libctru/lib/libctru.a
}
citro3d_libpath() {
	echo $DEVKITPRO/libctru/lib/libcitro3d.a
}

getDownloadLinkPortlib() {
	PORTLIBNAME=$1
	RET=""
	I=0
	for name in ${_PORTLIBS[@]}; do
		if [ "$name" == "$PORTLIBNAME" ]; then
			RET=${_PORTLIBS_LINK[I]}
			break
		fi
		((I++))
	done
	echo $RET
}
getFilenamePortlib() {
	PORTLIBNAME=$1
	RET=""
	I=0
	for name in ${_PORTLIBS[@]}; do
		if [ "$name" == "$PORTLIBNAME" ]; then
			RET=${_PORTLIBS_FILE[I]}
			break
		fi
		((I++))
	done
	echo $RET
}


hasRequirementsBuild() {
	HAS_REQUIREMENTS=0
	for commandName in ${PORTLIBS_COMMANDS_REQUIREMENT[@]}
	do
		if ! commandExists $commandName; then
			HAS_REQUIREMENTS=1
			break
		fi
	done
	return $HAS_REQUIREMENTS;
}

hasRequirementsFullInstall() {
	return hasRequirements3dsTools
}

functionExistsInLib() {
	NM=$DEVKITARM/bin/arm-none-eabi-nm
	$($NM $1 | grep " T $2\$" >/dev/null 2>&1)
	return $?
}

isLibCtru_121() {
	functionExistsInLib $(libctru_libpath) NIMS_StartDownload && functionExistsInLib $(libctru_libpath) GPUCMD_Finalize
}

hasDevKitPRO() {
	return $(test -d "$DEVKITPRO";echo $?)
}

hasCPP3DS() {
	LIBS=("libcpp3ds-audio.a" "libcpp3ds-graphics.a" "libcpp3ds-network.a" "libcpp3ds-system.a" "libcpp3ds-window.a")
	HAS_CPP3DS=0
	for lib in ${LIBS[@]}; do
		if [ ! -f $CPP3DS/lib/$lib ]; then
			HAS_CPP3DS=1
		fi
	done
	return $HAS_CPP3DS
}
hasDevKitARM() {
	return $(test -d "$DEVKITARM";echo $?)
}

hasLibCtru() {
	return $(test -f $(libctru_libpath);echo $?)
}

hasLibCitro3D() {
	return $(test -f $(citro3d_libpath);echo $?)
}

download() {
	wget -q --show-progress --no-check-certificate -O "$1" "$2"
}

installLibCtru() {
	checkWGetAndExit
	PATH_DOWNLOAD=$(mktemp)
	DIR_LIBCTRU=$DEVKITPRO/libctru
	printf "Downloading libctru $VERSION_CTRULIB...\n"
	download $PATH_DOWNLOAD $LIBCTRU_DOWNLOAD
	if [ ! $? -eq 0 ]; then
		printf "Couldn't download libctru. Exiting installation...\n"
		exit
	fi
	mkdir -p $DIR_LIBCTRU
	printf "Extracting libctru in $DIR_LIBCTRU..."
	tar -xaf $PATH_DOWNLOAD -C "$DIR_LIBCTRU"
	rm -rf $PATH_DOWNLOAD
	printf "done!\n"

}

installLibCitro3D() {
	checkWGetAndExit
	PATH_DOWNLOAD=$(mktemp)
	DIR_LIBCTRU=$DEVKITPRO/libctru
	printf "Downloading citro3D $VERSION_CITRO3D...\n"
	download $PATH_DOWNLOAD $LIBCITRO3D_DOWNLOAD
	if [ ! $? -eq 0 ]; then
		printf "Couldn't download citro3D. Exiting installation...\n"
		exit
	fi
	mkdir -p $DIR_LIBCTRU
	printf "Extracting citro3D in $DIR_LIBCTRU..."
	tar -xaf $PATH_DOWNLOAD -C "$DIR_LIBCTRU"
	rm -rf $PATH_DOWNLOAD
	printf "done!\n"
}

installDevKitARM() {
	checkWGetAndExit
	PATH_DOWNLOAD=$(mktemp)
	printf "Downloading devkitARM...\n"
	download $PATH_DOWNLOAD $DEVKITARM_DOWNLOAD
	if [ ! $? -eq 0 ]; then
		printf "Couldn't download devkitARM. Exiting installation...\n"
		exit
	fi
	mkdir -p "$DIR_INSTALL"
	printf "Extracting devkitARM in $DIR_INSTALL..."
	tar -xaf $PATH_DOWNLOAD -C "$DIR_INSTALL"
	printf "done !\n"

	SETUP_ENVIRONMENT_DEVKITARM="manual"

	if hasEnvironmentShellProfile && [ $AUTO_CHANGE_SHELL_PROFILE -eq 1 ]; then
		SETUP_ENVIRONMENT_DEVKITARM="auto"
		SHELL_PROFILE_CHANGED=1
	fi
	rm -rf $PATH_DOWNLOAD

}

checkWGetAndExit() {
	if ! commandExists "wget"; then
		printf "Please install the package containing wget command and retry the installation\n"
		exit
	fi
}

lackEnvironmentVariable() {
	if [ "$CPP3DS" == "" ] || [ "$DEVKITARM" == "" ] || [ "$DEVKITPRO" == "" ]; then
		return 0
	else
		return 1
	fi
}

lack3dsTools() {
	HAS_ALL_TOOLS=1
	for executableName in ${TOOLS_3DS_EXECUTABLES[@]}
	do
		if [ ! -f "$DEVKITARM/bin/$executableName" ]; then
			HAS_ALL_TOOLS=0
			break
		fi
	done
	return $HAS_ALL_TOOLS;
}

###############################
# Installation of devkitARM
# wget-only
###############################

if lackEnvironmentVariable && hasEnvironmentShellProfile; then
while true; do
	read -p "Do you want the script to add environment variable directly in your $SHELL_PROFILE? " yn
		case $yn in
			[Yy]* ) AUTO_CHANGE_SHELL_PROFILE=1; break;;
			[Nn]* ) break;;
			* ) printf "Please answer yes or no.\n";;
		esac
done
fi

# First we are exporting if environment values are not set to check if the script worked before
IS_LACKING_ENV_DEVKIT=0
if [ "$DEVKITPRO" == "" ]; then
	export DEVKITPRO=$DIR_INSTALL
	IS_LACKING_ENV_DEVKIT=1
fi
if [ "$DEVKITARM" == "" ]; then
	export DEVKITARM=$DEVKITPRO/devkitARM
	IS_LACKING_ENV_DEVKIT=1
fi

if hasEnvironmentShellProfile && [ $AUTO_CHANGE_SHELL_PROFILE -eq 1 ] && [ $IS_LACKING_ENV_DEVKIT -eq 1 ]; then
	SETUP_ENVIRONMENT_DEVKITARM="auto"
	SHELL_PROFILE_CHANGED=1
fi

printf "Checking devkitPRO..."
if hasDevKitPRO; then
	printf "installed.\n"
	DIR_INSTALL=$DEVKITPRO
else
	printf "not installed.\n"
fi

printf "Checking devkitARM..."
if hasDevKitARM; then
	printf "installed.\n"
else
	printf "not installed.\n"
	while true; do
		read -p "devkitARM is likely not installed, or path is broken. Do you wish to install it ? " yn
		case $yn in
			[Yy]* ) installDevKitARM; break;;
			[Nn]* ) break;;
			* ) echo "Please answer yes or no.";;
		esac
	done
fi

########################################
# Installation of ctrulib and citro3d
# wget-only
########################################

printf "Checking ctrulib..."
if hasLibCtru; then
	printf "installed.\n"
	printf "Checking ctrulib version ..."
	if ! isLibCtru_121; then
		printf "error\nThe current libctru installed is not the version $VERSION_CTRULIB\n"
		printf "citro3d $VERSION_CITRO3D and cpp3ds work only with libctru-$VERSION_CTRULIB\n"
		printf "Remove libctru directory in $DEVKITPRO or install the $VERSION_CTRULIB by yourself.\n"
		exit
	fi
	printf "$VERSION_CTRULIB ok\n"
else
	printf "not installed.\n"
	if ! commandExists "wget"; then
		printf "Please install the package containing wget command and retry the installation\n"
		exit
	fi
	installLibCtru
fi

printf "Checking citro3d..."

if hasLibCitro3D; then
	printf "installed.\n"
else
	printf "not installed.\n"
	if ! commandExists "wget"; then
		printf "Please install the package containing wget command and retry the installation\n"
		exit
	fi
	installLibCitro3D
fi

########################################
# Copying / downloading cpp3ds
########################################

printf "Checking if CPP3DS environment var is set..."
if [ "$CPP3DS" == "" ]; then
	printf "no\n"
	export CPP3DS=$DEVKITPRO/cpp3ds
	mkdir -p $CPP3DS

	SETUP_ENVIRONMENT_CPP3DS="manual"
	if hasEnvironmentShellProfile && [ $AUTO_CHANGE_SHELL_PROFILE -eq 1 ]; then
		SETUP_ENVIRONMENT_CPP3DS="auto"
		SHELL_PROFILE_CHANGED=1
	fi
else
	printf "yes\n"
fi

mkdir -p $CPP3DS
mkdir -p $CPP3DS/lib
mkdir -p $CPP3DS/include
mkdir -p $CPP3DS/cmake
printf "Checking type of installation..."
if [ ! -d "$BASEDIR/../src/" ] && [ "$IS_CPP3DS" == "1" ]; then
	# We are installing a release

	printf "release\n"
	printf "yes\Installing cpp3ds in $CPP3DS..."
	cp -r $BASEDIR/lib $CPP3DS/
	cp -r $BASEDIR/include $CPP3DS/
	cp -r $BASEDIR/cmake $CPP3DS/
	cp -r $BASEDIR/portlibs/* $DEVKITPRO/portlibs/armv6k/
	printf "ok\n"
elif [ "$IS_CPP3DS" != "1" ]; then
	printf "from app\n"
	printf "Checking if CPP3DS is installed..."
	if hasCPP3DS; then
		printf "yes\n"
	else
		printf "no\n"
		printf "Dowloading cpp3ds...\n"
		PATH_DOWNLOAD=$(mktemp)
		DIR_DOWNLOAD=$(mktemp -d)

		download $PATH_DOWNLOAD $CPP3DS_DOWNLOAD
		if [ ! $? -eq 0 ]; then
			printf "error. cpp3ds link can't be accessed and download. Exiting installation."
			exit
		fi

		tar -xaf $PATH_DOWNLOAD -C "$DIR_DOWNLOAD"

		printf "Installing cpp3ds in $CPP3DS..."
		cp -r $DIR_DOWNLOAD/cpp3ds/lib $CPP3DS/
		cp -r $DIR_DOWNLOAD/cpp3ds/include $CPP3DS/
		cp -r $DIR_DOWNLOAD/cpp3ds/cmake $CPP3DS/
		cp -r $DIR_DOWNLOAD/cpp3ds/portlibs/* $DEVKITPRO/portlibs/armv6k/
		printf "ok\n"

		rm -r $DIR_DOWNLOAD
		rm -r $PATH_DOWNLOAD
	fi
fi

########################################
# Copying / downloading portlibs
########################################

mkdir -p $DEVKITPRO/portlibs
mkdir -p $DEVKITPRO/portlibs/armv6k

# First we copy portlibs. portlibs are present on a cpp3ds release to avoid compiling and downloading
printf "Checking presence of portlibs in parent directory..."
if [ -d "../portlibs" ]; then
	printf "yes\nCopying portlibs in \$DEVKITPRO/portlibs/armv6k/..."
	cp -r "../portlibs/*" "$DEVKITPRO/portlibs/armv6k"
	printf "yes\n"
else
	printf "no\n"
fi

# Then we check if we have the libs
i=0
for namePortlib in ${PORTLIBS[@]}; do
    filenameLib=$(getFilenamePortlib $namePortlib)

	printf "Checking portlibs ${PORTLIBS[i]} ($filenameLib)..."

	if [ -f "$DEVKITPRO/portlibs/armv6k/lib/$filenameLib" ]; then
		printf "yes\n"
		PORTLIBS_MUST_GET[i]=0
	else
		printf "no\n"
		PORTLIBS_MUST_GET[i]=1
		PORTLIBS_HAVE_TO_GET=1
	fi
	((i++))
done

if [ $PORTLIBS_HAVE_TO_GET -eq 1 ]; then
	printf "Some portlibs are not present and need to be downloaded\n"
	i=0
	DOWNLOADS_DONE=()
	DIR_PORTLIBS=$DEVKITPRO/portlibs/armv6k
	for namePortlib in ${PORTLIBS[@]}; do
		if [ "${PORTLIBS_MUST_GET[i]}" == "1" ]; then
			downloadLink=$(getDownloadLinkPortlib $namePortlib)

			# Checking if download is not already done (same portlib)

			ALREADY_DONE=0
			for download in ${DOWNLOADS_DONE[@]}; do
				if [ "$download" == "$downloadLink" ]; then
					ALREADY_DONE=1
					break
				fi
			done

			if [ $ALREADY_DONE -eq 1 ]; then
				((i++))
				continue
			fi
			printf "Downloading $namePortlib...\n"
			DOWNLOADS_DONE+=($downloadLink)
			PATH_DOWNLOAD=$(mktemp)
			download $PATH_DOWNLOAD $downloadLink
			if [ ! $? -eq 0 ]; then
				printf "Can't download portlib $namePortlib. Exiting script.\n"
				exit
			fi
			printf "Extracting portlib $namePortlib in \$DEVKITPRO/portlibs..."
			tar -xaf $PATH_DOWNLOAD -C "$DIR_PORTLIBS"
			printf "ok\n"
		fi
		((i++))
	done
fi

########################################
# Getting last 3dstools already compiled
########################################

printf "Checking if complementary 3ds tools are installed..."

if lack3dsTools; then
	printf "no\n"
	printf "Download last executables of 3dstools for Linux...\n"
	checkWGetAndExit
	PATH_DOWNLOAD=$(mktemp)
	download $PATH_DOWNLOAD $TOOLS_3DS_DOWNLOAD
	if [ ! $? -eq 0 ]; then
		printf "Couldn't download 3dstools. Exiting installation...\n"
		exit
	fi
	printf "Extracting 3dstools in \$DEVKITARM/bin..."
	tar -xaf $PATH_DOWNLOAD -C "$DEVKITARM/bin" --strip 1
	printf "ok\n"
	rm $PATH_DOWNLOAD
else
	printf "yes\n"
fi


########################################
# Finalizing script
########################################


printf "\n"
if [ $SHELL_PROFILE_CHANGED -eq 1 ]; then
	printf "\n## Environment variable for developing 3DS Homebrew\n" >> $SHELL_PROFILE

	if [ "$SETUP_ENVIRONMENT_DEVKITARM" == "auto" ]; then
		printf "export DEVKITPRO=$DIR_INSTALL\n" >> $SHELL_PROFILE
		printf "export DEVKITARM=\$DEVKITPRO/devkitARM\n" >> $SHELL_PROFILE
		printf "Environment variable \$DEVKITARM and \$DEVKITPRO added to your $SHELL_PROFILE.\n"
	fi
	if [ "$SETUP_ENVIRONMENT_CPP3DS" == "auto" ]; then
		printf "export CPP3DS=\$DEVKITPRO/cpp3ds\n" >> $SHELL_PROFILE
		printf "Environment variable \$CPP3DS added to your $SHELL_PROFILE.\n\n"
	fi

	printf "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n"
	printf "Your $SHELL_PROFILE was modified. Please refresh your shell with the following command for environment var to be set : \n"
	printf "source $SHELL_PROFILE\n"
	printf "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n\n"
fi

if [ $SETUP_ENVIRONMENT_DEVKITARM == "manual" ] || [ $SETUP_ENVIRONMENT_CPP3DS == "manual" ]; then
	printf "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n"
	printf "Set the following environment variables to these values : \n"
	if [ $SETUP_ENVIRONMENT_DEVKITARM == "manual" ]; then
		printf "DEVKITPRO=$DEVKITPRO\n"
		printf "DEVKITARM=$DEVKITPRO/devkitARM\n"
	fi
	if [ $SETUP_ENVIRONMENT_CPP3DS == "manual" ]; then
		printf "CPP3DS=$DEVKITPRO/cpp3ds\n"
	fi
	printf "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n\n"
fi

printf "Installation of cpp3ds done !\n"
printf "If you want to compile the emulation, run install-emu.sh\n"
