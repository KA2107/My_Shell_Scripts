#!/bin/sh

set -x -e

WD="${PWD}/"

EDK2_DIR="${WD}/edk2_GIT"
EDK2_BUILD_TOOLS_DIR="${WD}/buildtools-BaseTools_GIT"

EDK2_BUILD_OUTER_DIR="${EDK2_DIR}/Build/DuetPkgX64/"
EDK2_BUILD_DIR="${EDK2_BUILD_OUTER_DIR}/RELEASE_GCC45/"

DUET_EMUVARIABLE_BUILD_DIR="${WD}/DUET_EMUVARIABLE_BUILD"
DUET_FSVARIABLE_BUILD_DIR="${WD}/DUET_FSVARIABLE_BUILD"

BOOTPART="/boot/"
EFISYS="/boot/efi/"
SYSLINUX_DIR="/usr/lib/syslinux/"

DUET_PART_FS_UUID="5FA3-2472"
DUET_PART_MP="/media/DUET"

EDK2_BUILD_CLEAN() {
	
	echo
	
	rm -rf "${EDK2_DIR}/BaseTools" || true
	rm -rf "${EDK2_DIR}/Build/DuetPkgX64" || true
	rm -rf "${EDK2_DIR}/Conf" || true
	
	echo
	
	cd "${EDK2_DIR}/"
	git reset --hard
	git checkout keshav_pr
	
	echo
	
}

COPY_BUILDTOOLS_BASETOOLS() {
	
	echo
	
	rm -rf "${EDK2_DIR}/BaseTools" || true
	cp -r "${EDK2_BUILD_TOOLS_DIR}" "${EDK2_DIR}/BaseTools"
	
	echo
	
}

CORRECT_WERROR() {
	
	echo
	
	sed -i 's|-Werror||g' "${EDK2_DIR}/BaseTools/Source/C/Makefiles"/*
	sed -i 's|-Werror||g' "${EDK2_DIR}/BaseTools/Conf/tools_def.template"
	sed -i 's|--64||g' "${EDK2_DIR}/BaseTools/Conf/tools_def.template"
	
	echo
	
}

COPY_EFILDR_DUET_PART() {
	
	echo
	
	sudo umount "${DUET_PART_MP}" || true
	sudo mount -t vfat -o rw,users,exec -U "${DUET_PART_FS_UUID}" "${DUET_PART_MP}"
	sudo rm "${DUET_PART_MP}/EFILDR20" || true
	sudo cp "${EDK2_BUILD_DIR}/FV/Efildr20" "${DUET_PART_MP}/EFILDR20"
	sudo umount "${DUET_PART_MP}"
	
	echo
	
}

COPY_UEFI_SHELL_EFISYS_PART() {
	
	echo
	
	sudo rm "${EFISYS}/shellx64.efi" || true
	sudo rm "${EFISYS}/shellx64_old.efi" || true
	
	echo
	
	sudo cp "${EDK2_DIR}/ShellBinPkg/UefiShell/X64/Shell.efi" "${EFISYS}/shellx64.efi"
	sudo cp "${EDK2_DIR}/EdkShellBinPkg/FullShell/X64/Shell_Full.efi" "${EFISYS}/shellx64_old.efi"
	
	echo
	
}

SET_PYTHON2() {
	
	echo
	
	_PYTHON_="$(which python)"
	sudo rm "${_PYTHON_}"
	sudo ln -s "$(which python2)" "${_PYTHON_}"
	unset _PYTHON_
	
	echo
	
}

SET_PYTHON3() {
	
	echo
	
	_PYTHON_="$(which python)"
	sudo rm "${_PYTHON_}"
	sudo ln -s "$(which python3)" "${_PYTHON_}"
	unset _PYTHON_
	
	echo
	
}

APPLY_PATCHES() {
	
	echo
	
	cd "${EDK2_DIR}/"
	
	# patch -Np1 -i "${WD}/EDK2_DuetPkg_Use_VS2008x86_Toolchain.patch" || true
	# patch -Np1 -i "${WD}/EDK2_DuetPkg_Efivars_Use_MdeModulePkg_Universal_Variable_EmuRuntimeDxe.patch"
	# patch -Np1 -i "${WD}/EDK2_DuetPkg_Efivars_Use_MdeModulePkg_Universal_Variable_EmuRuntimeDxe_old.patch"
	
	echo
	
	# sed -i 's|#define EFI_PAGE_BASE_OFFSET_IN_LDR 0x70000|#define EFI_PAGE_BASE_OFFSET_IN_LDR 0x72000|g' "${EDK2_DIR}/BaseTools/Source/C/GenPage/GenPage.c"
	
	echo
}

COMPILE_DUET_EMUVARIABLE_BRANCH() {
	
	echo
	
	SET_PYTHON2
	
	echo
	
	EDK2_BUILD_CLEAN
	
	echo
	
	cd "${EDK2_DIR}/"
	git checkout keshav_pr
	
	echo
	
	COPY_BUILDTOOLS_BASETOOLS
	
	echo
	
	CORRECT_WERROR
	
	echo
	
	APPLY_PATCHES
	
	echo
	
	cd "${EDK2_DIR}/DuetPkg"
	"${EDK2_DIR}/DuetPkg/build64.sh"
	
	echo
	
	cp -r "${EDK2_BUILD_DIR}" "${DUET_EMUVARIABLE_BUILD_DIR}"
	cp "${EDK2_BUILD_OUTER_DIR}/floppy.img" "${DUET_EMUVARIABLE_BUILD_DIR}/floppy.img"
	
	echo
	
	EDK2_BUILD_CLEAN
	
	echo
	
	SET_PYTHON3
	
	echo
}

COMPILE_DUET_FSVARIABLE_BRANCH() {
	
	echo
	
	SET_PYTHON2
	
	echo
	
	EDK2_BUILD_CLEAN
	
	echo
	
	cd "${EDK2_DIR}/"
	git checkout duet_fsvariable
	
	echo
	
	COPY_BUILDTOOLS_BASETOOLS
	
	echo
	
	CORRECT_WERROR
	
	echo
	
	APPLY_PATCHES
	
	echo
	
	cd "${EDK2_DIR}/DuetPkg"
	"${EDK2_DIR}/DuetPkg/build64.sh"
	
	echo
	
	cp -r "${EDK2_BUILD_DIR}" "${DUET_FSVARIABLE_BUILD_DIR}"
	cp "${EDK2_BUILD_OUTER_DIR}/floppy.img" "${DUET_FSVARIABLE_BUILD_DIR}/floppy.img"
	
	echo
	
	EDK2_BUILD_CLEAN
	
	echo
	
	SET_PYTHON3
	
	echo
}

echo

COMPILE_DUET_EMUVARIABLE_BRANCH

echo

COMPILE_DUET_FSVARIABLE_BRANCH

echo

COPY_EFILDR_DUET_PART

echo

COPY_UEFI_SHELL_EFISYS_PART

echo

cd "${WD}/"
# "${WD}/post_duet_x64_compile.sh"

echo

unset WD
unset EDK2_DIR
unset EDK2_BUILD_TOOLS_DIR
unset EDK2_BUILD_OUTER_DIR
unset EDK2_BUILD_DIR
unset DUET_EMUVARIABLE_BUILD_DIR
unset DUET_FSVARIABLE_BUILD_DIR
unset BOOTPART
unset EFISYS
unset SYSLINUX_DIR
unset DUET_PART_FS_UUID
unset DUET_PART_MP

set +x +e
