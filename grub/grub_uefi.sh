#!/usr/bin/env bash

## This is a script to compile and install GRUB2 for UEFI systems. Just copy this script to the GRUB2 Source Root dir and run this script by passing the correct parameters. This script will be updated as and when the commands change in GRUB2 bzr repo and not just stick to any release version.

## This script uses efibootmgr to setup GRUB2 UEFI as the default boot option in UEFI NVRAM.

## For example if you did 'bzr branch bzr://bzr.savannah.gnu.org/grub/trunk/grub /home/user/grub'
## Then copy this script to /home/user/grub and cd into /home/user/grub and the run this script.

## This script assumes all the build dependencies to be installed and it does not try to install those for you.

## This script has configure options specific to my requirements and my system. Please read this script fully and modify it to suite your requirements.

## The "GRUB_UEFI_NAME" parameter refers to the GRUB2 folder name in the UEFI SYSTEM PARTITION. The final GRUB2 UEFI files will be installed in <UEFI_SYSTEM_PARTITION>/efi/<GRUB_UEFI_NAME>/ folder. The final GRUB2 UEFI Application will be <UEFI_SYSTEM_PARTITION>/efi/<GRUB_UEFI_NAME>/<GRUB_UEFI_NAME>.efi where <GRUB_UEFI_NAME> refers to the "GRUB_UEFI_NAME" parameter passed to this script.

## The "GRUB_UEFI_PREFIX_DIR" parameter is not compulsory.

## For xman_dos2unix.sh download https://raw.github.com/the-ridikulus-rat/My_Shell_Scripts/master/xmanutility/xman_dos2unix.sh

## This script uses the 'sudo' tool at certain places so make sure you have that installed.

_SCRIPTNAME="$(basename "${0}")" 

_UPDATE_LOCALES="0"

export _PROCESS_CONTINUE='TRUE'

_USAGE() {
	
	echo
	echo "Usage : ${_SCRIPTNAME} [TARGET_UEFI_ARCH] [UEFI_SYSTEM_PART_MOUNTPOINT] [GRUB_UEFI_BOOTDIR] [GRUB_UEFI_INSTALL_DIR_NAME] [GRUB_UEFISYS_BACKUP_DIR_PATH] [GRUB_UEFI_BOOTDIR_BACKUP_DIR_PATH] [GRUB_UEFI_UTILS_BACKUP_DIR_PATH] [GRUB_UEFI_PREFIX_DIR_PATH]"
	echo
	echo "Example : ${_SCRIPTNAME} x86_64 /boot/efi /boot grub /media/Data_3/grub_uefisys_x86_64_backup /media/Data_3/grub_uefi_x86_64_bootdir_backup /media/Data_3/grub_uefi_x86_64_utils_Backup /_grub_/uefi_x86_64/"
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
	exit 0
	
}

if [[ -z "${1}" || \
	"${1}" == '-h' || \
	"${1}" == '-u' || \
	"${1}" == '-help' || \
	"${1}" == '-usage' || \
	"${1}" == '--help' || \
	"${1}" == '--usage' \
	]]
then
	_USAGE
fi


export _TARGET_UEFI_ARCH="${1}"
export _UEFI_SYSTEM_PART_MP="${2}"
export _GRUB_UEFI_BOOTDIR="${3}"
export _GRUB_UEFI_NAME="${4}"
export _GRUB_UEFISYS_BACKUP_DIR="${5}"
export _GRUB_UEFI_BOOTDIR_BACKUP_DIR="${6}"
export _GRUB_UEFI_UTILS_BACKUP_DIR="${7}"
export _GRUB_UEFI_PREFIX_DIR="${8}"
## If not mentioned, _GRUB_UEFI_PREFIX_DIR env variable will be set to "/_grub_/uefi_${_TARGET_UEFI_ARCH}/" dir


