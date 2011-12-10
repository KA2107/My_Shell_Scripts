#!/bin/bash

## This is a script to compile and install GRUB2 for UEFI systems. Just copy this script to the GRUB2 Source Root dir and run this script by passing the correct parameters. This script will be updated as and when the commands change in GRUB2 bzr repo and not just stick to any release version.

## This script uses efibootmgr to setup GRUB2 UEFI as the default boot option in UEFI NVRAM.

## For example if you did 'bzr branch bzr://bzr.savannah.gnu.org/grub/trunk/grub /home/user/grub'
## Then copy this script to /home/user/grub and cd into /home/user/grub and the run this script.

## This script assumes all the build dependencies to be installed and it does not try to install those for you.

## This script has configure options specific to my requirements and my system. Please read this script fully and modify it to suite your requirements.

## The "GRUB2_UEFI_NAME" parameter refers to the GRUB2 folder name in the UEFI SYSTEM PARTITION. The final GRUB2 UEFI files will be installed in <UEFI_SYSTEM_PARTITION>/efi/<GRUB2_UEFI_NAME>/ folder. The final GRUB2 UEFI Application will be <UEFI_SYSTEM_PARTITION>/efi/<GRUB2_UEFI_NAME>/<GRUB2_UEFI_NAME>.efi where <GRUB2_UEFI_NAME> refers to the "GRUB2_UEFI_NAME" parameter passed to this script.

## The "GRUB2_UEFI_PREFIX_DIR" parameter is not compulsory.

## For xman_dos2unix.sh download https://raw.github.com/the-ridikulus-rat/My_Shell_Scripts/master/xmanutility/xman_dos2unix.sh

## This script uses the 'sudo' tool at certain places so make sure you have that installed.

_SCRIPTNAME="$(basename "${0}")" 

export _PROCESS_CONTINUE='TRUE'

_USAGE() {
	
	echo
	echo "Usage : ${_SCRIPTNAME} [TARGET_UEFI_ARCH] [UEFI_SYSTEM_PART_MOUNTPOINT] [GRUB2_UEFI_INSTALL_DIR_NAME] [GRUB2_UEFI_BACKUP_DIR_PATH] [GRUB2_UEFI_UTILS_BACKUP_DIR_PATH] [GRUB2_UEFI_PREFIX_DIR_PATH]"
	echo
	echo "Example : ${_SCRIPTNAME} x86_64 /boot/efi grub_uefi_x86_64 /media/Data_3/grub_uefi_x86_64_backup /media/Data_3/grub_uefi_x86_64_utils_Backup /_grub_/grub_uefi_x86_64"
	echo
	echo 'For example if you did'
	echo
	echo 'bzr branch bzr://bzr.savannah.gnu.org/grub/trunk/grub /home/user/grub'
	echo
	echo 'then copy this script to /home/user/grub and cd into /home/user/grub and then run this script from /home/user/grub.'
	echo
	echo 'This script uses the "sudo" tool at certain places so make sure you have that installed.'
	echo
	echo 'Please read this script fully and modify it to suite your requirements before actually running it'
	echo
	export _PROCESS_CONTINUE='FALSE'
	
}

if [[ \
	"${1}" == '' || \
	"${1}" == '-h' || \
	"${1}" == '-u' || \
	"${1}" == '-help' || \
	"${1}" == '-usage' || \
	"${1}" == '--help' || \
	"${1}" == '--usage' \
	]]
then
	_USAGE
	export _PROCESS_CONTINUE="FALSE"
	exit 0
fi

