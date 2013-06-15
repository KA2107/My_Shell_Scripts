#!/usr/bin/env bash

set -x -e

_SOURCE_CODES_DIR="${__SOURCE_CODES_PART__}/Source_Codes"

_WD="${_SOURCE_CODES_DIR}/Firmware/UEFI/TianoCore_Sourceforge"

source "${_WD}/tianocore_uefi_common.sh"

_UDK_BUILD_OUTER_DIR="${_UDK_DIR}/Build/Emulator/"
_UDK_BUILD_DIR="${_UDK_BUILD_OUTER_DIR}/DEBUG_GCC46/"

_EMULATORPKG_UNIX_X86_64_DIR="${_BACKUP_BUILDS_DIR}/EMULATORPKG_UNIX_X64_BUILD"

_COMPILE_EMULATORPKG_UNIX_X86_64() {
	
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
	
	sed 's|TARGET_TOOLS=GCC47|TARGET_TOOLS=GCC46|g' -i "${_UDK_DIR}/EmulatorPkg/build.sh" || true
	
	echo
	
	# sed 's%gEmulatorPkgTokenSpaceGuid.PcdEmuMemorySize|L"64!64"|VOID*|0x0000100c%gEmulatorPkgTokenSpaceGuid.PcdEmuMemorySize|L"64!64"|VOID*|0x00008000%g' -i "${_UDK_DIR}/EmulatorPkg/EmulatorPkg.dec"
	
	echo
	
	cd "${_UDK_DIR}/EmulatorPkg/"
	"${_UDK_DIR}/EmulatorPkg/build.sh" -a "X64" -b "DEBUG" -t "GCC46" -D "BUILD_NEW_SHELL"
	
	echo
	
	cp -rf "${_UDK_BUILD_DIR}" "${_EMULATORPKG_UNIX_X86_64_DIR}"
	
	echo
	
	_UDK_BUILD_CLEAN
	
	echo
	
	# _SET_PYTHON3
	
	echo
	
}

echo

_COMPILE_EMULATORPKG_UNIX_X86_64

echo

unset _SOURCE_CODES_DIR
unset _WD
unset _UDK_DIR
unset _UDK_BUILD_TOOLS_DIR
unset _UDK_C_SOURCE_DIR
unset EDK_TOOLS_PATH
unset _EMULATORPKG_UNIX_X86_64_DIR
unset _BACKUP_BUILDS_DIR
unset _MAIN_BRANCH

set +x +e