_GRUB_UEFI_SET_ENV_VARS() {
	
	export _WD="${PWD}/"
	
	## The location of grub-extras source folder if you have.
	export GRUB_CONTRIB="${_WD}/grub_extras__GIT_BZR/"
	
	# export _REPLACE_GRUB_UEFI_MENU_CONFIG='0'
	export _GRUB_UEFI_CREATE_ENTRY_FIRMWARE_BOOTMGR='1'
	
	if [[ "${_GRUB_UEFI_PREFIX_DIR}" == '' ]]; then
		export _GRUB_UEFI_PREFIX_DIR="/_grub_/uefi_${_TARGET_UEFI_ARCH}/"
	fi
	
	export _GRUB_UEFI_MENU_CONFIG='grub'
	
	# if [[ "${_REPLACE_GRUB_UEFI_MENU_CONFIG}" == '1' ]]; then
		# export _GRUB_UEFI_MENU_CONFIG="${_GRUB_UEFI_NAME}"
	# fi
	
	export _GRUB_UEFI_BIN_DIR="${_GRUB_UEFI_PREFIX_DIR}/bin"
	export _GRUB_UEFI_SBIN_DIR="${_GRUB_UEFI_PREFIX_DIR}/sbin"
	export _GRUB_UEFI_SYSCONF_DIR="${_GRUB_UEFI_PREFIX_DIR}/etc"
	export _GRUB_UEFI_LIB_DIR="${_GRUB_UEFI_PREFIX_DIR}/lib"
	export _GRUB_UEFI_DATA_DIR="${_GRUB_UEFI_LIB_DIR}"
	export _GRUB_UEFI_DATAROOT_DIR="${_GRUB_UEFI_PREFIX_DIR}/share"
	export _GRUB_UEFI_INFO_DIR="${_GRUB_UEFI_DATAROOT_DIR}/info"
	export _GRUB_UEFI_LOCALE_DIR="${_GRUB_UEFI_DATAROOT_DIR}/locale"
	export _GRUB_UEFI_MAN_DIR="${_GRUB_UEFI_DATAROOT_DIR}/man"
	
	export _GRUB_UEFISYS_RELATIVE_PREFIX="efi/${_GRUB_UEFI_NAME}"
	export _GRUB_UEFISYS_PART_DIR="${_UEFI_SYSTEM_PART_MP}/${_GRUB_UEFISYS_RELATIVE_PREFIX}"
	
	export _GRUB_UEFI_BOOTDIR_ACTUAL="${_GRUB_UEFI_BOOTDIR}/${_GRUB_UEFI_NAME}"
	
	if [[ "${_TARGET_UEFI_ARCH}" == 'x86_64' ]]; then
		export _SPEC_UEFI_ARCH_NAME='x64'
		
	elif [[ "${_TARGET_UEFI_ARCH}" == 'i386' ]]; then
		export _SPEC_UEFI_ARCH_NAME='ia32'
		
	fi
	
	export _GRUB_UEFI_UNIFONT_PATH='/usr/share/fonts/misc'
	
	export _GRUB_UEFI_CONFIGURE_OPTIONS="--with-platform="efi" --target="${_TARGET_UEFI_ARCH}" --program-prefix="" --program-transform-name="s,grub,${_GRUB_UEFI_NAME}," --with-bootdir="${_GRUB_UEFI_BOOTDIR}" --with-grubdir="${_GRUB_UEFI_NAME}""
	export _GRUB_UEFI_OTHER_CONFIGURE_OPTIONS="--enable-mm-debug --enable-device-mapper --enable-cache-stats --enable-grub-mkfont --enable-grub-mount --enable-nls --disable-efiemu --disable-werror"
	
	export _GRUB_UEFI_CONFIGURE_PATHS_1="--prefix="${_GRUB_UEFI_PREFIX_DIR}" --bindir="${_GRUB_UEFI_BIN_DIR}" --sbindir="${_GRUB_UEFI_SBIN_DIR}" --sysconfdir="${_GRUB_UEFI_SYSCONF_DIR}" --libdir="${_GRUB_UEFI_LIB_DIR}""
	export _GRUB_UEFI_CONFIGURE_PATHS_2="--datarootdir="${_GRUB_UEFI_DATAROOT_DIR}" --infodir="${_GRUB_UEFI_INFO_DIR}" --localedir="${_GRUB_UEFI_LOCALE_DIR}" --mandir="${_GRUB_UEFI_MAN_DIR}""
	
	export _GRUB_UEFI_LST_files='command.lst crypto.lst fs.lst handler.lst moddep.lst partmap.lst parttool.lst terminal.lst video.lst'
	
	export _GRUB_EXTRAS_MODULES='lua.mod'
	
}

_GRUB_UEFI_ECHO_CONFIG() {
	
	echo
	echo TARGET_UEFI_ARCH="${_TARGET_UEFI_ARCH}"
	echo
	echo UEFI_SYS_PART_MOUNTPOINT="${_UEFI_SYSTEM_PART_MP}"
	echo
	echo GRUB_UEFI_BOOTDIR="${_GRUB_UEFI_BOOTDIR}"
	echo
	echo GRUB_UEFI_Final_Installation_Directory="${_GRUB_UEFISYS_PART_DIR}"
	echo
	echo GRUB_UEFISYS_BACKUP_DIR_Path="${_GRUB_UEFISYS_BACKUP_DIR}"
	echo
	echo GRUB_UEFI_BOOTDIR_BACKUP_DIR_Path="${_GRUB_UEFI_BOOTDIR_BACKUP_DIR}"
	echo
	echo GRUB_UEFI_Tools_Backup_Path="${_GRUB_UEFI_UTILS_BACKUP_DIR}"
	echo
	echo GRUB_UEFI_PREFIX_DIR_FOLDER="${_GRUB_UEFI_PREFIX_DIR}"
	echo
	
}