# _GRUB2_UEFI_SET_ENV_VARS() {
	
	export _WD="${PWD}/"
	
	## The location of grub-extras source folder if you have.
	export GRUB_CONTRIB="${_WD}/grub2_extras__GIT_BZR/"
	
	export _REPLACE_GRUB2_UEFI_MENU_CONFIG='0'
	export _EXECUTE_EFIBOOTMGR='1'
	
	export _TARGET_UEFI_ARCH="${1}"
	export _UEFI_SYSTEM_PART_MP="${2}"
	export _GRUB2_UEFI_NAME="${3}"
	export _GRUB2_UEFI_BACKUP_DIR="${4}"
	export _GRUB2_UEFI_UTILS_BACKUP_DIR="${5}"
	export _GRUB2_UEFI_PREFIX_DIR="${6}"
	## If not mentioned, _GRUB2_UEFI_PREFIX_DIR env variable will be set to /_grub_/grub_uefi_${_TARGET_UEFI_ARCH} dir
	
	export _GRUB2_UEFI_MENU_CONFIG='grub'
	
	if [[ "${_REPLACE_GRUB2_UEFI_MENU_CONFIG}" == '1' ]]; then
		export _GRUB2_UEFI_MENU_CONFIG="${_GRUB2_UEFI_NAME}"
	fi
	
	if [[ "${_GRUB2_UEFI_PREFIX_DIR}" == '' ]]; then
		export _GRUB2_UEFI_PREFIX_DIR="/_grub_/grub_uefi_${_TARGET_UEFI_ARCH}"
	fi
	
	export _GRUB2_UEFI_BIN_DIR="${_GRUB2_UEFI_PREFIX_DIR}/bin"
	export _GRUB2_UEFI_SBIN_DIR="${_GRUB2_UEFI_PREFIX_DIR}/bin"
	export _GRUB2_UEFI_SYSCONF_DIR="${_GRUB2_UEFI_PREFIX_DIR}/etc"
	export _GRUB2_UEFI_LIB_DIR="${_GRUB2_UEFI_PREFIX_DIR}/lib"
	export _GRUB2_UEFI_DATAROOT_DIR="${_GRUB2_UEFI_PREFIX_DIR}/share"
	export _GRUB2_UEFI_INFO_DIR="${_GRUB2_UEFI_DATAROOT_DIR}/info"
	export _GRUB2_UEFI_LOCALE_DIR="${_GRUB2_UEFI_DATAROOT_DIR}/locale"
	export _GRUB2_UEFI_MAN_DIR="${_GRUB2_UEFI_DATAROOT_DIR}/man"
	
	export _GRUB2_UEFI_APP_PREFIX="efi/${_GRUB2_UEFI_NAME}"
	export _GRUB2_UEFI_SYSTEM_PART_DIR="${_UEFI_SYSTEM_PART_MP}/${_GRUB2_UEFI_APP_PREFIX}"
	
	if [[ "${_TARGET_UEFI_ARCH}" == 'x86_64' ]]; then
		export _OTHER_UEFI_ARCH_NAME='x64'
		
	elif [[ "${_TARGET_UEFI_ARCH}" == 'i386' ]]; then
		export _OTHER_UEFI_ARCH_NAME='ia32'
		
	fi
	
	export _GRUB2_UNIFONT_PATH='/usr/share/fonts/misc'
	
	export _GRUB2_UEFI_CONFIGURE_OPTIONS="--with-platform=efi --target=${_TARGET_UEFI_ARCH} --program-prefix="" --program-transform-name=s,grub,${_GRUB2_UEFI_NAME},"
	export _GRUB2_UEFI_OTHER_CONFIGURE_OPTIONS="--enable-mm-debug --enable-device-mapper --enable-cache-stats --enable-grub-mkfont --enable-nls"
	
	export _GRUB2_UEFI_CONFIGURE_PATHS_1="--prefix="${_GRUB2_UEFI_PREFIX_DIR}" --bindir="${_GRUB2_UEFI_BIN_DIR}" --sbindir="${_GRUB2_UEFI_SBIN_DIR}" --sysconfdir="${_GRUB2_UEFI_SYSCONF_DIR}" --libdir="${_GRUB2_UEFI_LIB_DIR}""
	export _GRUB2_UEFI_CONFIGURE_PATHS_2="--datarootdir="${_GRUB2_UEFI_DATAROOT_DIR}" --infodir="${_GRUB2_UEFI_INFO_DIR}" --localedir="${_GRUB2_UEFI_LOCALE_DIR}" --mandir="${_GRUB2_UEFI_MAN_DIR}""
	
	# export _GRUB2_UEFI_LST_files="command.lst crypto.lst fs.lst handler.lst moddep.lst partmap.lst parttool.lst terminal.lst video.lst"
	
	export _GRUB2_PARTMAP_FS_MODULES="part_gpt part_msdos part_apple fat ext2 reiserfs iso9660 udf hfsplus hfs btrfs nilfs2 xfs ntfs ntfscomp zfs zfsinfo"
	export _GRUB2_COMMON_IMP_MODULES="relocator reboot multiboot multiboot2 fshelp xzio gzio memdisk tar normal gfxterm chain linux ls cat search search_fs_file search_fs_uuid search_label help loopback boot configfile echo lvm usbms usb_keyboard"
	export _GRUB2_UEFI_APP_MODULES="efi_gop efi_uga font png jpeg password pbkdf2 password_pbkdf2"
	export _GRUB2_EXTRAS_MODULES="lua.mod"
	
	# export _GRUB2_UEFI_FINAL_MODULES="${_GRUB2_PARTMAP_FS_MODULES} ${_GRUB2_COMMON_IMP_MODULES} ${_GRUB2_UEFI_APP_MODULES} ${_GRUB2_EXTRAS_MODULES}"
	export _GRUB2_UEFI_FINAL_MODULES="${_GRUB2_PARTMAP_FS_MODULES} ${_GRUB2_COMMON_IMP_MODULES} ${_GRUB2_UEFI_APP_MODULES}"
	
	## _GRUB2_UEFI_FINAL_MODULES - Those modules that will be in the final <_GRUB2_UEFI_NAME>.efi application.
	
