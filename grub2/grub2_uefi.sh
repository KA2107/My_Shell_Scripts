#!/bin/bash

## This is a script to compile and install GRUB2 for UEFI systems. Just copy this script to the GRUB2 Source Root dir and run this script by passing the correct parameters. This script will be updated as and when the commands change in GRUB2 bzr repo and not just stick to any release version.

## This script uses efibootmgr to setup GRUB2 UEFI as the default boot option in UEFI NVRAM.

## For example if you did 'bzr branch bzr://bzr.savannah.gnu.org/grub/trunk/grub /home/user/grub'
## Then copy this script to /home/user/grub and cd into /home/user/grub and the run this script.

## This script assumes all the build dependencies to be installed and it does not try to install those for you.

## This script has configure options specific to my requirements and my system. Please read this script fully and modify it to suite your requirements.

## The "GRUB2_UEFI_NAME" parameter refers to the GRUB2 folder name in the UEFI System Partition. The final GRUB2 UEFI files will be installed in <EFI SYSTEM PARTITION>/efi/<GRUB2_UEFI_NAME>/ folder. The final GRUB2 UEFI Application will be <EFI SYSTEM PARTITION>/efi/<GRUB2_UEFI_NAME>/<GRUB2_UEFI_NAME>.efi where <GRUB2_UEFI_NAME> refers to the "GRUB2_UEFI_NAME" parameter you passed to this script.

## The "GRUB2_UEFI_PREFIX" parameter is not compulsory.

## For xman_dos2unix.sh download https://github.com/skodabenz/My_Shell_Scripts/blob/master/xmanutility/xman_dos2unix.sh

## This script uses the 'sudo' tool at certain places so make sure you have that installed.

export PROCESS_CONTINUE="TRUE"

if [ \
	"${1}" == "" -o \
	"${1}" == "-h" -o \
	"${1}" == "-u" -o \
	"${1}" == "--help" -o \
	"${1}" == "--usage" \
	]
then
	echo
	echo Usage : ${0} [TARGET_UEFI_ARCH] [UEFI_SYSTEM_PART_MOUNTPOINT] [GRUB2_UEFI_Install_Dir_Name] [GRUB2_UEFI_Backup_Path] [GRUB2_UEFI_Tools_Backup_Path] [GRUB2_UEFI_PREFIX_FOLDER]
	echo
	echo Example : ${0} x86_64 /boot/efi grub2 /media/Data_3/grub2_UEFI_x86_64_Backup /media/Data_3/grub2_UEFI_x86_64_Tools_Backup /grub2/grub2_uefi_x86_64
	echo
	echo "For example if you did 'bzr branch bzr://bzr.savannah.gnu.org/grub/trunk/grub /home/user/grub'"
	echo "Then copy this script to /home/user/grub and cd into /home/user/grub and then run this script from /home/user/grub."
	echo
	echo "This script uses the 'sudo' tool at certain places so make sure you have that installed."
	echo
	echo "Please read this script fully and modify it to suite your requirements before actually running it"
	echo
	export PROCESS_CONTINUE="FALSE"
fi

export WD="${PWD}/"

## The location of grub-extras source folder if you have.
export GRUB_CONTRIB="${WD}/grub2_extras__GIT_BZR/"

export REPLACE_GRUB2_UEFI_MENU_CONFIG="0"
export EXECUTE_EFIBOOTMGR="0"

export TARGET_UEFI_ARCH="${1}"
export UEFI_SYSTEM_PART_MP="${2}"
export GRUB2_UEFI_NAME="${3}"
export GRUB2_UEFI_Backup="${4}"
export GRUB2_UEFI_TOOLS_Backup="${5}"
export GRUB2_UEFI_PREFIX="${6}"
## If not mentioned, GRUB2_UEFI_PREFIX env variable will be set to /grub2/grub2_uefi_${TARGET_UEFI_ARCH} dir

export GRUB2_UEFI_MENU_CONFIG="grub"
[ "${REPLACE_GRUB2_UEFI_MENU_CONFIG}" == "1" ] && export GRUB2_UEFI_MENU_CONFIG="${GRUB2_UEFI_NAME}"

[ "${GRUB2_UEFI_PREFIX}" == "" ] && GRUB2_UEFI_PREFIX="/grub2/grub2_uefi_${TARGET_UEFI_ARCH}"

export GRUB2_UEFI_APP_PREFIX="efi/${GRUB2_UEFI_NAME}"
export GRUB2_UEFI_SYSTEM_PART_DIR="${UEFI_SYSTEM_PART_MP}/${GRUB2_UEFI_APP_PREFIX}"
export GRUB2_UNIFONT_PATH="/usr/share/fonts/misc"

