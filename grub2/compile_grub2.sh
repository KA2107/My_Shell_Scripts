#! /bin/sh

export PROCESS_CONTINUE_UEFI="FALSE"
export PROCESS_CONTINUE_BIOS="FALSE"
export WD_Outer=${PWD}
export x32_chroot="/opt/arch32"

if [ \
	"$1" = "" -o \
	"$1" = "-h" -o \
	"$1" = "-u" -o \
	"$1" = "--help" -o \
	"$1" = "--usage" \
	]
then
	echo
	echo  "1 for EFI-MAIN and BIOS-MAIN"
	echo  "2 for EFI-EXP and BIOS-MAIN"
	echo  "3 for EFI-MAIN and BIOS-EXP"
	echo  "4 for EFI-EXP and BIOS-EXP"
	echo
	echo  "5 for EFI-MAIN alone"
	echo  "6 for EFI-EXP alone"
	echo  "7 for BIOS-MAIN alone"
	echo  "8 for BIOS-EXP alone"
	echo
	echo  "9 for BIOS-MAIN and EFI-install"
	echo  "10 for EFI-install alone"
	export PROCESS_CONTINUE_UEFI="FALSE"
	export PROCESS_CONTINUE_BIOS="FALSE"
fi

if [ "$1" = "1" ]
then
	export GRUB2_EFI="-efi-main"
	export GRUB2_BIOS="-bios-main"
elif [ "$1" = "2" ]
then
	export GRUB2_EFI="-efi-exp"
	export GRUB2_BIOS="-bios-main"
elif [ "$1" = "3" ]
then
	export GRUB2_EFI="-efi-main"
	export GRUB2_BIOS="-bios-exp"
elif [ "$1" = "4" ]
then
	export GRUB2_EFI="-efi-exp"
	export GRUB2_BIOS="-bios-exp"
elif [ "$1" = "5" ]
then
	export GRUB2_EFI="-efi-main"
	export GRUB2_BIOS="NULL"
elif [ "$1" = "6" ]
then
	export GRUB2_EFI="-efi-exp"
	export GRUB2_BIOS="NULL"
elif [ "$1" = "7" ]
then
	export GRUB2_EFI="NULL"
	export GRUB2_BIOS="-bios-main"
elif [ "$1" = "8" ]
then
	export GRUB2_EFI="NULL"
	export GRUB2_BIOS="-bios-exp"
elif [ "$1" = "9" ]
then
	export GRUB2_EFI="-efi-install"
	export GRUB2_BIOS="-bios-main"
elif [ "$1" = "10" ]
then
	export GRUB2_EFI="-efi-install"
	export GRUB2_BIOS="NULL"
fi

if [ "${GRUB2_EFI}" == "-efi-exp" ]
then
	export GRUB2_EFI_Source_DIR_Name=grub2_experimental__GIT_BZR
	export PROCESS_CONTINUE_UEFI="TRUE"
elif [ "${GRUB2_EFI}" == "-efi-main" ]
then
	export GRUB2_EFI_Source_DIR_Name=grub2__GIT_BZR
	export PROCESS_CONTINUE_UEFI="TRUE"
elif [ "${GRUB2_EFI}" == "-efi-install" ]
then
	export GRUB2_EFI_Source_DIR_Name="grub2__GIT_BZR_branches/grub2-bzr-install"
	export PROCESS_CONTINUE_UEFI="TRUE"
fi

if [ "${GRUB2_BIOS}" == "-bios-exp" ]
then
	export GRUB2_BIOS_Source_DIR_Name=grub2_experimental__GIT_BZR
	export PROCESS_CONTINUE_BIOS="TRUE"
elif [ "${GRUB2_BIOS}" == "-bios-main" ]
then
	export GRUB2_BIOS_Source_DIR_Name=grub2__GIT_BZR
	export PROCESS_CONTINUE_BIOS="TRUE"
fi

echo

if [ "${PROCESS_CONTINUE_UEFI}" == "TRUE" ] && [ "${PROCESS_CONTINUE_BIOS}" == "TRUE" ]
then
	if [ "${GRUB2_EFI_Source_DIR_Name}" == "${GRUB2_BIOS_Source_DIR_Name}" ]
	then
		cd ${WD_Outer}/${GRUB2_EFI_Source_DIR_Name}/
		echo
	fi
fi

