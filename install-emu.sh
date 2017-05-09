#!/bin/bash

commandExists() {
	return $(command -v $1 >/dev/null 2>&1);
}

isDebianDistrib() {
	commandExists "apt-get"
}
isRoot() {
	if [[ $EUID -ne 0 ]]; then
		return 1
	else
		return 0
	fi
}

packageExistInApt() {
	$(apt-cache search --names-only '$1')
	return $?
}


libInstalled() {
	SHARED_LIB_EXIST=$(ldconfig -p | grep -F "$1." >/dev/null; echo $?)
	STATIC_USR_LIB_EXIST=$(ls /usr/lib | grep -F "$1." >/dev/null; echo $?)
	STATIC_USR_LOCAL_LIB_EXIST=$(ls /usr/local/lib | grep -F "$1." >/dev/null; echo $?)

	if [ "$SHARED_LIB_EXIST" == "0" ] || [ "$STATIC_USR_LIB_EXIST" == "0" ] || [ "$STATIC_USR_LOCAL_LIB_EXIST" == "0" ]; then
		return 0
	else
		return 1
	fi
}
headerInstalled() {
	if [ -f /usr/include/$1 ] || [ -f /usr/local/include/$1 ]; then
		return 0
	else
		return 1
	fi
}

getLibHeaderEmu() {
	PORTLIBNAME=$1
	RET=""
	I=0
	for name in ${_PORTLIBS[@]}; do
		if [ "$name" == "$PORTLIBNAME" ]; then
			RET=${_PORTLIBS_FILE_H_EMU[I]}
			break
		fi
		((I++))
	done
	echo $RET
}

getLibNameEmu() {
	PORTLIBNAME=$1
	RET=""
	I=0
	for name in ${_PORTLIBS[@]}; do
		if [ "$name" == "$PORTLIBNAME" ]; then
			RET=${_PORTLIBS_FILE_EMU[I]}
			break
		fi
		((I++))
	done
	echo $RET
}

getPkgLib() {
	PORTLIBNAME=$1
	RET=""
	I=0
	for name in ${_PORTLIBS[@]}; do
		if [ "$name" == "$PORTLIBNAME" ]; then
			RET=${_PORTLIBS_DPKG[I]}
			break
		fi
		((I++))
	done
	echo $RET
}
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

PORTLIBS+=("sfml" "glew" "qt5" "openal" "gtest" "mbedtls")

########################################
# Checking libs installed
########################################

printf "Checking if dependencies for cpp3ds-emu are installed...\n"

LIB_TO_INSTALLED=()
for namePortlib in ${PORTLIBS[@]}; do
    filenameLib=$(getLibNameEmu $namePortlib)
	filenameHeaderLib=$(getLibHeaderEmu $namePortlib)

	printf "Checking if lib ${PORTLIBS[i]} and its headers are installed..."
	if [ "$filenameLib" == "" ]; then
		printf "error\nCouldn't found lib $namePortlib in definitions.\n"
		continue
	fi
	LIB_INSTALLED=0
	# gtest special case, no libs are installed, just source
	if [ "$namePortlib" == "gtest" ]; then
		if [ -d /usr/src/gtest ] || [ -d /usr/local/src/gtest ]; then
			LIB_INSTALLED=1
		fi
	else
		if libInstalled $filenameLib; then
			if [ "$filenameHeaderLib" != "" ] && headerInstalled $filenameHeaderLib; then
				LIB_INSTALLED=1
			elif [ "$filenameHeaderLib" == "" ]; then
				LIB_INSTALLED=1
			fi
		fi
	fi
	if [ $LIB_INSTALLED -eq 1 ]; then
		printf "yes\n"
	else
		LIB_TO_INSTALLED+=("$namePortlib")
		printf "no\n"
	fi
	((i++))
done

########################################
# Install lib if root and debian distro
# Show command if not root and debian distro
# Show lib to install if none
########################################

if [ ${#LIB_TO_INSTALLED} -gt 0 ]; then
	if isDebianDistrib; then
		PKG_LIST=""
		MISSING_PACKAGES=()
		for namePortlib in ${LIB_TO_INSTALLED[@]}; do
			pkgLib=$(getPkgLib $namePortlib)
			if packageExistInApt $pkgLib; then
				PKG_LIST="$PKG_LIST $pkgLib"
			else
				MISSING_PACKAGES+=("$namePortlib")
			fi
		done
		if isRoot; then
			printf "Installing lib with apt-get..."
			apt-get install -y $PKG_LIST
			if [ $? -eq 0 ]; then
				printf "Installing lib with apt-get... ok\n"
			else
				printf "Installing lib with apt-get... error.\nSome packages were not installed.\n"
			fi
		else
			printf "\nPlease run this script as root or run the following command as root : \n"
			printf "apt-get install -y $PKG_LIST\n"
		fi

		if [ ${#MISSING_PACKAGES} -gt 0 ]; then
			printf "\n\n!!!!!!!!!\nSome packages are missing in your apt repository.\nPlease install manually those lib : ${MISSING_PACKAGES[@]}"
		fi
	else
		printf "Please install the following libs and their headers manually : ${LIB_TO_INSTALLED[@]}\n"
	fi
else
	printf "\nAll necessary libs are already installed in your system.\n"
fi