_GRUB_UEFI_DOS2UNIX() {
	
	echo
	
	## Convert the line endings of all the source files from DOS to UNIX mode
	if [[ ! -e "${_WD}/xman_dos2unix.sh" ]]; then
		curl --verbose --ipv4 -f -C - --ftp-pasv --retry 3 --retry-delay 3 -o "${_WD}/xman_dos2unix.sh" "https://raw.github.com/the-ridikulus-rat/My_Shell_Scripts/master/xmanutility/xman_dos2unix.sh" || true
		echo
	fi
	
	echo
	
	chmod --verbose +x "${_WD}/xman_dos2unix.sh" || true
	"${_WD}/xman_dos2unix.sh" * || true
	
	echo
	
}

_GRUB_UEFI_PYTHON_TO_PYTHON2() {
	
	echo
	
	## Check whether python2 exists, otherwise create /usr/bin/python2 symlink to python executable
	if [[ ! -e "$(which python2)" ]]; then
		sudo ln -s "$(which python)" "/usr/bin/python2"
	fi
	
	echo
	
	## Archlinux changed default /usr/bin/python to python3, need to use /usr/bin/python2 instead
	if [[ -e "$(which python2)" ]]; then
		install -D -m0755 "${_WD}/autogen.sh" "${_WD}/autogen_unmodified.sh"
		sed 's|python |python2 |g' -i "${_WD}/autogen.sh" || true
	fi
	
	echo
	
}

_GRUB_UEFI_PO_LINGUAS() {
	
	echo
	
	if [[ "${_UPDATE_LOCALES}" == "1" ]]; then
		cd "${_WD}/"
		rsync -Lrtvz translationproject.org::tp/latest/grub/ "${_WD}/po" || true
		echo
		
		(cd "${_WD}/po" && ls *.po | cut -d. -f1 | xargs) > "${_WD}/po/LINGUAS" || true
		chmod --verbose -x "${_WD}/po/LINGUAS" || true
		echo
	fi
	
	echo
	
}

_GRUB_UEFI_PRECOMPILE_STEPS() {
	
	cd "${_WD}/"
	echo
	
	_GRUB_UEFI_DOS2UNIX
	
	_GRUB_UEFI_PYTHON_TO_PYTHON2
	
	_GRUB_UEFI_PO_LINGUAS
	
	chmod --verbose +x "${_WD}/autogen.sh" || true
	echo
	
	## GRUB2 UEFI Build Directory
	install -d "${_WD}/GRUB_UEFI_BUILD_DIR_${_TARGET_UEFI_ARCH}"
	install -D -m0644 "${_WD}/grub.default" "${_WD}/GRUB_UEFI_BUILD_DIR_${_TARGET_UEFI_ARCH}/grub.default" || true
	install -D -m0644 "${_WD}/grub.cfg" "${_WD}/GRUB_UEFI_BUILD_DIR_${_TARGET_UEFI_ARCH}/grub.cfg" || true
	echo
	
}

_GRUB_UEFI_COMPILE_STEPS() {
	
	echo
	
	## sed "s|grub.cfg|${_GRUB_UEFI_MENU_CONFIG}.cfg|g" -i "${_WD}/grub-core/normal/main.c" || true
	echo
	
	"${_WD}/autogen.sh"
	echo
	
	cd "${_WD}/GRUB_UEFI_BUILD_DIR_${_TARGET_UEFI_ARCH}"
	echo
	
	## fix unifont.bdf location
	sed "s|/usr/share/fonts/unifont|${_GRUB_UEFI_UNIFONT_PATH}|g" -i "${_WD}/configure"
	echo
	
	"${_WD}/configure" ${_GRUB_UEFI_CONFIGURE_OPTIONS} ${_GRUB_UEFI_OTHER_CONFIGURE_OPTIONS} ${_GRUB_UEFI_CONFIGURE_PATHS_1} ${_GRUB_UEFI_CONFIGURE_PATHS_2}
	echo
	
	make
	echo
	
	## sed "s|${_GRUB_UEFI_MENU_CONFIG}.cfg|grub.cfg|g" -i "${_WD}/grub-core/normal/main.c" || true
	echo
	
}

