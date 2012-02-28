#!/usr/bin/env bash

## This is a script to compile and install GRUB2 for BIOS systems. Just copy this script to the (GRUB2 Source Root dir) and run this script by passing the correct parameters. This script will be updated as and when the commands change in GRUB2 bzr repo and not just stick to any release version.

## For example if you did 'bzr branch bzr://bzr.savannah.gnu.org/grub/trunk/grub /home/user/grub'
## Then copy this script to /home/user/grub and cd into /home/user/grub and the run this script.

## This script assumes all the build dependencies to be installed and it does not try to install those for you.

## This script has configure options specific to my requirements and my system. Please read this script fully and modify it to suite your requirements. 

## For MBR partitioned disks, make sure that there is at least 1 MiB gap after the 512-byte Master Boot Record region and before the 1st Partition in the install disk. For GPT partitioned disks, create a "BIOS Boot Partition" of about 2 MiB size before running this script.

## The "GRUB2_BIOS_NAME" parameter refers to the GRUB2 folder name in the your /boot partition or /boot directory. The final GRUB2 BIOS files including core.img will be installed in /boot/<_GRUB_BIOS_NAME>/ folder, where <_GRUB_BIOS_NAME> refers to the "_GRUB_BIOS_NAME" parameter you passed to this script.

## For xman_dos2unix.sh download https://raw.github.com/the-ridikulus-rat/My_Shell_Scripts/master/xmanutility/xman_dos2unix.sh

## This script uses the 'sudo' tool at certain places so make sure you have that installed.

_SCRIPTNAME="$(basename "${0}")" 

_UPDATE_LOCALES="0"

export _PROCESS_CONTINUE='TRUE'

