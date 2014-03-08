#!/usr/bin/env bash

set -x -e

_SOURCE_CODES_DIR="${__SOURCE_CODES_PART__}/Source_Codes"

_WD="${_SOURCE_CODES_DIR}/Firmware/UEFI/TianoCore_Sourceforge"

_MAIN_BRANCH="master"

_OPENSSL_VERSION="0.9.8w"

source "${_WD}/tianocore_uefi_common.sh"

_UDK_BUILD_OUTER_DIR="${_UDK_DIR}/Build/OvmfX64/"
_UDK_BUILD_DIR="${_UDK_BUILD_OUTER_DIR}/${_TARGET}_${_COMPILER}/"

_OVMFPKG_BUILD_DIR="${_BACKUP_BUILDS_DIR}/OVMFPKG_BUILD"

_PREPARE_OPENSSL_SOURCES() {
	
	cd "${_UDK_DIR}/"
	
	bsdtar -C "${_UDK_DIR}/CryptoPkg/Library/OpensslLib/" -xf "${_WD}/openssl-${_OPENSSL_VERSION}.tar.gz"
	echo
	
	cd "${_UDK_DIR}/CryptoPkg/Library/OpensslLib/openssl-${_OPENSSL_VERSION}/"
	patch -p0 -i "${_UDK_DIR}/CryptoPkg/Library/OpensslLib/EDKII_openssl-${_OPENSSL_VERSION}.patch"
	echo
	
	cd "${_UDK_DIR}/CryptoPkg/Library/OpensslLib/"
	chmod 0755 "${_UDK_DIR}/CryptoPkg/Library/OpensslLib/Install.sh"
	"${_UDK_DIR}/CryptoPkg/Library/OpensslLib/Install.sh"
	
}

_COMPILE_OVMFPKG() {
	
	echo
	
	_UDK_BUILD_CLEAN
	
	echo
	
	cd "${_UDK_DIR}/"
	git checkout "${_MAIN_BRANCH}"
	
	echo
	
	# _COPY_BUILDTOOLS_BASETOOLS
	
	echo
	
	_SET_PYTHON2
	
	echo
	
	_APPLY_PATCHES
	
	echo
	
	_APPLY_CHANGES
	
	echo
	
	_PREPARE_OPENSSL_SOURCES
	
	echo
	
	cd "${_UDK_DIR}/OvmfPkg"
	"${_UDK_DIR}/OvmfPkg/build.sh" -a "X64" -b "${_TARGET}" -t "${_COMPILER}" -D "SECURE_BOOT_ENABLE=TRUE" -D "FD_SIZE_2MB" --enable-flash
	
	echo
	
	cp -rf "${_UDK_BUILD_DIR}" "${_OVMFPKG_BUILD_DIR}"
	
	echo
	
	_UDK_BUILD_CLEAN
	
	echo
	
	# _SET_PYTHON3
	
	echo
	
}

echo

_COMPILE_OVMFPKG

echo

unset _SOURCE_CODES_DIR
unset _WD
unset _UDK_DIR
unset _UDK_BUILD_TOOLS_DIR
unset _UDK_C_SOURCE_DIR
unset EDK_TOOLS_PATH
unset _OVMFPKG_BUILD_DIR
unset _BACKUP_BUILDS_DIR
unset _MAIN_BRANCH

set +x +e