_GRUB_UEFI_POSTCOMPILE_SETUP_PREFIX_DIR() {
	
	echo
	
	if [[ \
		"${_GRUB_UEFI_PREFIX_DIR}" != '/' || \
		"${_GRUB_UEFI_PREFIX_DIR}" != '/usr' || \
		"${_GRUB_UEFI_PREFIX_DIR}" != '/usr/local' || \
		"${_GRUB_UEFI_PREFIX_DIR}" != '/media' || \
		"${_GRUB_UEFI_PREFIX_DIR}" != '/mnt' || \
		"${_GRUB_UEFI_PREFIX_DIR}" != '/home' || \
		"${_GRUB_UEFI_PREFIX_DIR}" != '/lib' || \
		"${_GRUB_UEFI_PREFIX_DIR}" != '/lib64' || \
		"${_GRUB_UEFI_PREFIX_DIR}" != '/lib32' || \
		"${_GRUB_UEFI_PREFIX_DIR}" != '/tmp' || \
		"${_GRUB_UEFI_PREFIX_DIR}" != '/var' || \
		"${_GRUB_UEFI_PREFIX_DIR}" != '/run' || \
		"${_GRUB_UEFI_PREFIX_DIR}" != '/etc' || \
		"${_GRUB_UEFI_PREFIX_DIR}" != '/opt' \
		]]
	then
		sudo cp -r --verbose "${_GRUB_UEFI_PREFIX_DIR}" "${_GRUB_UEFI_UTILS_BACKUP_DIR}" || true
		echo
		
		sudo rm -rf --verbose "${_GRUB_UEFI_PREFIX_DIR}" || true
		echo
	fi
	
	sudo make install
	echo
	
	sudo install -d "${_GRUB_UEFI_SYSCONF_DIR}/default"
	
	if [[ -e "${_WD}/grub.default" ]]; then
		sudo install -D -m0644 "${_WD}/grub.default" "${_GRUB_UEFI_SYSCONF_DIR}/default/grub" || true
		echo
	fi
	
	sudo chmod --verbose -x "${_GRUB_UEFI_SYSCONF_DIR}/default/grub" || true
	echo
	
	sudo install -D -m0755 "$(which gettext.sh)" "${_GRUB_UEFI_BIN_DIR}/gettext.sh" || true
	sudo chmod --verbose -x "${_GRUB_UEFI_SYSCONF_DIR}/grub.d/README" || true
	echo
	
	# sudo "${_GRUB_UEFI_BIN_DIR}/${_GRUB_UEFI_NAME}-mkfont" --verbose --output="${_GRUB_UEFI_DATAROOT_DIR}/${_GRUB_UEFI_NAME}/unicode.pf2" "${_GRUB_UEFI_UNIFONT_PATH}/unifont.bdf" || true
	echo
	
}

_GRUB_UEFISYS_BACKUP_OLD_DIR() {
	
	## Backup the old GRUB2 folder in the UEFI System Partition
	sudo cp -r --verbose "${_GRUB_UEFISYS_PART_DIR}" "${_GRUB_UEFISYS_BACKUP_DIR}" || true
	echo
	
	## Delete the old GRUB2 folder in the UEFI System Partition
	sudo rm -rf --verbose "${_GRUB_UEFISYS_PART_DIR}" || true
	echo
	
}

_GRUB_UEFI_BOOTDIR_BACKUP_OLD_DIR() {
	
	## Backup the old GRUB2 folder in BOOTDIR
	sudo cp -r --verbose "${_GRUB_UEFI_BOOTDIR_ACTUAL}" "${_GRUB_UEFI_BOOTDIR_BACKUP_DIR}" || true
	echo
	
	## Delete the old GRUB2 folder in BOOTDIR
	sudo rm -rf --verbose "${_GRUB_UEFI_BOOTDIR_ACTUAL}" || true
	echo
	
}