if [ "${PROCESS_CONTINUE_UEFI}" == "TRUE" ]
then

	set -x -e

	# ${WD_Outer}/xman_dos2unix.sh * || true

	## First compile GRUB2 for UEFI x86_64

	rm -rf ${WD_Outer}/${GRUB2_EFI_Source_DIR_Name}/grub2_extras__GIT_BZR || true

	cp -r ${WD_Outer}/grub2_extras__GIT_BZR ${WD_Outer}/${GRUB2_EFI_Source_DIR_Name}/grub2_extras__GIT_BZR || true
	rm -rf ${WD_Outer}/${GRUB2_EFI_Source_DIR_Name}/grub2_extras__GIT_BZR/zfs || true
	rm -rf ${WD_Outer}/${GRUB2_EFI_Source_DIR_Name}/grub2_extras__GIT_BZR/915resolution || true
	rm -rf ${WD_Outer}/${GRUB2_EFI_Source_DIR_Name}/grub2_extras__GIT_BZR/ntldr-img || true

	if [ "${GRUB2_EFI_Source_DIR_Name}" != "${GRUB2_BIOS_Source_DIR_Name}" ]
	then
		cd ${WD_Outer}/${GRUB2_EFI_Source_DIR_Name}/
		echo
	fi

	cp --verbose ${WD_Outer}/xman_dos2unix.sh ${WD_Outer}/grub.default ${WD_Outer}/${GRUB2_EFI_Source_DIR_Name}/ || true
	cp --verbose ${WD_Outer}/grub2_efi_linux_scripts/grub2_efi.sh ${WD_Outer}/grub2_efi_linux_scripts/grub2_efi_linux_my.sh ${WD_Outer}/${GRUB2_EFI_Source_DIR_Name}/
	echo

	rm ${WD_Outer}/${GRUB2_EFI_Source_DIR_Name}/grub.cfg || true
	cp --verbose ${WD_Outer}/grub2_efi_linux_scripts/grub2_efi.cfg ${WD_Outer}/${GRUB2_EFI_Source_DIR_Name}/grub.cfg || true
	echo

	cd ${WD_Outer}/${GRUB2_EFI_Source_DIR_Name}/
	${PWD}/grub2_efi_linux_my.sh
	echo
	cd ..

	cp -r ${WD_Outer}/${GRUB2_EFI_Source_DIR_Name}/GRUB2_EFI_BUILD_DIR_x86_64 ${WD_Outer}/GRUB2_EFI_BUILD_DIR_x86_64 || true
	sudo rm -rf ${WD_Outer}/${GRUB2_EFI_Source_DIR_Name}/GRUB2_EFI_BUILD_DIR_x86_64 || true
	echo

	set +x +e

fi

if [ "${PROCESS_CONTINUE_BIOS}" = "TRUE" ]
then

	set -x -e

	# ${WD_Outer}/xman_dos2unix.sh * || true

	## Second compile GRUB2 for BIOS

	rm -rf ${WD_Outer}/${GRUB2_BIOS_Source_DIR_Name}/grub2_extras__GIT_BZR || true

	cp -r ${WD_Outer}/grub2_extras__GIT_BZR ${WD_Outer}/${GRUB2_BIOS_Source_DIR_Name}/grub2_extras__GIT_BZR || true
	rm -rf ${WD_Outer}/${GRUB2_BIOS_Source_DIR_Name}/grub2_extras__GIT_BZR/zfs || true
	rm -rf ${WD_Outer}/${GRUB2_BIOS_Source_DIR_Name}/grub2_extras__GIT_BZR/915resolution || true

	if [ "${GRUB2_BIOS_Source_DIR_Name}" != "${GRUB2_EFI_Source_DIR_Name}" ]
	then
		cd ${WD_Outer}/${GRUB2_BIOS_Source_DIR_Name}/
		echo
	fi

	cp --verbose ${WD_Outer}/xman_dos2unix.sh ${WD_Outer}/grub.default ${WD_Outer}/${GRUB2_BIOS_Source_DIR_Name}/ || true
	cp --verbose ${WD_Outer}/grub2_bios_linux_scripts/grub2_bios.sh ${WD_Outer}/grub2_bios_linux_scripts/grub2_bios_linux_my.sh ${WD_Outer}/${GRUB2_BIOS_Source_DIR_Name}/
	echo

	rm ${WD_Outer}/${GRUB2_BIOS_Source_DIR_Name}/grub.cfg || true
	cp --verbose ${WD_Outer}/grub2_bios_linux_scripts/grub2_bios.cfg ${WD_Outer}/${GRUB2_BIOS_Source_DIR_Name}/grub.cfg || true
	echo

	cd ${WD_Outer}/${GRUB2_BIOS_Source_DIR_Name}/

	## CHROOT into the arch32 system for compiling GRUB2 BIOS i386
	# export BCHROOT_DIR=${WD_Outer}
	# sudo chroot ${x32_chroot} || return 1
	# cd ${BCHROOT_DIR}
	# unset BCHROOT_DIR

	# schroot --automatic-session --preserve-environment --directory ${WD_Outer}
	${PWD}/grub2_bios_linux_my.sh
	echo
	cd ..

	cp -r ${WD_Outer}/${GRUB2_BIOS_Source_DIR_Name}/GRUB2_BIOS_BUILD_DIR ${WD_Outer}/GRUB2_BIOS_BUILD_DIR || true
	sudo rm -rf ${WD_Outer}/${GRUB2_BIOS_Source_DIR_Name}/GRUB2_BIOS_BUILD_DIR || true
	echo

	set +x +e

fi

unset PROCESS_CONTINUE_UEFI
unset PROCESS_CONTINUE_BIOS
unset WD_Outer
unset GRUB2_EFI
unset GRUB2_BIOS
unset GRUB2_EFI_Source_DIR_Name
unset GRUB2_BIOS_Source_DIR_Name
unset x32_chroot