_USAGE() {
	
	echo
	echo "Usage : ${_SCRIPTNAME} [GRUB2_INSTALL_DEVICE] [GRUB2_BOOT_PARTITION_MOUNTPOINT] [GRUB2_BIOS_INSTALL_DIR_NAME] [GRUB2_BIOS_BACKUP_DIR_PATH] [GRUB2_BIOS_UTILS_BACKUP_DIR_PATH] [GRUB2_BIOS_PREFIX_DIR_PATH]"
	echo
	echo "Example : ${_SCRIPTNAME} /dev/sda /boot grub /media/Data_3/grub_bios_backup /media/Data_3/grub_bios_utils_backup /_grub_bios_/"
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


export _GRUB_BIOS_INSTALL_DEVICE="${1}"
export _GRUB_BIOS_BOOTDIR_PATH="${2}"
export _GRUB_BIOS_NAME="${3}"
export _GRUB_BIOS_BACKUP_DIR="${4}"
export _GRUB_BIOS_UTILS_BACKUP_DIR="${5}"
export _GRUB_BIOS_PREFIX_DIR="${6}"
## If not mentioned, _GRUB_BIOS_PREFIX_DIR env variable will be set to "/_grub_bios_/" dir


_GRUB_BIOS_SET_ENV_VARS() {
	
	export _WD="${PWD}/"
	
	## The location of grub-extras source folder if you have.
	export GRUB_CONTRIB="${_WD}/grub2_extras__GIT_BZR/"
	
	export _REPLACE_GRUB_BIOS_MENU_CONFIG='0'
	
	export _GRUB_BIOS_MENU_CONFIG='grub'
	
	if [[ "${_REPLACE_GRUB_BIOS_MENU_CONFIG}" == '1' ]]; then
		export _GRUB_BIOS_MENU_CONFIG="${_GRUB_BIOS_NAME}"
	fi
	
	if [[ "${_GRUB_BIOS_PREFIX_DIR}" == '' ]]; then
		export _GRUB_BIOS_PREFIX_DIR='/_grub_bios_/'
	fi
	
	export _GRUB_BIOS_BIN_DIR="${_GRUB_BIOS_PREFIX_DIR}/bin"
	export _GRUB_BIOS_SBIN_DIR="${_GRUB_BIOS_PREFIX_DIR}/sbin"
	export _GRUB_BIOS_SYSCONF_DIR="${_GRUB_BIOS_PREFIX_DIR}/etc"
	export _GRUB_BIOS_LIB_DIR="${_GRUB_BIOS_PREFIX_DIR}/lib"
	export _GRUB_BIOS_DATA_DIR="${_GRUB_BIOS_LIB_DIR}"
	export _GRUB_BIOS_DATAROOT_DIR="${_GRUB_BIOS_PREFIX_DIR}/share"
	export _GRUB_BIOS_INFO_DIR="${_GRUB_BIOS_DATAROOT_DIR}/info"
	export _GRUB_BIOS_LOCALE_DIR="${_GRUB_BIOS_DATAROOT_DIR}/locale"
	export _GRUB_BIOS_MAN_DIR="${_GRUB_BIOS_DATAROOT_DIR}/man"
	
	export _GRUB_BIOS_BOOTPART_DIR="${_GRUB_BIOS_BOOTDIR_PATH}/${_GRUB_BIOS_NAME}"
	export _GRUB_BIOS_CONFIGURE_OPTIONS="--with-platform="pc" --target="i386" --program-prefix="" --program-transform-name="s,grub,${_GRUB_BIOS_NAME}," --with-bootdir="${_GRUB_BIOS_BOOTDIR_PATH}" --with-grubdir="${_GRUB_BIOS_NAME}""
	export _GRUB_BIOS_OTHER_CONFIGURE_OPTIONS="--enable-mm-debug --enable-device-mapper --enable-cache-stats --enable-grub-mkfont --enable-grub-mount --enable-nls --enable-efiemu --disable-werror"
	
	export _GRUB_BIOS_CONFIGURE_PATHS_1="--prefix="${_GRUB_BIOS_PREFIX_DIR}" --bindir="${_GRUB_BIOS_BIN_DIR}" --sbindir="${_GRUB_BIOS_SBIN_DIR}" --sysconfdir="${_GRUB_BIOS_SYSCONF_DIR}" --libdir="${_GRUB_BIOS_LIB_DIR}""
	export _GRUB_BIOS_CONFIGURE_PATHS_2="--datarootdir="${_GRUB_BIOS_DATAROOT_DIR}" --infodir="${_GRUB_BIOS_INFO_DIR}" --localedir="${_GRUB_BIOS_LOCALE_DIR}" --mandir="${_GRUB_BIOS_MAN_DIR}""
	
	export _GRUB_BIOS_UNIFONT_PATH='/usr/share/fonts/misc'
	
	export _GRUB_BIOS_CORE_IMG_MODULES="part_gpt part_msdos fat ext2 ntfs ntfscomp"
	export _GRUB_BIOS_EXTRAS_MODULES="lua.mod 915resolution.mod"
	
	## _GRUB_BIOS_CORE_IMG_MODULES - These modules will be included in the core.img generated for your system. Note the maximum permitted size of core.img image is 32 KiB.
	
}

_GRUB_BIOS_ECHO_CONFIG() {
	
	echo
	echo GRUB2_INSTALL_DEVICE="${_GRUB_BIOS_INSTALL_DEVICE}"
	echo
	echo GRUB2_Boot_Partition_MountPoint="${_GRUB_BIOS_BOOTDIR_PATH}"
	echo
	echo GRUB2_BIOS_Install_Dir_Name="${_GRUB_BIOS_BOOTPART_DIR}"
	echo
	echo GRUB2_BIOS_BACKUP_DIR_Path="${_GRUB_BIOS_BACKUP_DIR}"
	echo
	echo GRUB2_BIOS_Tools_Backup_Path="${_GRUB_BIOS_UTILS_BACKUP_DIR}"
	echo
	echo GRUB2_BIOS_PREFIX_DIR_FOLDER="${_GRUB_BIOS_PREFIX_DIR}"
	echo
	
}

_GRUB_BIOS_DOS2UNIX() {
	
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

_GRUB_BIOS_PYTHON_TO_PYTHON2() {
	
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

_GRUB_BIOS_PO_LINGUAS() {
	
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

_GRUB_BIOS_PRECOMPILE_STEPS() {
	
	cd "${_WD}/"
	echo
	
	_GRUB_BIOS_DOS2UNIX
	
	_GRUB_BIOS_PYTHON_TO_PYTHON2
	
	_GRUB_BIOS_PO_LINGUAS
	
	chmod --verbose +x "${_WD}/autogen.sh" || true
	echo
	
	## GRUB2 BIOS Build Directory
	install -d "${_WD}/GRUB2_BIOS_BUILD_DIR"
	install -D -m0644 "${_WD}/grub.default" "${_WD}/GRUB2_BIOS_BUILD_DIR/grub.default" || true
	install -D -m0644 "${_WD}/grub.cfg" "${_WD}/GRUB2_BIOS_BUILD_DIR/grub.cfg" || true
	
}

_GRUB_BIOS_COMPILE_STEPS() {
	
	echo
	
	## sed "s|grub.cfg|${_GRUB_BIOS_MENU_CONFIG}.cfg|g" -i "${_WD}/grub-core/normal/main.c" || true
	echo
	
	"${_WD}/autogen.sh"
	echo
	
	cd "${_WD}/GRUB2_BIOS_BUILD_DIR"
	echo
	
	## fix unifont.bdf location
	sed "s|/usr/share/fonts/unifont|${_GRUB_BIOS_UNIFONT_PATH}|g" -i "${_WD}/configure"
	
	"${_WD}/configure" ${_GRUB_BIOS_CONFIGURE_OPTIONS} ${_GRUB_BIOS_OTHER_CONFIGURE_OPTIONS} ${_GRUB_BIOS_CONFIGURE_PATHS_1} ${_GRUB_BIOS_CONFIGURE_PATHS_2}
	echo
	
	make
	echo
	
	sed "s|${_GRUB_BIOS_MENU_CONFIG}.cfg|grub.cfg|g" -i "${_WD}/grub-core/normal/main.c" || true
	
}

_GRUB_BIOS_POSTCOMPILE_SETUP_PREFIX_DIR() {
	
	if [[ \
		"${_GRUB_BIOS_PREFIX_DIR}" != '/' || \
		"${_GRUB_BIOS_PREFIX_DIR}" != '/usr' || \
		"${_GRUB_BIOS_PREFIX_DIR}" != '/usr/local' || \
		"${_GRUB_BIOS_PREFIX_DIR}" != '/media' || \
		"${_GRUB_BIOS_PREFIX_DIR}" != '/mnt' || \
		"${_GRUB_BIOS_PREFIX_DIR}" != '/home' || \
		"${_GRUB_BIOS_PREFIX_DIR}" != '/lib' || \
		"${_GRUB_BIOS_PREFIX_DIR}" != '/lib64' || \
		"${_GRUB_BIOS_PREFIX_DIR}" != '/lib32' || \
		"${_GRUB_BIOS_PREFIX_DIR}" != '/tmp' || \
		"${_GRUB_BIOS_PREFIX_DIR}" != '/var' || \
		"${_GRUB_BIOS_PREFIX_DIR}" != '/run' || \
		"${_GRUB_BIOS_PREFIX_DIR}" != '/etc' || \
		"${_GRUB_BIOS_PREFIX_DIR}" != '/opt' \
		]]
	then
		sudo cp -r --verbose "${_GRUB_BIOS_PREFIX_DIR}" "${_GRUB_BIOS_UTILS_BACKUP_DIR}" || true
		echo
		sudo rm -rf --verbose "${_GRUB_BIOS_PREFIX_DIR}" || true
		echo
	fi
	
	sudo make install
	echo
	
	cd "${_WD}/GRUB2_BIOS_BUILD_DIR/grub-core/"
	echo
	
	sudo install -d "${_GRUB_BIOS_SYSCONF_DIR}/default"
	
	if [[ -e "${_WD}/grub.default" ]]; then
		sudo install -D -m0644 "${_WD}/grub.default" "${_GRUB_BIOS_SYSCONF_DIR}/default/grub" || true
	fi
	
	sudo chmod --verbose -x "${_GRUB_BIOS_SYSCONF_DIR}/default/grub" || true
	echo
	
	sudo install -D -m0755 "$(which gettext.sh)" "${_GRUB_BIOS_BIN_DIR}/gettext.sh" || true
	sudo chmod --verbose -x "${_GRUB_BIOS_SYSCONF_DIR}/grub.d/README" || true
	echo
	
	# sudo "${_GRUB_BIOS_BIN_DIR}/${_GRUB_BIOS_NAME}-mkfont" --verbose --output="${_GRUB_BIOS_DATAROOT_DIR}/${_GRUB_BIOS_NAME}/unicode.pf2" "${_GRUB_BIOS_UNIFONT_PATH}/unifont.bdf" || true
	echo
	
}


_GRUB_BIOS_BACKUP_OLD_DIR() {
	
	## Backup the old GRUB2 folder in the /boot folder.
	sudo cp -r --verbose "${_GRUB_BIOS_BOOTPART_DIR}" "${_GRUB_BIOS_BACKUP_DIR}" || true
	echo
	
	## Delete the old GRUB2 folder in the /boot folder.
	sudo rm -rf --verbose "${_GRUB_BIOS_BOOTPART_DIR}" || true
	echo
	
}

_GRUB_BIOS_SETUP_BOOT_PART_DIR() {
	
	## Load device-mapper kernel module - needed by grub-probe
	sudo modprobe -q dm-mod || true
	
	## Setup the GRUB2 folder in the /boot directory, create the core.img image and embed the image in the disk.
	sudo "${_GRUB_BIOS_SBIN_DIR}/${_GRUB_BIOS_NAME}-install" --directory="${_GRUB_BIOS_LIB_DIR}/${_GRUB_BIOS_NAME}/i386-pc" --target="i386-pc" --modules="${_GRUB_BIOS_CORE_IMG_MODULES}" --boot-directory="${_GRUB_BIOS_BOOTDIR_PATH}" --no-floppy --recheck --debug "${_GRUB_BIOS_INSTALL_DEVICE}"
	echo
	
	sudo install -D -m0644 "${_GRUB_BIOS_LIB_DIR}/${_GRUB_BIOS_NAME}/i386-pc"/*.{img,sh,h} "${_GRUB_BIOS_BOOTPART_DIR}/i386-pc/" || true
	echo
	
	sudo install -d "${_GRUB_BIOS_BOOTPART_DIR}/fonts"
	sudo install -D -m0644 "${_GRUB_BIOS_DATAROOT_DIR}/${_GRUB_BIOS_NAME}"/*.pf2 "${_GRUB_BIOS_BOOTPART_DIR}/fonts/" || true
	echo
	
	sudo install -D -m0644 "${_GRUB_BIOS_BACKUP_DIR}/${_GRUB_BIOS_MENU_CONFIG}.cfg" "${_GRUB_BIOS_BOOTPART_DIR}/${_GRUB_BIOS_MENU_CONFIG}_backup.cfg" || true
	# sudo install -D -m0644 "${_GRUB_BIOS_BACKUP_DIR}/${_GRUB_BIOS_MENU_CONFIG}.cfg" "${_GRUB_BIOS_BOOTPART_DIR}/${_GRUB_BIOS_MENU_CONFIG}.cfg" || true
	
	if [[ -e "${_WD}/grub.cfg" ]]; then
		sudo install -D -m0644 "${_WD}/grub.cfg" "${_GRUB_BIOS_BOOTPART_DIR}/${_GRUB_BIOS_MENU_CONFIG}.cfg" || true
	fi
	
	# sudo "${_GRUB_BIOS_SBIN_DIR}/${_GRUB_BIOS_NAME}-mkconfig" --output="${_GRUB_BIOS_BOOTPART_DIR}/${_GRUB_BIOS_MENU_CONFIG}.cfg" || true
	# sudo chmod 644 "${_GRUB_BIOS_BOOTPART_DIR}/${_GRUB_BIOS_MENU_CONFIG}.cfg" || true
	echo
	
	sudo dos2unix -ascii --keepdate --safe --skip-symlink --oldfile "${_GRUB_BIOS_BOOTPART_DIR}"/*.cfg || true
	echo
	
	sudo chmod 644 "${_GRUB_BIOS_BOOTPART_DIR}"/*.cfg || true
	echo
	
	sudo install -d "${_GRUB_BIOS_BOOTPART_DIR}/images"
	sudo install -D -m0644 "${_GRUB_BIOS_BACKUP_DIR}"/*.{png,jpg,tga} "${_GRUB_BIOS_BOOTPART_DIR}/images/" || true
	echo
	
}

if [[ "${_PROCESS_CONTINUE}" == 'TRUE' ]]; then
	
	echo
	
	_GRUB_BIOS_SET_ENV_VARS
	
	echo
	
	_GRUB_BIOS_ECHO_CONFIG
	
	echo
	
	read -p 'Do you wish to proceed? (y/n): ' ans # Copied from http://www.linuxjournal.com/content/asking-yesno-question-bash-script
	
	case "${ans}" in
	y | Y | yes | YES | Yes)
		echo
		echo 'Ok. Proceeding with compile and installation of GRUB2 BIOS.'
		echo
		
		set -x -e
		
		echo
		
		if [[ ! -d "${_GRUB_BIOS_BOOTDIR_PATH}" ]]; then
			sudo install -d "${_GRUB_BIOS_BOOTDIR_PATH}" || true
		fi
		
		echo
		
		_GRUB_BIOS_PRECOMPILE_STEPS
		
		echo
		
		_GRUB_BIOS_COMPILE_STEPS
		
		echo
		
		_GRUB_BIOS_POSTCOMPILE_SETUP_PREFIX_DIR
		
		echo
		
		_GRUB_BIOS_BACKUP_OLD_DIR
		
		echo
		
		_GRUB_BIOS_SETUP_BOOT_PART_DIR
		
		echo
		
		set +x +e
		
		echo "GRUB2 BIOS setup in ${_GRUB_BIOS_BOOTPART_DIR} successfully."
		
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
		echo
	;;
	esac # ends the case list
	
fi

_GRUB_BIOS_UNSET_ENV_VARS() {
	
	unset _WD
	unset GRUB_CONTRIB
	unset _PROCESS_CONTINUE
	unset _GRUB_BIOS_INSTALL_DEVICE
	unset _GRUB_BIOS_BOOTDIR_PATH
	unset _GRUB_BIOS_NAME
	unset _GRUB_BIOS_BACKUP_DIR
	unset _GRUB_BIOS_UTILS_BACKUP_DIR
	unset _GRUB_BIOS_PREFIX_DIR
	unset _GRUB_BIOS_BIN_DIR
	unset _GRUB_BIOS_SBIN_DIR
	unset _GRUB_BIOS_SYSCONF_DIR
	unset _GRUB_BIOS_LIB_DIR
	unset _GRUB_BIOS_DATA_DIR
	unset _GRUB_BIOS_DATAROOT_DIR
	unset _GRUB_BIOS_INFO_DIR
	unset _GRUB_BIOS_LOCALE_DIR
	unset _GRUB_BIOS_MAN_DIR
	unset _GRUB_BIOS_MENU_CONFIG
	unset _GRUB_BIOS_BOOTPART_DIR
	unset _GRUB_BIOS_CONFIGURE_OPTIONS
	unset _GRUB_BIOS_OTHER_CONFIGURE_OPTIONS
	unset _GRUB_BIOS_CONFIGURE_PATHS_1
	unset _GRUB_BIOS_CONFIGURE_PATHS_2
	unset _GRUB_BIOS_CORE_IMG_MODULES
	unset _GRUB_BIOS_EXTRAS_MODULES
	unset _GRUB_BIOS_UNIFONT_PATH
	
}

_GRUB_BIOS_UNSET_ENV_VARS