_GRUB_UEFI_SETUP_STANDALONE_APP() {
	
	echo
	
	_GRUB_BOOT_PART_HINTS_STRING="$(sudo "${_GRUB_UEFI_SBIN_DIR}/${_GRUB_UEFI_NAME}-probe" --target="hints_string" "${_GRUB_UEFI_BOOTDIR_ACTUAL}/${_TARGET_UEFI_ARCH}-efi/core.efi")"
	
	echo
	
	_GRUB_BOOT_PART_RELATIVE_PREFIX="$(sudo "${_GRUB_UEFI_BIN_DIR}/${_GRUB_UEFI_NAME}-mkrelpath" "${_GRUB_UEFI_BOOTDIR_ACTUAL}")"
	
	echo
	
	cat << EOF > "${_WD}/${_GRUB_UEFI_NAME}_standalone_memdisk_config.cfg"

insmod usbms
insmod usb_keyboard

insmod part_gpt
insmod part_msdos

insmod fat
insmod iso9660
insmod udf

insmod ext2
insmod reiserfs
insmod ntfs
insmod hfsplus

search --file --no-floppy --set=grub_uefi_prefix_root ${_GRUB_BOOT_PART_HINTS_STRING} "${_GRUB_BOOT_PART_RELATIVE_PREFIX}/${_TARGET_UEFI_ARCH}-efi/core.efi"

# set prefix="(\${grub_uefi_prefix_root})/${_GRUB_BOOT_PART_RELATIVE_PREFIX}"
source "\${prefix}/${_GRUB_UEFI_MENU_CONFIG}.cfg"

EOF
	
	echo
	
	install -d "${_WD}/boot/grub" || true
	echo
	
	if [[ -e "${_WD}/boot/grub/grub.cfg" ]]; then
		mv "${_WD}/boot/grub/grub.cfg" "${_WD}/boot/grub/grub.cfg.save"
		echo
	fi
	
	dos2unix -ascii --keepdate --safe --skip-symlink --oldfile "${_WD}/${_GRUB_UEFI_NAME}_standalone_memdisk_config.cfg"
	echo
	
	install -D -m0644 "${_WD}/${_GRUB_UEFI_NAME}_standalone_memdisk_config.cfg" "${_WD}/boot/grub/grub.cfg"
	echo
	
	__WD="${PWD}/"
	echo
	
	cd "${_WD}/"
	echo
	
	## Create the grub standalone uefi application
	sudo "${_GRUB_UEFI_BIN_DIR}/${_GRUB_UEFI_NAME}-mkstandalone" --directory="${_GRUB_UEFI_LIB_DIR}/${_GRUB_UEFI_NAME}/${_TARGET_UEFI_ARCH}-efi" --format="${_TARGET_UEFI_ARCH}-efi" --compression="xz" --output="${_GRUB_UEFISYS_PART_DIR}/${_GRUB_UEFI_NAME}_standalone.efi" "boot/grub/grub.cfg"
	echo
	
	cd "${__WD}/"
	echo
	
	if [[ -e "${_WD}/boot/grub/grub.cfg.save" ]]; then
		mv "${_WD}/boot/grub/grub.cfg.save" "${_WD}/boot/grub/grub.cfg"
		echo
	fi
	
	sudo rm -f --verbose "${_GRUB_UEFISYS_PART_DIR}/${_GRUB_UEFI_NAME}_standalone.cfg" || true
	echo
	
	if [[ -e "${_WD}/${_GRUB_UEFI_NAME}_standalone_memdisk_config.cfg" ]]; then
		sudo install -D -m0644 "${_WD}/${_GRUB_UEFI_NAME}_standalone_memdisk_config.cfg" "${_GRUB_UEFISYS_PART_DIR}/${_GRUB_UEFI_NAME}_standalone.cfg"
		echo
	fi
	
	echo
	
}