export GRUB2_UEFI_Configure_Flags="--with-platform=efi --target=${TARGET_UEFI_ARCH} --program-transform-name=s,grub,${GRUB2_UEFI_NAME},"
export GRUB2_Other_UEFI_Configure_Flags="--enable-mm-debug --enable-grub-mkfont --enable-nls"

export GRUB2_UEFI_LST_files="command.lst crypto.lst fs.lst handler.lst moddep.lst partmap.lst parttool.lst terminal.lst video.lst"

export GRUB2_PARTMAP_FS_MODULES="part_gpt part_msdos part_apple fat ext2 reiserfs iso9660 udf hfsplus hfs btrfs nilfs2 xfs ntfs ntfscomp zfs zfsinfo"
export GRUB2_COMMON_IMP_MODULES="relocator reboot multiboot multiboot2 fshelp xzio gzio memdisk tar normal gfxterm chain linux ls cat search search_fs_file search_fs_uuid search_label help loopback boot configfile echo lvm usbms usb_keyboard"
export GRUB2_UEFI_APP_MODULES="efi_gop efi_uga font png jpeg password pbkdf2 password_pbkdf2"
export GRUB2_EXTRAS_MODULES="lua.mod"
export GRUB2_UEFI_FINAL_MODULES="${GRUB2_PARTMAP_FS_MODULES} ${GRUB2_COMMON_IMP_MODULES} ${GRUB2_UEFI_APP_MODULES} ${GRUB2_EXTRAS_MODULES}"
# export GRUB2_UEFI_FINAL_MODULES="${GRUB2_PARTMAP_FS_MODULES} ${GRUB2_COMMON_IMP_MODULES} ${GRUB2_UEFI_APP_MODULES}"

## GRUB2_UEFI_FINAL_MODULES - Those modules that will be in the final <GRUB2_UEFI_NAME>.efi application.