# }

# _GRUB2_UEFI_ECHO_CONFIG() {
	
	echo
	echo TARGET_UEFI_ARCH="${_TARGET_UEFI_ARCH}"
	echo
	echo UEFI_SYS_PART_MOUNTPOINT="${_UEFI_SYSTEM_PART_MP}"
	echo
	echo GRUB2_UEFI_Final_Installation_Directory="${_GRUB2_UEFI_SYSTEM_PART_DIR}"
	echo
	echo GRUB2_UEFI_BACKUP_DIR_Path="${_GRUB2_UEFI_BACKUP_DIR}"
	echo
	echo GRUB2_UEFI_Tools_Backup_Path="${_GRUB2_UEFI_UTILS_BACKUP_DIR}"
	echo
	echo GRUB2_UEFI_PREFIX_DIR_FOLDER="${_GRUB2_UEFI_PREFIX_DIR}" ## Not compulsory
	echo
	
# }

_GRUB2_UEFI_PRECOMPILE_STEPS() {
	
	cd "${_WD}/"
	
	## Convert the line endings of all the source files from DOS to UNIX mode
	[ ! -e "${_WD}/xman_dos2unix.sh" ] && wget --no-check-certificate --output-file="${_WD}/xman_dos2unix.sh" "https://raw.github.com/the-ridikulus-rat/My_Shell_Scripts/master/xmanutility/xman_dos2unix.sh" || true
	chmod +x "${_WD}/xman_dos2unix.sh" || true
	"${_WD}/xman_dos2unix.sh" * || true
	echo
	
	## Check whether python2 exists, otherwise create /usr/bin/python2 symlink to python executable
	# if [[ "$(which python2)" ]]
	# then
	# 	sudo ln -s "$(which python)" "/usr/bin/python2"
	# fi
	
	## Archlinux changed default /usr/bin/python to python3, need to use /usr/bin/python2 instead
	# if [[ "$(which python2)" ]]; then
	# 	install -D -m0755 "${_WD}/autogen.sh" "${_WD}/autogen_unmodified.sh"
	# 	sed 's|python |python2 |g' -i "${_WD}/autogen.sh" || true
	# fi
	
	chmod +x "${_WD}/autogen.sh" || true
	
	if [[ ! -e "${_WD}/po/LINGUAS" ]]; then
		cd "${_WD}/"
		rsync -Lrtvz translationproject.org::tp/latest/grub/ "${_WD}/po" || true
		(cd "${_WD}/po" && ls *.po | cut -d. -f1 | xargs) > "${_WD}/po/LINGUAS" || true
		chmod -x "${_WD}/po/LINGUAS" || true
	fi
	
	## GRUB2 UEFI Build Directory
	install -d "${_WD}/GRUB2_UEFI_BUILD_DIR_${_TARGET_UEFI_ARCH}"
	install -D -m0644 "${_WD}/grub.default" "${_WD}/GRUB2_UEFI_BUILD_DIR_${_TARGET_UEFI_ARCH}/grub.default" || true
	install -D -m0644 "${_WD}/grub.cfg" "${_WD}/GRUB2_UEFI_BUILD_DIR_${_TARGET_UEFI_ARCH}/grub.cfg" || true
	
}

