#!/usr/bin/env bash

set -x -e

_SOURCE_CODES_DIR="${__SOURCE_CODES_PART__}/Source_Codes"

_WD="${_SOURCE_CODES_DIR}/Firmware/UEFI/TianoCore_Sourceforge"

source "${_WD}/tianocore_uefi_duetpkg_common.sh"

_UDK_BUILD_OUTER_DIR="${_UDK_DIR}/Build/Clover/"
_UDK_BUILD_DIR="${_UDK_BUILD_OUTER_DIR}/RELEASE_GCC46/"

_ISO9660_BUILD_DIR="${_BACKUP_BUILDS_DIR}/ISO9660_BUILD"

_COMPILE_ISO9660() {
	
	echo
	
	_UDK_BUILD_CLEAN
	
	echo
	
	cd "${_UDK_DIR}/"
	git checkout keshav_pr
	
	echo
	
	# _COPY_BUILDTOOLS_BASETOOLS
	
	echo
	
	_SET_PYTHON2
	
	echo
	
	_APPLY_PATCHES
	
	echo
	
	_APPLY_CHANGES
	
	echo
	
	_COMPILE_BASETOOLS_MANUAL
	
	echo
	
	sed 's|TARGET_ARCH           = IA32|TARGET_ARCH           = X64|g' -i "${_UDK_DIR}/Conf/target.txt" || true
	sed 's|ACTIVE_PLATFORM       = Nt32Pkg/Nt32Pkg.dsc|ACTIVE_PLATFORM       = Clover/CloverX64.dsc|g' -i "${_UDK_DIR}/Conf/target.txt" || true
	
	echo
	
	# sed 's|^  # VBoxPkg/VBoxFsDxe/VBoxIso9660.inf|  VBoxPkg/VBoxFsDxe/VBoxIso9660.inf|g' -i "${_UDK_DIR}/OvmfPkg/OvmfPkgX64.dsc" || true
	# sed 's| -mno-mmx -mno-sse| -mno-mmx -mno-sse -DHOST_EFI|g' -i "${_UDK_DIR}/OvmfPkg/OvmfPkgX64.dsc" || true
	# sed 's|DSC_ SPECIFICATION|DSC_SPECIFICATION|g' -i "${_UDK_DIR}/VBoxPkg/VBoxPkgX64.dsc" || true
	
	echo
	
	# rm -f "${_UDK_DIR}/VBoxPkg/Include/VBox" || true
	# rm -f "${_UDK_DIR}/VBoxPkg/Include/iprt" || true
	# ln -s "${_SOURCE_CODES_DIR}/Virtual_Machines/VirtualBox_SVN_Mirror_GIT/include/VBox" "${_UDK_DIR}/VBoxPkg/Include/VBox" || true
	# ln -s "${_SOURCE_CODES_DIR}/Virtual_Machines/VirtualBox_SVN_Mirror_GIT/include/iprt" "${_UDK_DIR}/VBoxPkg/Include/iprt" || true
	
	echo
	
	# touch "${_UDK_DIR}/VBoxPkg/VBoxOSELogo/ose_logo.bmp" || true
	# sed 's|VBoxPkg/VBoxPUELLogo/puel_logo.bmp|VBoxPkg/VBoxOSELogo/ose_logo.bmp|g' -i "${_UDK_DIR}/VBoxPkg/VBoxPkg.fdf" || true
	
	echo
	
	"${EDK_TOOLS_PATH}/BinWrappers/PosixLike/build" -p "${_UDK_DIR}/Clover/CloverX64.dsc" -m "${_UDK_DIR}/Clover/VBoxFsDxe/VBoxIso9660.inf" -a X64 -b RELEASE -t GCC46
	
	echo
	
	cp -rf "${_UDK_BUILD_DIR}" "${_ISO9660_BUILD_DIR}"
	
	echo
	
	_UDK_BUILD_CLEAN
	
	echo
	
	# _SET_PYTHON3
	
	echo
	
}

echo

_COMPILE_ISO9660

echo

unset _SOURCE_CODES_DIR
unset _WD
unset _UDK_DIR
unset _UDK_BUILD_TOOLS_DIR
unset _UDK_C_SOURCE_DIR
unset EDK_TOOLS_PATH
unset _ISO9660_BUILD_DIR
unset _BACKUP_BUILDS_DIR

set +x +e