if [ "${PROCESS_CONTINUE}" == "TRUE" ]
then
	echo
	echo TARGET_UEFI_ARCH="${TARGET_UEFI_ARCH}"
	echo
	echo EFI_SYS_PART_MOUNTPOINT="${UEFI_SYSTEM_PART_MP}"
	echo
	echo GRUB2_UEFI_Final_Installation_Directory="${GRUB2_UEFI_SYSTEM_PART_DIR}"
	echo
	echo GRUB2_UEFI_Backup_Path="${GRUB2_UEFI_Backup}"
	echo
	echo GRUB2_UEFI_Tools_Backup_Path="${GRUB2_UEFI_TOOLS_Backup}"
	echo
	echo GRUB2_UEFI_PREFIX_FOLDER="${GRUB2_UEFI_PREFIX}" ## Not compulsory
	echo
	
	read -p "Do you wish to proceed? (y/n): " ans ## Copied from http://www.linuxjournal.com/content/asking-yesno-question-bash-script
	
	case "${ans}" in
	y | Y | yes | YES | Yes)
	echo "Ok. Proceeding with compile and installation of GRUB2 UEFI ${TARGET_UEFI_ARCH}."
	echo
	
	## Load device-mapper kernel module - needed by grub-probe
	sudo modprobe dm-mod || true
	
	set -x -e
	
	cd "${WD}/"
	
	## Convert the line endings of all the source files from DOS to UNIX mode
	"${WD}/xman_dos2unix.sh" * || true
	echo
	
	## Uncomment below to use ${GRUB2_UEFI_MENU_CONFIG}.cfg as the menu config file instead of grub.cfg
	sed -i "s|grub.cfg|${GRUB2_UEFI_MENU_CONFIG}.cfg|g" "${WD}/grub-core/normal/main.c" || true
	
	## Check whether python2 exists, otherwise create /usr/bin/python2 symlink to python executable
	[ "$(which python2)" == "" ] && sudo ln -s "$(which python)" "/usr/bin/python2"
	
	## Archlinux changed default /usr/bin/python to 3.1.2, need to use /usr/bin/python2 instead
	cp "${WD}/autogen.sh" "${WD}/autogen_unmodified.sh"
	sed -i 's|python |python2 |g' "${WD}/autogen.sh" || true
	
	if [ ! -e "${WD}/po/LINGUAS" ]
	then
		cd "${WD}/"
		rsync -Lrtvz translationproject.org::tp/latest/grub/ "${WD}/po" || true
		(cd "${WD}/po" && ls *.po | cut -d. -f1 | xargs) > "${WD}/po/LINGUAS" || true
	fi
	
	"${WD}/autogen.sh"
	echo
	
	## GRUB2 UEFI Build Directory
	mkdir "GRUB2_UEFI_BUILD_DIR_${TARGET_UEFI_ARCH}"
	cp --verbose "${WD}/grub.default" "${WD}/GRUB2_UEFI_BUILD_DIR_${TARGET_UEFI_ARCH}/" || true
	cp --verbose "${WD}/grub.cfg" "${WD}/GRUB2_UEFI_BUILD_DIR_${TARGET_UEFI_ARCH}/" || true
	
	cd "GRUB2_UEFI_BUILD_DIR_${TARGET_UEFI_ARCH}"
	echo
	
	## fix unifont.bdf location
	sed -i "s|/usr/share/fonts/unifont|${GRUB2_UNIFONT_PATH}|g" "${WD}/configure"
	
	"${WD}/configure" ${GRUB2_UEFI_Configure_Flags} ${GRUB2_Other_UEFI_Configure_Flags} --prefix="${GRUB2_UEFI_PREFIX}"
	echo
	
	make
	echo
	
	sudo cp --verbose -r "${GRUB2_UEFI_PREFIX}" "${GRUB2_UEFI_TOOLS_Backup}" || true
	echo
	sudo rm --verbose -rf "${GRUB2_UEFI_PREFIX}" || true
	echo
	
	sudo make install
	echo
	
	cd "${WD}/GRUB2_UEFI_BUILD_DIR_${TARGET_UEFI_ARCH}/grub-core/"
	# sudo cp --verbose ${GRUB2_EXTRAS_MODULES} "${GRUB2_UEFI_PREFIX}/lib/${GRUB2_UEFI_NAME}/${TARGET_UEFI_ARCH}-efi/" || true
	echo
	
	## Backup the old GRUB2 folder in the UEFI System Partition
	sudo cp --verbose -r "${GRUB2_UEFI_SYSTEM_PART_DIR}" "${GRUB2_UEFI_Backup}" || true
	echo
	## Delete the old GRUB2 folder in the UEFI System Partition
	sudo rm --verbose -rf "${GRUB2_UEFI_SYSTEM_PART_DIR}" || true
	echo
	
	sudo sed -i 's|--bootloader_id=|--bootloader-id=|g' "${GRUB2_UEFI_PREFIX}/sbin/${GRUB2_UEFI_NAME}-install" || true
	
	## Setup the GRUB2 folder in the UEFI System Partition and create the grub.efi application
	sudo "${GRUB2_UEFI_PREFIX}/sbin/${GRUB2_UEFI_NAME}-install" --boot-directory="${UEFI_SYSTEM_PART_MP}/efi" --bootloader-id="${GRUB2_UEFI_NAME}" --no-floppy --recheck --debug
	echo
	
	sudo rm "${GRUB2_UEFI_SYSTEM_PART_DIR}/core.efi" || true
	echo
	
	## Create the grub2 uefi application
	sudo "${GRUB2_UEFI_PREFIX}/bin/${GRUB2_UEFI_NAME}-mkimage" --verbose --directory="${GRUB2_UEFI_PREFIX}/lib/${GRUB2_UEFI_NAME}/${TARGET_UEFI_ARCH}-efi" --prefix="" --output="${GRUB2_UEFI_SYSTEM_PART_DIR}/${GRUB2_UEFI_NAME}.efi" --format="${TARGET_UEFI_ARCH}-efi" ${GRUB2_UEFI_FINAL_MODULES}
	echo
	
	cd "${WD}/GRUB2_UEFI_BUILD_DIR_${TARGET_UEFI_ARCH}/grub-core/"
	# sudo cp --verbose ${GRUB2_EXTRAS_MODULES} "${GRUB2_UEFI_SYSTEM_PART_DIR}/" || true
	sudo cp --verbose "${GRUB2_UEFI_PREFIX}/lib/${GRUB2_UEFI_NAME}/${TARGET_UEFI_ARCH}-efi"/*.img "${GRUB2_UEFI_SYSTEM_PART_DIR}/" || true
	echo
	
	if [ "${EXECUTE_EFIBOOTMGR}" == "1" ]
	then
		echo
		sudo modprobe -q efivars || true
		
		EFISYS_PART_DEVICE="$("${GRUB2_UEFI_PREFIX}/sbin/${GRUB2_UEFI_NAME}-probe" --target=device "${GRUB2_UEFI_SYSTEM_PART_DIR}/")"
		EFISYS_PART_NUM="$(blkid -p -i -o value -s PART_ENTRY_NUMBER "${EFISYS_PART_DEVICE}")"
		EFISYS_PARENT_DEVICE="$(echo "${EFISYS_PART_DEVICE}" | sed "s/${EFISYS_PART_NUM}//g")"
		EFISYS_GRUB2_APP_PATH_UNIX_STYLE="/EFI/${GRUB2_UEFI_NAME}/${GRUB2_UEFI_NAME}.efi"
		EFISYS_GRUB2_APP_PATH_UNIX_STYLE="$(echo "${EFISYS_GRUB2_APP_PATH_UNIX_STYLE}" | sed 's/\//\\/g')"
		echo
		
		"${which efibootmgr)" --create --gpt --disk "${EFISYS_PARENT_DEVICE}" --part "${EFISYS_PART_NUM}" --write-signature --label "${GRUB2_UEFI_NAME}" --loader "${EFISYS_GRUB2_APP_PATH}" || true
		echo
	fi
	
	sudo
	mkdir -p "${GRUB2_UEFI_PREFIX}/etc/default"
	[ -e "${WD}/grub.default" ] && sudo cp --verbose "${WD}/grub.default" "${GRUB2_UEFI_PREFIX}/etc/default/grub" || true
	sudo chmod --verbose -x "${GRUB2_UEFI_PREFIX}/etc/default/grub" || true
	echo
	
	sudo cp --verbose "$(which gettext.sh)" "${GRUB2_UEFI_PREFIX}/bin/" || true
	sudo chmod --verbose -x "${GRUB2_UEFI_PREFIX}/etc/grub.d/README" || true
	echo
	# sudo "${GRUB2_UEFI_PREFIX}/sbin/${GRUB2_UEFI_NAME}-mkconfig" --output="${GRUB2_UEFI_SYSTEM_PART_DIR}/${GRUB2_UEFI_MENU_CONFIG}.cfg" || true
	echo
	
	sudo cp "${GRUB2_UEFI_PREFIX}/share/${GRUB2_UEFI_NAME}"/*.pf2 "${GRUB2_UEFI_SYSTEM_PART_DIR}/" || true
	echo
	
	sed -i "s|${GRUB2_UEFI_MENU_CONFIG}.cfg|grub.cfg|g" "${WD}/grub-core/normal/main.c" || true
	
	## Copy the old config file as ${GRUB2_UEFI_MENU_CONFIG}_backup.cfg
	sudo cp --verbose "${GRUB2_UEFI_Backup}/${GRUB2_UEFI_MENU_CONFIG}.cfg" "${GRUB2_UEFI_SYSTEM_PART_DIR}/${GRUB2_UEFI_MENU_CONFIG}_backup.cfg" || true
	# sudo cp --verbose "${GRUB2_UEFI_Backup}/${GRUB2_UEFI_MENU_CONFIG}.cfg" "${GRUB2_UEFI_SYSTEM_PART_DIR}/${GRUB2_UEFI_MENU_CONFIG}.cfg" || true
	sudo cp --verbose "${WD}/grub.cfg" "${GRUB2_UEFI_SYSTEM_PART_DIR}/${GRUB2_UEFI_MENU_CONFIG}.cfg" || true
	sudo cp --verbose "${GRUB2_UEFI_Backup}"/*.jpg "${GRUB2_UEFI_Backup}"/*.png "${GRUB2_UEFI_Backup}"/*.tga "${GRUB2_UEFI_SYSTEM_PART_DIR}/" || true
	echo
	
	sudo chmod --verbose -x "${GRUB2_UEFI_SYSTEM_PART_DIR}/${GRUB2_UEFI_MENU_CONFIG}.cfg" || true
	echo
	
	echo "GRUB 2 UEFI ${TARGET_UEFI_ARCH} Setup in ${GRUB2_UEFI_SYSTEM_PART_DIR} successfully."
	echo
	
	set +x +e
	
	;; # End of "y" option in the case list
	
	n | N | no | NO | No)
	echo "You said no. Exiting to shell."
	;; # End of "n" option in the case list
	
	*) # Any other input
	echo "Invalid answer. Exiting to shell."
	;;
	esac # ends the case list
	
fi

unset WD
unset GRUB_CONTRIB
unset PROCESS_CONTINUE
unset REPLACE_GRUB2_UEFI_MENU_CONFIG
unset EXECUTE_EFIBOOTMGR
unset TARGET_UEFI_ARCH
unset UEFI_SYSTEM_PART_MP
unset GRUB2_UEFI_NAME
unset GRUB2_UEFI_Backup
unset GRUB2_UEFI_TOOLS_Backup
unset GRUB2_UEFI_PREFIX
unset GRUB2_UEFI_APP_PREFIX
unset GRUB2_UEFI_SYSTEM_PART_DIR
unset GRUB2_UEFI_MENU_CONFIG
unset GRUB2_UEFI_Configure_Flags
unset GRUB2_Other_UEFI_Configure_Flags
unset GRUB2_UEFI_LST_files
unset GRUB2_PARTMAP_FS_MODULES
unset GRUB2_COMMON_IMP_MODULES
unset GRUB2_UEFI_APP_MODULES
unset GRUB2_EXTRAS_MODULES
unset GRUB2_UEFI_FINAL_MODULES
unset GRUB2_UNIFONT_PATH