_GRUB2_UEFI_COMPILE_STEPS() {
	
	## Uncomment below to use ${_GRUB2_UEFI_MENU_CONFIG}.cfg as the menu config file instead of grub.cfg - not recommended
	# sed "s|grub.cfg|${_GRUB2_UEFI_MENU_CONFIG}.cfg|g" -i "${_WD}/grub-core/normal/main.c" || true
	
	"${_WD}/autogen.sh"
	echo
	
	cd "${_WD}/GRUB2_UEFI_BUILD_DIR_${_TARGET_UEFI_ARCH}"
	echo
	
	## fix unifont.bdf location
	sed "s|/usr/share/fonts/unifont|${_GRUB2_UNIFONT_PATH}|g" -i "${_WD}/configure"
	
	"${_WD}/configure" ${_GRUB2_UEFI_CONFIGURE_OPTIONS} ${_GRUB2_UEFI_OTHER_CONFIGURE_OPTIONS} ${_GRUB2_UEFI_CONFIGURE_PATHS_1} ${_GRUB2_UEFI_CONFIGURE_PATHS_2}
	echo
	
	make
	echo
	
	sed "s|${_GRUB2_UEFI_MENU_CONFIG}.cfg|grub.cfg|g" -i "${_WD}/grub-core/normal/main.c" || true
	
}

_GRUB2_UEFI_POSTCOMPILE_SETUP_PREFIX_DIR() {
	
	if [[ \
		"${_GRUB2_UEFI_PREFIX_DIR}" != '/' || \
		"${_GRUB2_UEFI_PREFIX_DIR}" != '/usr' || \
		"${_GRUB2_UEFI_PREFIX_DIR}" != '/usr/local' || \
		"${_GRUB2_UEFI_PREFIX_DIR}" != '/media' || \
		"${_GRUB2_UEFI_PREFIX_DIR}" != '/mnt' || \
		"${_GRUB2_UEFI_PREFIX_DIR}" != '/home' || \
		"${_GRUB2_UEFI_PREFIX_DIR}" != '/lib' || \
		"${_GRUB2_UEFI_PREFIX_DIR}" != '/lib64' || \
		"${_GRUB2_UEFI_PREFIX_DIR}" != '/lib32' || \
		"${_GRUB2_UEFI_PREFIX_DIR}" != '/tmp' || \
		"${_GRUB2_UEFI_PREFIX_DIR}" != '/var' || \
		"${_GRUB2_UEFI_PREFIX_DIR}" != '/run' || \
		"${_GRUB2_UEFI_PREFIX_DIR}" != '/etc' || \
		"${_GRUB2_UEFI_PREFIX_DIR}" != '/opt' \
		]]
	then
		sudo cp -r --verbose "${_GRUB2_UEFI_PREFIX_DIR}" "${_GRUB2_UEFI_UTILS_BACKUP_DIR}" || true
		echo
		sudo rm -rf --verbose "${_GRUB2_UEFI_PREFIX_DIR}" || true
		echo
	fi
	
	sudo make install
	echo
	
	cd "${_WD}/GRUB2_UEFI_BUILD_DIR_${_TARGET_UEFI_ARCH}/grub-core/"
	# sudo cp --verbose ${_GRUB2_EXTRAS_MODULES} "${_GRUB2_UEFI_LIB_DIR}/${_GRUB2_UEFI_NAME}/${_TARGET_UEFI_ARCH}-efi/" || true
	echo
	
	sudo install -d "${_GRUB2_UEFI_SYSCONF_DIR}/default"
	
	if [[ -e "${_WD}/grub.default" ]]; then
		sudo install -D -m0644 "${_WD}/grub.default" "${_GRUB2_UEFI_SYSCONF_DIR}/default/grub" || true
	fi
	
	sudo chmod --verbose -x "${_GRUB2_UEFI_SYSCONF_DIR}/default/grub" || true
	echo
	
	sudo install -D -m0755 "$(which gettext.sh)" "${_GRUB2_UEFI_BIN_DIR}/gettext.sh" || true
	sudo chmod --verbose -x "${_GRUB2_UEFI_SYSCONF_DIR}/grub.d/README" || true
	echo
	
	# sudo "${_GRUB2_UEFI_BIN_DIR}/${_GRUB2_UEFI_NAME}-mkfont" --verbose --output="${_GRUB2_UEFI_DATAROOT_DIR}/${_GRUB2_UEFI_NAME}/unicode.pf2" "${_GRUB2_UNIFONT_PATH}/unifont.bdf" || true
	echo
	
	# sudo "${_GRUB2_UEFI_BIN_DIR}/${_GRUB2_UEFI_NAME}-mkfont" --verbose --ascii-bitmaps --output="${_GRUB2_UEFI_DATAROOT_DIR}/${_GRUB2_UEFI_NAME}/ascii.pf2" "${_GRUB2_UNIFONT_PATH}/unifont.bdf" || true
	echo
	
}