_GRUB_UEFI_SETUP_UEFISYS_BOOTDIR() {
	
	echo
	
	sudo sed 's|--bootloader_id=|--bootloader-id=|g' -i "${_GRUB_UEFI_SBIN_DIR}/${_GRUB_UEFI_NAME}-install" || true
	echo
	
	## Load device-mapper kernel module - needed by grub-probe
	sudo modprobe -q dm-mod || true
	echo
	
	## Setup the GRUB2 folder in the UEFI System Partition and create the grub.efi application
	sudo "${_GRUB_UEFI_SBIN_DIR}/${_GRUB_UEFI_NAME}-install" --directory="${_GRUB_UEFI_LIB_DIR}/${_GRUB_UEFI_NAME}/${_TARGET_UEFI_ARCH}-efi" --target="${_TARGET_UEFI_ARCH}-efi" --root-directory="${_UEFI_SYSTEM_PART_MP}" --boot-directory="${_GRUB_UEFI_BOOTDIR}" --bootloader-id="${_GRUB_UEFI_NAME}" --recheck --debug
	echo
	
	echo
	
	_GRUB_UEFI_SETUP_STANDALONE_APP
	echo
	
	sudo install -D -m0644 "${_GRUB_UEFI_LIB_DIR}/${_GRUB_UEFI_NAME}/${_TARGET_UEFI_ARCH}-efi"/*.{img,sh,h} "${_GRUB_UEFI_BOOTDIR_ACTUAL}/${_TARGET_UEFI_ARCH}-efi/" || true
	echo
	
	sudo install -d "${_GRUB_UEFI_BOOTDIR_ACTUAL}/fonts" || true
	sudo install -D -m0644 "${_GRUB_UEFI_DATAROOT_DIR}/${_GRUB_UEFI_NAME}"/*.pf2 "${_GRUB_UEFI_BOOTDIR_ACTUAL}/fonts/" || true
	echo
	
	## Copy the old config file as ${_GRUB_UEFI_MENU_CONFIG}_backup.cfg
	sudo install -D -m0644 "${_GRUB_UEFI_BOOTDIR_BACKUP_DIR}/${_GRUB_UEFI_MENU_CONFIG}.cfg" "${_GRUB_UEFI_BOOTDIR_ACTUAL}/${_GRUB_UEFI_MENU_CONFIG}_backup.cfg" || true
	echo
	
	if [[ -e "${_WD}/grub.cfg" ]]; then
		sudo install -D -m0644 "${_WD}/grub.cfg" "${_GRUB_UEFI_BOOTDIR_ACTUAL}/${_GRUB_UEFI_MENU_CONFIG}.cfg" || true
		echo
	elif [[ -e "${_GRUB_UEFI_BOOTDIR_BACKUP_DIR}/${_GRUB_UEFI_MENU_CONFIG}.cfg" ]]; then
		sudo install -D -m0644 "${_GRUB_UEFI_BOOTDIR_BACKUP_DIR}/${_GRUB_UEFI_MENU_CONFIG}.cfg" "${_GRUB_UEFI_BOOTDIR_ACTUAL}/${_GRUB_UEFI_MENU_CONFIG}.cfg" || true
		echo
	else
		sudo "${_GRUB_UEFI_SBIN_DIR}/${_GRUB_UEFI_NAME}-mkconfig" --output="${_GRUB_UEFI_BOOTDIR_ACTUAL}/${_GRUB_UEFI_MENU_CONFIG}.cfg" || true
		sudo chmod 644 "${_GRUB_UEFI_BOOTDIR_ACTUAL}/${_GRUB_UEFI_MENU_CONFIG}.cfg" || true
		echo
	fi
	
	echo
	
	sudo install -d "${_GRUB_UEFI_BOOTDIR_ACTUAL}/images" || true
	sudo install -D -m0644 "${_GRUB_UEFI_BOOTDIR_BACKUP_DIR}"/*.{png,jpg,tga} "${_GRUB_UEFI_BOOTDIR_ACTUAL}/images/" || true
	echo
	
}

_GRUB_UEFI_EFIBOOTMGR() {
	
	echo
	
	_UEFISYS_PART_DEVICE="$(sudo "${_GRUB_UEFI_SBIN_DIR}/${_GRUB_UEFI_NAME}-probe" --target="device" "${_GRUB_UEFISYS_PART_DIR}/")"
	_UEFISYS_PARENT_DISK="$(sudo "${_GRUB_UEFI_SBIN_DIR}/${_GRUB_UEFI_NAME}-probe" --target="disk" "${_GRUB_UEFISYS_PART_DIR}/")"
	_UEFISYS_PART_NUM="$(sudo blkid -p -o value -s PART_ENTRY_NUMBER "${_UEFISYS_PART_DEVICE}")"
	
	## Run efibootmgr script in sh compatibility mode, does not work in bash mode in ubuntu for some unknown reason (maybe some dash vs bash issue?)
	cat << EOF > "${_WD}/grub_uefi_create_entry_efibootmgr.sh"
#!/usr/bin/env bash

set -x

modprobe -q efivars

if [[ "\$(lsmod | grep ^efivars)" ]]; then
	if [[ -d "/sys/firmware/efi/vars" ]]; then
		# Delete old entries of grub - command to be checked
		for _bootnum in \$(efibootmgr | grep '^Boot[0-9]' | fgrep -i " ${_GRUB_UEFI_NAME}" | cut -b5-8)
		do
			efibootmgr --bootnum "${_bootnum}" --delete-bootnum
		done
		
		efibootmgr --create --gpt --disk "${_UEFISYS_PARENT_DISK}" --part "${_UEFISYS_PART_NUM}" --write-signature --label "${_GRUB_UEFI_NAME}" --loader "\\\\EFI\\\\${_GRUB_UEFI_NAME}\\\\grub${_SPEC_UEFI_ARCH_NAME}.efi"
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
	
	chmod --verbose +x "${_WD}/grub_uefi_create_entry_efibootmgr.sh" || true
	
	sudo "${_WD}/grub_uefi_create_entry_efibootmgr.sh"
	
	set -x -e
	
	# rm -f --verbose "${_WD}/grub_uefi_create_entry_efibootmgr.sh"
	
	echo
	
}

_GRUB_APPLE_EFI_HFS_BLESS() {
	
	## Grub upstream bzr mactel branch => http://bzr.savannah.gnu.org/lh/grub/branches/mactel/changes
	## Fedora's mactel-boot => https://bugzilla.redhat.com/show_bug.cgi?id=755093
	
	echo
	
	echo "TODO: Apple Mac EFI Bootloader Setup"
	
	echo
	
}

_GRUB_UEFI_SETUP_UEFISYS_BOOT_EFI_APP() {
	
	if [[ ! -d "${_UEFI_SYSTEM_PART_MP}/efi/boot" ]]; then
		sudo install -d "${_UEFI_SYSTEM_PART_MP}/efi/boot/" || true
		echo
	fi
	
	sudo rm -f --verbose "${_UEFI_SYSTEM_PART_MP}/efi/boot/boot${_SPEC_UEFI_ARCH_NAME}.efi" || true
	echo
	
	if [[ -e "${_GRUB_UEFISYS_PART_DIR}/${_GRUB_UEFI_NAME}_standalone.efi" ]]; then
		sudo install -D -m0644 "${_GRUB_UEFISYS_PART_DIR}/${_GRUB_UEFI_NAME}_standalone.efi" "${_UEFI_SYSTEM_PART_MP}/efi/boot/boot${_SPEC_UEFI_ARCH_NAME}.efi"
		echo
	else
		if [[ -e "${_GRUB_UEFISYS_PART_DIR}/grub${_SPEC_UEFI_ARCH_NAME}.efi" ]]; then
			sudo install -D -m0644 "${_GRUB_UEFISYS_PART_DIR}/grub${_SPEC_UEFI_ARCH_NAME}.efi" "${_UEFI_SYSTEM_PART_MP}/efi/boot/boot${_SPEC_UEFI_ARCH_NAME}.efi"
			echo
		elif [[ -e "${_UEFI_SYSTEM_PART_MP}/efi/grub/core.efi" ]]; then
			sudo install -D -m0644 "${_UEFI_SYSTEM_PART_MP}/efi/grub/core.efi" "${_UEFI_SYSTEM_PART_MP}/efi/boot/boot${_SPEC_UEFI_ARCH_NAME}.efi"
			echo
		else
			if [[ -e "${_GRUB_UEFISYS_PART_DIR}/${_GRUB_UEFI_NAME}.efi" ]]; then
				sudo install -D -m0644 "${_GRUB_UEFISYS_PART_DIR}/${_GRUB_UEFI_NAME}.efi" "${_UEFI_SYSTEM_PART_MP}/efi/boot/boot${_SPEC_UEFI_ARCH_NAME}.efi"
				echo
			elif [[ -e "${_UEFI_SYSTEM_PART_MP}/efi/grub/grub.efi" ]]; then
				sudo install -D -m0644 "${_UEFI_SYSTEM_PART_MP}/efi/grub/grub.efi" "${_UEFI_SYSTEM_PART_MP}/efi/boot/boot${_SPEC_UEFI_ARCH_NAME}.efi"
				echo
			fi
		fi
	fi
	
	echo
	
	_GRUB_BOOT_PART_HINTS_STRING="$(sudo "${_GRUB_UEFI_SBIN_DIR}/${_GRUB_UEFI_NAME}-probe" --target="hints_string" "${_GRUB_UEFI_BOOTDIR_ACTUAL}/${_TARGET_UEFI_ARCH}-efi/core.efi")"
	
	echo
	
	_GRUB_BOOT_PART_RELATIVE_PREFIX="$(sudo "${_GRUB_UEFI_BIN_DIR}/${_GRUB_UEFI_NAME}-mkrelpath" "${_GRUB_UEFI_BOOTDIR_ACTUAL}")"
	
	echo
	
	cat << EOF > "${_WD}/${_GRUB_UEFI_NAME}_efi_boot_config.cfg"

search --file --no-floppy --set=grub_uefi_prefix_root ${_GRUB_BOOT_PART_HINTS_STRING} "${_GRUB_BOOT_PART_RELATIVE_PREFIX}/${_TARGET_UEFI_ARCH}-efi/core.efi"

set prefix="(\${grub_uefi_prefix_root})/${_GRUB_BOOT_PART_RELATIVE_PREFIX}"
source "\${prefix}/${_GRUB_UEFI_MENU_CONFIG}.cfg"

EOF
	
	echo
	
	sudo rm -f --verbose "${_UEFI_SYSTEM_PART_MP}/efi/boot/${_GRUB_UEFI_MENU_CONFIG}.cfg" || true
	echo
	
	if [[ -e "${_WD}/${_GRUB_UEFI_NAME}_efi_boot_config.cfg" ]]; then
		sudo install -D -m0644 "${_WD}/${_GRUB_UEFI_NAME}_efi_boot_config.cfg" "${_UEFI_SYSTEM_PART_MP}/efi/boot/${_GRUB_UEFI_MENU_CONFIG}.cfg"
		echo
	else
		sudo install -D -m0644 "${_GRUB_UEFISYS_PART_DIR}/${_GRUB_UEFI_MENU_CONFIG}.cfg" "${_UEFI_SYSTEM_PART_MP}/efi/boot/${_GRUB_UEFI_MENU_CONFIG}.cfg"
		echo
	fi
	
	echo
	
}

if [[ "${_PROCESS_CONTINUE}" == 'TRUE' ]]; then
	
	echo
	
	_GRUB_UEFI_SET_ENV_VARS
	
	echo
	
	_GRUB_UEFI_ECHO_CONFIG
	
	echo
	
	read -p 'Do you wish to proceed? (y/n): ' ans ## Copied from http://www.linuxjournal.com/content/asking-yesno-question-bash-script
	
	case "${ans}" in
	y | Y | yes | YES | Yes)
		echo
		echo 'Ok. Proceeding with compile and installation of GRUB2 UEFI ${_TARGET_UEFI_ARCH}.'
		echo
		
		set -x -e
		
		echo
		
		if [[ ! -d "${_GRUB_UEFI_BOOTDIR}" ]]; then
			sudo install -d "${_GRUB_UEFI_BOOTDIR}" || true
		fi
		
		echo
		
		_GRUB_UEFI_PRECOMPILE_STEPS
		
		echo
		
		_GRUB_UEFI_COMPILE_STEPS
		
		echo
		
		_GRUB_UEFI_POSTCOMPILE_SETUP_PREFIX_DIR
		
		echo
		
		_GRUB_UEFISYS_BACKUP_OLD_DIR
		
		echo
		
		_GRUB_UEFI_BOOTDIR_BACKUP_OLD_DIR
		
		echo
		
		_GRUB_UEFI_SETUP_UEFISYS_BOOTDIR(
		
		echo
		
		if [[ "${_GRUB_UEFI_CREATE_ENTRY_FIRMWARE_BOOTMGR}" == '1' ]]; then
			
			echo
			
			if [[ "$(dmidecode -s system-manufacturer)" == 'Apple Inc.' ]] || [[ "$(dmidecode -s system-manufacturer)" == 'Apple Computer, Inc.' ]]; then
				_GRUB_APPLE_EFI_HFS_BLESS
				echo
			else
				_GRUB_UEFI_EFIBOOTMGR
				echo
			fi
			
			echo
			
		fi
		
		echo
		
		_GRUB_UEFI_SETUP_UEFISYS_BOOT_EFI_APP
		
		echo
		
		sudo dos2unix -ascii --keepdate --safe --skip-symlink --oldfile "${_GRUB_UEFISYS_PART_DIR}"/*.cfg "${_UEFI_SYSTEM_PART_MP}/efi/boot"/*.cfg || true
		
		echo
		
		sudo chmod 644 "${_GRUB_UEFISYS_PART_DIR}"/*.cfg "${_UEFI_SYSTEM_PART_MP}/efi/boot"/*.cfg || true
		
		echo
		
		set +x +e
		
		if [[ -e "${_GRUB_UEFISYS_PART_DIR}/core.efi" ]] && [[ -e "${_GRUB_UEFISYS_PART_DIR}/${_GRUB_UEFI_NAME}_standalone.efi" ]]; then
			echo "GRUB2 UEFI ${_TARGET_UEFI_ARCH} Setup in ${_GRUB_UEFISYS_PART_DIR} successfully."
		fi
		
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

_GRUB_UEFI_UNSET_ENV_VARS() {
	
	unset _WD
	unset GRUB_CONTRIB
	unset _PROCESS_CONTINUE
	unset _REPLACE_GRUB_UEFI_MENU_CONFIG
	unset _GRUB_UEFI_CREATE_ENTRY_FIRMWARE_BOOTMGR
	unset _TARGET_UEFI_ARCH
	unset _UEFI_SYSTEM_PART_MP
	unset _GRUB_UEFI_BOOTDIR
	unset _GRUB_UEFI_NAME
	unset _GRUB_UEFISYS_BACKUP_DIR
	unset _GRUB_UEFI_BOOTDIR_BACKUP_DIR
	unset _GRUB_UEFI_UTILS_BACKUP_DIR
	unset _GRUB_UEFI_PREFIX_DIR
	unset _GRUB_UEFI_BIN_DIR
	unset _GRUB_UEFI_SBIN_DIR
	unset _GRUB_UEFI_SYSCONF_DIR
	unset _GRUB_UEFI_LIB_DIR
	unset _GRUB_UEFI_DATA_DIR
	unset _GRUB_UEFI_DATAROOT_DIR
	unset _GRUB_UEFI_INFO_DIR
	unset _GRUB_UEFI_LOCALE_DIR
	unset _GRUB_UEFI_MAN_DIR
	unset _GRUB_UEFISYS_RELATIVE_PREFIX
	unset _GRUB_UEFISYS_PART_DIR
	unset _GRUB_UEFI_BOOTDIR_ACTUAL
	unset _SPEC_UEFI_ARCH_NAME
	unset _GRUB_UEFI_MENU_CONFIG
	unset _GRUB_UEFI_CONFIGURE_OPTIONS
	unset _GRUB_UEFI_OTHER_CONFIGURE_OPTIONS
	unset _GRUB_UEFI_CONFIGURE_PATHS_1
	unset _GRUB_UEFI_CONFIGURE_PATHS_2
	unset _GRUB_UEFI_LST_files
	unset _GRUB_UEFI_UNIFONT_PATH
	
}

_GRUB_UEFI_UNSET_ENV_VARS