_GRUB2_UEFI_BACKUP_OLD_DIR() {
	
	## Backup the old GRUB2 folder in the UEFI System Partition
	sudo cp -r --verbose "${_GRUB2_UEFI_SYSTEM_PART_DIR}" "${_GRUB2_UEFI_BACKUP_DIR}" || true
	echo
	## Delete the old GRUB2 folder in the UEFI System Partition
	sudo rm -rf --verbose "${_GRUB2_UEFI_SYSTEM_PART_DIR}" || true
	echo
	
}

_GRUB2_UEFI_SETUP_UEFISYS_PART_DIR() {
	
	sudo sed 's|--bootloader_id=|--bootloader-id=|g' -i "${_GRUB2_UEFI_SBIN_DIR}/${_GRUB2_UEFI_NAME}-install" || true
	
	## Load device-mapper kernel module - needed by grub-probe
	sudo modprobe -q dm-mod || true
	
	## Setup the GRUB2 folder in the UEFI System Partition and create the grub.efi application
	sudo "${_GRUB2_UEFI_SBIN_DIR}/${_GRUB2_UEFI_NAME}-install" --root-directory="${_UEFI_SYSTEM_PART_MP}" --boot-directory="${_UEFI_SYSTEM_PART_MP}/efi" --bootloader-id="${_GRUB2_UEFI_NAME}" --no-floppy --recheck --debug
	echo
	
	# sudo rm -f --verbose "${_GRUB2_UEFI_SYSTEM_PART_DIR}/core.efi" || true
	echo
	
	cat << EOF > "${_WD}/grub_standalone_memdisk_${_GRUB2_UEFI_MENU_CONFIG}.cfg"
search --file --no-floppy --set=grub2_uefi_root "/${_GRUB2_UEFI_APP_PREFIX}/${_GRUB2_UEFI_NAME}-standalone.efi"

# set prefix=(\${grub2_uefi_root})/${_GRUB2_UEFI_APP_PREFIX}
source (\${grub2_uefi_root})/${_GRUB2_UEFI_APP_PREFIX}/${_GRUB2_UEFI_MENU_CONFIG}.cfg

EOF
	
	[[ ! -d "${_WD}/boot/grub" ]] && mkdir -p "${_WD}/boot/grub"
	install -D -m0644 "${_WD}/grub_standalone_memdisk_${_GRUB2_UEFI_MENU_CONFIG}.cfg" "${_WD}/boot/grub/grub.cfg"
	
	__WD="${PWD}/"
	
	cd "${_WD}/"
	
	## Create the grub2 standalone uefi application
	sudo "${_GRUB2_UEFI_BIN_DIR}/${_GRUB2_UEFI_NAME}-mkstandalone" --directory="${_GRUB2_UEFI_LIB_DIR}/${_GRUB2_UEFI_NAME}/${_TARGET_UEFI_ARCH}-efi" --format="${_TARGET_UEFI_ARCH}-efi" --compression="xz" --output="${_GRUB2_UEFI_SYSTEM_PART_DIR}/${_GRUB2_UEFI_NAME}-standalone.efi" "boot/grub/grub.cfg"
	
	cd "${__WD}/"
	
	sudo rm -rf "${_WD}/boot/grub"
	# sudo rm -rf "${_WD}/boot"
	
	sudo rm -f --verbose "${_GRUB2_UEFI_SYSTEM_PART_DIR}/${_GRUB2_UEFI_NAME}_standalone.cfg" || true
	
	if [[ -e "${_WD}/grub_standalone_memdisk_${_GRUB2_UEFI_MENU_CONFIG}.cfg" ]]; then
		sudo install -D -m0644 "${_WD}/grub_standalone_memdisk_${_GRUB2_UEFI_MENU_CONFIG}.cfg" "${_GRUB2_UEFI_SYSTEM_PART_DIR}/${_GRUB2_UEFI_NAME}_standalone.cfg"
	fi
	 
	## Create the grub2 custom uefi application
	# sudo "${_GRUB2_UEFI_BIN_DIR}/${_GRUB2_UEFI_NAME}-mkimage" --verbose --directory="${_GRUB2_UEFI_LIB_DIR}/${_GRUB2_UEFI_NAME}/${_TARGET_UEFI_ARCH}-efi" --format="${_TARGET_UEFI_ARCH}-efi" --compression="xz" --prefix="" --output="${_GRUB2_UEFI_SYSTEM_PART_DIR}/${_GRUB2_UEFI_NAME}.efi" ${_GRUB2_UEFI_FINAL_MODULES}
	echo
	
	cd "${_WD}/GRUB2_UEFI_BUILD_DIR_${_TARGET_UEFI_ARCH}/grub-core/"
	sudo cp --verbose "${_GRUB2_UEFI_LIB_DIR}/${_GRUB2_UEFI_NAME}/${_TARGET_UEFI_ARCH}-efi"/*.img "${_GRUB2_UEFI_SYSTEM_PART_DIR}/" || true
	# sudo cp --verbose ${_GRUB2_EXTRAS_MODULES} "${_GRUB2_UEFI_SYSTEM_PART_DIR}/" || true
	echo
	
	sudo cp "${_GRUB2_UEFI_DATAROOT_DIR}/${_GRUB2_UEFI_NAME}"/*.pf2 "${_GRUB2_UEFI_SYSTEM_PART_DIR}/" || true
	echo
	
	## Copy the old config file as ${_GRUB2_UEFI_MENU_CONFIG}_backup.cfg
	sudo install -D -m0644 "${_GRUB2_UEFI_BACKUP_DIR}/${_GRUB2_UEFI_MENU_CONFIG}.cfg" "${_GRUB2_UEFI_SYSTEM_PART_DIR}/${_GRUB2_UEFI_MENU_CONFIG}_backup.cfg" || true
	# sudo install -D -m0644 "${_GRUB2_UEFI_BACKUP_DIR}/${_GRUB2_UEFI_MENU_CONFIG}.cfg" "${_GRUB2_UEFI_SYSTEM_PART_DIR}/${_GRUB2_UEFI_MENU_CONFIG}.cfg" || true
	
	if [[ -e "${_WD}/grub.cfg" ]]; then
		sudo install -D -m0644 "${_WD}/grub.cfg" "${_GRUB2_UEFI_SYSTEM_PART_DIR}/${_GRUB2_UEFI_MENU_CONFIG}.cfg" || true
	fi
	
	# sudo "${_GRUB2_UEFI_SBIN_DIR}/${_GRUB2_UEFI_NAME}-mkconfig" --output="${_GRUB2_UEFI_SYSTEM_PART_DIR}/${_GRUB2_UEFI_MENU_CONFIG}.cfg" || true
	echo
	
	sudo chmod --verbose -x "${_GRUB2_UEFI_SYSTEM_PART_DIR}/${_GRUB2_UEFI_MENU_CONFIG}.cfg" || true
	echo
	
	sudo cp --verbose "${_GRUB2_UEFI_BACKUP_DIR}"/*.{png,jpg,tga} "${_GRUB2_UEFI_SYSTEM_PART_DIR}/" || true
	echo
	
}

_GRUB2_UEFI_EFIBOOTMGR() {
	
	if [[ "${_EXECUTE_EFIBOOTMGR}" == '1' ]]; then
		echo
		
		EFISYS_PART_DEVICE="$(sudo "${_GRUB2_UEFI_SBIN_DIR}/${_GRUB2_UEFI_NAME}-probe" --target=device "${_GRUB2_UEFI_SYSTEM_PART_DIR}/")"
		EFISYS_PART_NUM="$(sudo blkid -p -o value -s PART_ENTRY_NUMBER "${EFISYS_PART_DEVICE}")"
		EFISYS_PARENT_DEVICE="$(echo "${EFISYS_PART_DEVICE}" | sed "s/${EFISYS_PART_NUM}//g")"
		
		## Run efibootmgr script in sh compatibility mode, does not work in bash mode in ubuntu for some unknown reason (maybe some dash vs bash issue?)
		cat << EOF > "${_WD}/execute_efibootmgr.sh"
#!/bin/sh

set -x

modprobe -q efivars

if [[ "\$(grep ^efivars /proc/modules)" ]]; then
	if [[ -d "/sys/firmware/efi/vars" ]]; then
		# Delete old entries of grub2 - command to be checked
		for bootnum in \$(efibootmgr | grep '^Boot[0-9]' | fgrep -i " ${_GRUB2_UEFI_NAME}" | cut -b5-8)
		do
			efibootmgr --bootnum "${bootnum}" --delete-bootnum
		done
		
		efibootmgr --create --gpt --disk "${EFISYS_PARENT_DEVICE}" --part "${EFISYS_PART_NUM}" --write-signature --label "${_GRUB2_UEFI_NAME}" --loader "\\\\EFI\\\\${_GRUB2_UEFI_NAME}\\\\${_GRUB2_UEFI_NAME}.efi"
	else
		echo '/sys/firmware/efi/vars/ directory not found. Check whether you have booted in UEFI boot mode, manually load efivars kernel module and create a boot entry for GRUB2 in UEFI Boot Manager.'
	fi
else
	echo 'efivars kernel module not loaded properly. Manually load it and create a boot entry for GRUB2 in UEFI Boot Manager.'
fi

echo

set +x

echo

EOF
		
		chmod +x "${_WD}/execute_efibootmgr.sh" || true
		
		sudo "${_WD}/execute_efibootmgr.sh"
		
		set -x -e
		
		# rm -f --verbose "${_WD}/execute_efibootmgr.sh"
		
		echo
	fi
	
}

_GRUB2_UEFI_SETUP_BOOTX64_EFI_APP() {
	
	if [[ ! -d "${_UEFI_SYSTEM_PART_MP}/efi/boot" ]]; then
		sudo mkdir -p "${_UEFI_SYSTEM_PART_MP}/efi/boot/" || true
	fi
	
	sudo rm -f --verbose "${_UEFI_SYSTEM_PART_MP}/efi/boot/boot${_OTHER_UEFI_ARCH_NAME}.efi" || true
	
	if [[ -e "${_GRUB2_UEFI_SYSTEM_PART_DIR}/${_GRUB2_UEFI_NAME}-standalone.efi" ]]; then
		sudo install -D -m0644 "${_GRUB2_UEFI_SYSTEM_PART_DIR}/${_GRUB2_UEFI_NAME}-standalone.efi" "${_UEFI_SYSTEM_PART_MP}/efi/boot/boot${_OTHER_UEFI_ARCH_NAME}.efi"
	else
		if [[ -e "${_GRUB2_UEFI_SYSTEM_PART_DIR}/grub${_OTHER_UEFI_ARCH_NAME}.efi" ]]; then
			sudo install -D -m0644 "${_GRUB2_UEFI_SYSTEM_PART_DIR}/grub${_OTHER_UEFI_ARCH_NAME}.efi" "${_UEFI_SYSTEM_PART_MP}/efi/boot/boot${_OTHER_UEFI_ARCH_NAME}.efi"
		elif [[ -e "${_UEFI_SYSTEM_PART_MP}/efi/grub/core.efi" ]]; then
			sudo install -D -m0644 "${_UEFI_SYSTEM_PART_MP}/efi/grub/core.efi" "${_UEFI_SYSTEM_PART_MP}/efi/boot/boot${_OTHER_UEFI_ARCH_NAME}.efi"
		else
			if [[ -e "${_GRUB2_UEFI_SYSTEM_PART_DIR}/${_GRUB2_UEFI_NAME}.efi" ]]; then
				sudo install -D -m0644 "${_GRUB2_UEFI_SYSTEM_PART_DIR}/${_GRUB2_UEFI_NAME}.efi" "${_UEFI_SYSTEM_PART_MP}/efi/boot/boot${_OTHER_UEFI_ARCH_NAME}.efi"
			elif [[ -e "${_UEFI_SYSTEM_PART_MP}/efi/grub/grub.efi" ]]; then
				sudo install -D -m0644 "${_UEFI_SYSTEM_PART_MP}/efi/grub/grub.efi" "${_UEFI_SYSTEM_PART_MP}/efi/boot/boot${_OTHER_UEFI_ARCH_NAME}.efi"
			fi
		fi
	fi
	
	cat << EOF > "${_WD}/efi_boot_${_GRUB2_UEFI_MENU_CONFIG}.cfg"
search --file --no-floppy --set=grub2_uefi_root "/${_GRUB2_UEFI_APP_PREFIX}/grub.efi"

set prefix=(\${grub2_uefi_root})/${_GRUB2_UEFI_APP_PREFIX}
source \${prefix}/${_GRUB2_UEFI_MENU_CONFIG}.cfg

EOF
	
	sudo rm -f --verbose "${_UEFI_SYSTEM_PART_MP}/efi/boot/${_GRUB2_UEFI_MENU_CONFIG}.cfg" || true
	
	if [[ -e "${_WD}/efi_boot_${_GRUB2_UEFI_MENU_CONFIG}.cfg" ]]; then
		sudo install -D -m0644 "${_WD}/efi_boot_${_GRUB2_UEFI_MENU_CONFIG}.cfg" "${_UEFI_SYSTEM_PART_MP}/efi/boot/${_GRUB2_UEFI_MENU_CONFIG}.cfg"
	else
		sudo install -D -m0644 "${_GRUB2_UEFI_SYSTEM_PART_DIR}/${_GRUB2_UEFI_MENU_CONFIG}.cfg" "${_UEFI_SYSTEM_PART_MP}/efi/boot/${_GRUB2_UEFI_MENU_CONFIG}.cfg"
	fi
	
}

if [[ "${_PROCESS_CONTINUE}" == 'TRUE' ]]; then
	
	echo
	
	# _GRUB2_UEFI_SET_ENV_VARS
	
	echo
	
	# _GRUB2_UEFI_ECHO_CONFIG
	
	echo
	
	read -p 'Do you wish to proceed? (y/n): ' ans ## Copied from http://www.linuxjournal.com/content/asking-yesno-question-bash-script
	
	case "${ans}" in
	y | Y | yes | YES | Yes)
		echo
		echo 'Ok. Proceeding with compile and installation of GRUB2 UEFI ${_TARGET_UEFI_ARCH}.'
		echo
		
		set -x -e
		
		echo
		
		_GRUB2_UEFI_PRECOMPILE_STEPS
		
		echo
		
		_GRUB2_UEFI_COMPILE_STEPS
		
		echo
		
		_GRUB2_UEFI_POSTCOMPILE_SETUP_PREFIX_DIR
		
		echo
		
		_GRUB2_UEFI_BACKUP_OLD_DIR
		
		echo
		
		_GRUB2_UEFI_SETUP_UEFISYS_PART_DIR
		
		echo
		
		_GRUB2_UEFI_EFIBOOTMGR
		
		echo
		
		_GRUB2_UEFI_SETUP_BOOTX64_EFI_APP
		
		echo
		
		set +x +e
		
		echo "GRUB2 UEFI ${_TARGET_UEFI_ARCH} Setup in ${_GRUB2_UEFI_SYSTEM_PART_DIR} successfully."
		
		echo
		
	;; # End of "y" option in the case list
	
	n | N | no | NO | No)
		echo
		echo 'You said no. Exiting to shell.'
		echo
	;; # End of "n" option in the case list
	
	*) # Any other input
		echo
		echo 'Invalid answer. Exiting to shell.'
		ehco
	;;
	esac # ends the case list
	
fi

# _GRUB2_UEFI_UNSET_ENV_VARS() {
	
	unset _WD
	unset GRUB_CONTRIB
	unset _PROCESS_CONTINUE
	unset _REPLACE_GRUB2_UEFI_MENU_CONFIG
	unset _EXECUTE_EFIBOOTMGR
	unset _TARGET_UEFI_ARCH
	unset _UEFI_SYSTEM_PART_MP
	unset _GRUB2_UEFI_NAME
	unset _GRUB2_UEFI_BACKUP_DIR
	unset _GRUB2_UEFI_UTILS_BACKUP_DIR
	unset _GRUB2_UEFI_PREFIX_DIR
	unset _GRUB2_UEFI_BIN_DIR
	unset _GRUB2_UEFI_SBIN_DIR
	unset _GRUB2_UEFI_SYSCONF_DIR
	unset _GRUB2_UEFI_LIB_DIR
	unset _GRUB2_UEFI_DATAROOT_DIR
	unset _GRUB2_UEFI_INFO_DIR
	unset _GRUB2_UEFI_LOCALE_DIR
	unset _GRUB2_UEFI_MAN_DIR
	unset _GRUB2_UEFI_APP_PREFIX
	unset _GRUB2_UEFI_SYSTEM_PART_DIR
	unset _OTHER_UEFI_ARCH_NAME
	unset _GRUB2_UEFI_MENU_CONFIG
	unset _GRUB2_UEFI_CONFIGURE_OPTIONS
	unset _GRUB2_UEFI_OTHER_CONFIGURE_OPTIONS
	unset _GRUB2_UEFI_CONFIGURE_PATHS_1
	unset _GRUB2_UEFI_CONFIGURE_PATHS_2
	unset _GRUB2_UEFI_LST_files
	unset _GRUB2_PARTMAP_FS_MODULES
	unset _GRUB2_COMMON_IMP_MODULES
	unset _GRUB2_UEFI_APP_MODULES
	unset _GRUB2_EXTRAS_MODULES
	unset _GRUB2_UEFI_FINAL_MODULES
	unset _GRUB2_UNIFONT_PATH
	
# }

# _GRUB2_UEFI_UNSET_ENV_VARS
