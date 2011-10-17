#!/bin/bash

## This is a script to compile and install GRUB2 for BIOS systems. Just copy this script to the (GRUB2 Source Root dir) and run this script by passing the correct parameters. This script will be updated as and when the commands change in GRUB2 bzr repo and not just stick to any release version.

## For example if you did 'bzr branch bzr://bzr.savannah.gnu.org/grub/trunk/grub /home/user/grub'
## Then copy this script to /home/user/grub and cd into /home/user/grub and the run this script.

## This script assumes all the build dependencies to be installed and it does not try to install those for you.

## This script has configure options specific to my requirements and my system. Please read this script fully and modify it to suite your requirements. 

## For MBR partitioned disks, make sure that there is at least 1 MiB gap after the 512-byte Master Boot Record region and before the 1st Partition in the install disk. For GPT partitioned disks, create a "BIOS Boot Partition" of about 2 MiB size before running this script.

## The "GRUB2_BIOS_NAME" parameter refers to the GRUB2 folder name in the your /boot partition or /boot directory. The final GRUB2 BIOS files including core.img will be installed in /boot/<_GRUB2_BIOS_NAME>/ folder, where <_GRUB2_BIOS_NAME> refers to the "_GRUB2_BIOS_NAME" parameter you passed to this script.

## For xman_dos2unix.sh download https://raw.github.com/the-ridikulus-rat/My_Shell_Scripts/master/xmanutility/xman_dos2unix.sh

## This script uses the 'sudo' tool at certain places so make sure you have that installed.

_SCRIPTNAME="$(basename "${0}")" 

export _PROCESS_CONTINUE="TRUE"

_USAGE() {
	
	echo
	echo "Usage : ${_SCRIPTNAME} [GRUB2_INSTALL_DEVICE] [GRUB2_BOOT_PARTITION_MOUNTPOINT] [GRUB2_BIOS_INSTALL_DIR_NAME] [GRUB2_BIOS_BACKUP_DIR_PATH] [GRUB2_BIOS_UTILS_BACKUP_DIR_PATH] [GRUB2_BIOS_PREFIX_DIR_PATH]"
	echo
	echo "Example : ${_SCRIPTNAME} /dev/sda /boot grub_bios /media/Data_3/grub_bios_backup /media/Data_3/grub_bios_utils_backup /_grub_/grub_bios"
	echo
	echo "For example if you did 'bzr branch bzr://bzr.savannah.gnu.org/grub/trunk/grub /home/user/grub'"
	echo "Then copy this script to /home/user/grub and cd into /home/user/grub and then run this script from /home/user/grub."
	echo
	echo "This script uses the 'sudo' tool at certain places so make sure you have that installed."
	echo
	echo "Please read this script fully and modify it to suite your requirements before actually running it"
	echo
	export _PROCESS_CONTINUE="FALSE"
	
}

if [ \
	"${1}" == "" -o \
	"${1}" == "-h" -o \
	"${1}" == "-u" -o \
	"${1}" == "--help" -o \
	"${1}" == "--usage" \
	]
then
	_USAGE
	export _PROCESS_CONTINUE="FALSE"
	exit 0
fi

# _GRUB2_BIOS_SET_ENV_VARS() {
	
	export _WD="${PWD}/"
	
	## The location of grub-extras source folder if you have.
	export GRUB_CONTRIB="${_WD}/grub2_extras__GIT_BZR/"
	
	export _REPLACE_GRUB2_BIOS_MENU_CONFIG="0"
	
	export _GRUB2_INSTALL_DEVICE="${1}"
	export _GRUB2_BOOT_PART_MP="${2}"
	export _GRUB2_BIOS_NAME="${3}"
	export _GRUB2_BIOS_BACKUP_DIR="${4}"
	export _GRUB2_BIOS_UTILS_BACKUP_DIR="${5}"
	export _GRUB2_BIOS_PREFIX_DIR="${6}"
	## If not mentioned, _GRUB2_BIOS_PREFIX_DIR env variable will be set to /grub2/grub2_BIOS dir
	
	export _GRUB2_BIOS_MENU_CONFIG="grub"
	[ "${_REPLACE_GRUB2_BIOS_MENU_CONFIG}" == "1" ] && _GRUB2_BIOS_MENU_CONFIG="${_GRUB2_BIOS_NAME}"
	
	[ "${_GRUB2_BIOS_PREFIX_DIR}" == "" ] && export _GRUB2_BIOS_PREFIX_DIR="/grub2/grub2_bios"
	
	export _GRUB2_BIOS_BIN_DIR="${_GRUB2_BIOS_PREFIX_DIR}/bin"
	export _GRUB2_BIOS_SBIN_DIR="${_GRUB2_BIOS_PREFIX_DIR}/sbin"
	export _GRUB2_BIOS_SYSCONF_DIR="${_GRUB2_BIOS_PREFIX_DIR}/etc"
	export _GRUB2_BIOS_LIB_DIR="${_GRUB2_BIOS_PREFIX_DIR}/lib"
	export _GRUB2_BIOS_DATAROOT_DIR="${_GRUB2_BIOS_PREFIX_DIR}/share"
	export _GRUB2_BIOS_INFO_DIR="${_GRUB2_BIOS_DATAROOT_DIR}/info"
	export _GRUB2_BIOS_LOCALE_DIR="${_GRUB2_BIOS_DATAROOT_DIR}/locale"
	export _GRUB2_BIOS_MAN_DIR="${_GRUB2_BIOS_DATAROOT_DIR}/man"
	
	export _GRUB2_BOOT_PART_DIR="${_GRUB2_BOOT_PART_MP}/${_GRUB2_BIOS_NAME}"
	export _GRUB2_BIOS_CONFIGURE_OPTIONS="--with-platform=pc --program-prefix="" --program-transform-name=s,grub,${_GRUB2_BIOS_NAME},"
	export _GRUB2_BIOS_OTHER_CONFIGURE_OPTIONS="--enable-mm-debug --enable-device-mapper --enable-cache-stats --enable-grub-mkfont --disable-nls"
	
	export _GRUB2_BIOS_CONFIGURE_PATHS_1="--prefix="${_GRUB2_BIOS_PREFIX_DIR}" --bindir="${_GRUB2_BIOS_BIN_DIR}" --sbindir="${_GRUB2_BIOS_SBIN_DIR}" --sysconfdir="${_GRUB2_BIOS_SYSCONF_DIR}" --libdir="${_GRUB2_BIOS_LIB_DIR}""
	export _GRUB2_BIOS_CONFIGURE_PATHS_2="--datarootdir="${_GRUB2_BIOS_DATAROOT_DIR}" --infodir="${_GRUB2_BIOS_INFO_DIR}" --localedir="${_GRUB2_BIOS_LOCALE_DIR}" --mandir="${_GRUB2_BIOS_MAN_DIR}""
	
	export _GRUB2_UNIFONT_PATH="/usr/share/fonts/misc"
	
	export _GRUB2_BIOS_CORE_IMG_MODULES="part_gpt part_msdos fat ext2 ntfs ntfscomp"
	export _GRUB2_EXTRAS_MODULES="lua.mod 915resolution.mod"
	
	## _GRUB2_BIOS_CORE_IMG_MODULES - Those modules that will be included in the core.img image generated for your system. Note the maximum permitted size of core.img image is 32 KB.
	
# }

# _GRUB2_BIOS_ECHO_CONFIG() {
	
	echo
	echo _GRUB2_INSTALL_DEVICE="${_GRUB2_INSTALL_DEVICE}"
	echo
	echo _GRUB2_Boot_Partition_MountPoint="${_GRUB2_BOOT_PART_MP}"
	echo
	echo _GRUB2_BIOS_Install_Dir_Name="${_GRUB2_BOOT_PART_DIR}"
	echo
	echo _GRUB2_BIOS_BACKUP_DIR_Path="${_GRUB2_BIOS_BACKUP_DIR}"
	echo
	echo _GRUB2_BIOS_Tools_Backup_Path="${_GRUB2_BIOS_UTILS_BACKUP_DIR}"
	echo
	echo _GRUB2_BIOS_PREFIX_DIR_FOLDER="${_GRUB2_BIOS_PREFIX_DIR}"
	echo
	
# }

_GRUB2_BIOS_PRECOMPILE_STEPS() {
	
	set -x -e
	
	cd "${_WD}/"
	
	## Convert the line endings of all the source files from DOS to UNIX mode
	[ ! -e "${_WD}/xman_dos2unix.sh" ] && wget --no-check-certificate --output-file="${_WD}/xman_dos2unix.sh" "https://raw.github.com/the-ridikulus-rat/My_Shell_Scripts/master/xmanutility/xman_dos2unix.sh" || true
	chmod +x "${_WD}/xman_dos2unix.sh" || true
	"${_WD}/xman_dos2unix.sh" * || true
	echo
	
	## Check whether python2 exists, otherwise create /usr/bin/python2 symlink to python executable 
	# [ "$(which python2)" ] || sudo ln -s "$(which python)" "/usr/bin/python2"
	
	## Archlinux changed default /usr/bin/python to python3, need to use /usr/bin/python2 instead
	# if [ "$(which python2)" ]
	# then
	# 	install -D -m755 "${_WD}/autogen.sh" "${_WD}/autogen_unmodified.sh"
	# 	sed 's|python |python2 |g' -i "${_WD}/autogen.sh" || true
	# fi
	
	chmod +x "${_WD}/autogen.sh" || true
	
	if [ ! -e "${_WD}/po/LINGUAS" ]
	then
		cd "${_WD}/"
		rsync -Lrtvz translationproject.org::tp/latest/grub/ "${_WD}/po" || true
		(cd "${_WD}/po" && ls *.po | cut -d. -f1 | xargs) > "${_WD}/po/LINGUAS" || true
	fi
	
	"${_WD}/autogen.sh"
	echo
	
	## GRUB2 BIOS Build Directory
	install -d "${P_WD}/_GRUB2_BIOS_BUILD_DIR"
	cp --verbose "${_WD}/grub.default" "${_WD}/_GRUB2_BIOS_BUILD_DIR/" || true
	cp --verbose "${_WD}/grub.cfg" "${_WD}/_GRUB2_BIOS_BUILD_DIR/" || true
	
}

_GRUB2_BIOS_COMPILE_STEPS() {
	
	## Uncomment below to use ${_GRUB2_BIOS_MENU_CONFIG}.cfg as the menu config file instead of grub.cfg
	sed "s|grub.cfg|${_GRUB2_BIOS_MENU_CONFIG}.cfg|g" -i "${_WD}/grub-core/normal/main.c" || true
	
	cd _GRUB2_BIOS_BUILD_DIR
	echo
	
	## fix unifont.bdf location
	sed "s|/usr/share/fonts/unifont|${_GRUB2_UNIFONT_PATH}|g" -i "${_WD}/configure"
	
	"${_WD}/configure" ${_GRUB2_BIOS_CONFIGURE_OPTIONS} ${_GRUB2_BIOS_OTHER_CONFIGURE_OPTIONS} ${_GRUB2_BIOS_CONFIGURE_PATHS_1} ${_GRUB2_BIOS_CONFIGURE_PATHS_2}
	echo
	
	make
	echo
	
	sed "s|${_GRUB2_BIOS_MENU_CONFIG}.cfg|grub.cfg|g" -i "${_WD}/grub-core/normal/main.c" || true
	
}

_GRUB2_BIOS_POSTCOMPILE_SETUP_PREFIX_DIR() {
	
	if [ \
		"${_GRUB2_BIOS_PREFIX_DIR}" != '/' -o \
		"${_GRUB2_BIOS_PREFIX_DIR}" != '/usr' -o \
		"${_GRUB2_BIOS_PREFIX_DIR}" != '/usr/local' -o \
		"${_GRUB2_BIOS_PREFIX_DIR}" != '/media' -o \
		"${_GRUB2_BIOS_PREFIX_DIR}" != '/mnt' -o \
		"${_GRUB2_BIOS_PREFIX_DIR}" != '/home' -o \
		"${_GRUB2_BIOS_PREFIX_DIR}" != '/lib' -o \
		"${_GRUB2_BIOS_PREFIX_DIR}" != '/lib64' -o \
		"${_GRUB2_BIOS_PREFIX_DIR}" != '/lib32' -o \
		"${_GRUB2_BIOS_PREFIX_DIR}" != '/tmp' -o \
		"${_GRUB2_BIOS_PREFIX_DIR}" != '/var' -o \
		"${_GRUB2_BIOS_PREFIX_DIR}" != '/run' -o \
		"${_GRUB2_BIOS_PREFIX_DIR}" != '/etc' -o \
		"${_GRUB2_BIOS_PREFIX_DIR}" != '/opt' \
		]
	then
		sudo cp -r --verbose "${_GRUB2_BIOS_PREFIX_DIR}" "${_GRUB2_BIOS_UTILS_BACKUP_DIR}" || true
		echo
		sudo rm -rf --verbose "${_GRUB2_BIOS_PREFIX_DIR}" || true
		echo
	fi
	
	sudo make install
	echo
	
	cd "${_WD}/_GRUB2_BIOS_BUILD_DIR/grub-core/"
	# sudo cp --verbose ${_GRUB2_EXTRAS_MODULES} "${_GRUB2_BIOS_LIB_DIR}/${_GRUB2_BIOS_NAME}/i386-pc/" || true
	echo
	
	sudo install -d "${_GRUB2_BIOS_SYSCONF_DIR}/default"
	[ -e "${_WD}/grub.default" ] && sudo cp --verbose "${_WD}/grub.default" "${_GRUB2_BIOS_SYSCONF_DIR}/default/grub" || true
	sudo chmod --verbose -x "${_GRUB2_BIOS_SYSCONF_DIR}/default/grub" || true
	echo
	
	sudo cp --verbose "$(which gettext.sh)" "${_GRUB2_BIOS_BIN_DIR}/" || true
	sudo chmod --verbose -x "${_GRUB2_BIOS_SYSCONF_DIR}/grub.d/README" || true
	echo
	
	# sudo "${_GRUB2_BIOS_BIN_DIR}/${_GRUB2_BIOS_NAME}-mkfont" --verbose --output="${_GRUB2_BIOS_DATAROOT_DIR}/${_GRUB2_BIOS_NAME}/unicode.pf2" "${_GRUB2_UNIFONT_PATH}/unifont.bdf" || true
	echo
	# sudo "${_GRUB2_BIOS_BIN_DIR}/${_GRUB2_BIOS_NAME}-mkfont" --verbose --ascii-bitmaps --output=""${_GRUB2_BIOS_DATAROOT_DIR}/${_GRUB2_BIOS_NAME}/ascii.pf2" "${_GRUB2_UNIFONT_PATH}/unifont.bdf" || true
	echo
	
}


_GRUB2_BIOS_BACKUP_OLD_DIR() {
	
	## Backup the old GRUB2 folder in the /boot folder.
	sudo cp -r --verbose "${_GRUB2_BOOT_PART_DIR}" "${_GRUB2_BIOS_BACKUP_DIR}" || true
	echo
	
	## Delete the old GRUB2 folder in the /boot folder.
	sudo rm -rf --verbose "${_GRUB2_BOOT_PART_DIR}" || true
	echo
	
}

_GRUB2_BIOS_SETUP_BOOT_PART_DIR() {
	
	## Load device-mapper kernel module - needed by grub-probe
	sudo modprobe -q dm-mod || true
	
	sudo "${_GRUB2_BIOS_SBIN_DIR}/${_GRUB2_BIOS_NAME}-install" --modules="${_GRUB2_BIOS_CORE_IMG_MODULES}" --boot-directory="${_GRUB2_BOOT_PART_MP}" --no-floppy --recheck --debug "${_GRUB2_INSTALL_DEVICE}" # Setup the GRUB2 folder in the /boot directory, create the core.img image and embed the image in the disk.
	echo
	
	sudo cp "${_GRUB2_BIOS_DATAROOT_DIR}/${_GRUB2_BIOS_NAME}"/*.pf2 "${_GRUB2_BOOT_PART_DIR}/" || true
	echo
	
	sudo cp --verbose "${_GRUB2_BIOS_BACKUP_DIR}/${_GRUB2_BIOS_MENU_CONFIG}.cfg" "${_GRUB2_BOOT_PART_DIR}/${_GRUB2_BIOS_MENU_CONFIG}_backup.cfg" || true
	# sudo cp --verbose "${_GRUB2_BIOS_BACKUP_DIR}/${_GRUB2_BIOS_MENU_CONFIG}.cfg" "${_GRUB2_BOOT_PART_DIR}/${_GRUB2_BIOS_MENU_CONFIG}.cfg" || true
	
	[ -e "${_WD}/grub.cfg" ] && sudo cp --verbose "${_WD}/grub.cfg" "${_GRUB2_BOOT_PART_DIR}/${_GRUB2_BIOS_MENU_CONFIG}.cfg" || true
	
	# sudo ${_GRUB2_BIOS_SBIN_DIR}/${_GRUB2_BIOS_NAME}-mkconfig --output=${_GRUB2_BOOT_PART_DIR}/${_GRUB2_BIOS_MENU_CONFIG}.cfg || true
	echo
	
	sudo chmod --verbose -x "${_GRUB2_BOOT_PART_DIR}/${_GRUB2_BIOS_MENU_CONFIG}.cfg" || true
	echo
	
	sudo cp --verbose "${_GRUB2_BIOS_BACKUP_DIR}"/*.{png,jpg,tga} "${_GRUB2_BOOT_PART_DIR}/" || true
	echo
	
}

if [ "${_PROCESS_CONTINUE}" == "TRUE" ]
then
	
	echo
	
	# _GRUB2_BIOS_SET_ENV_VARS
	
	echo
	
	# _GRUB2_BIOS_ECHO_CONFIG
	
	echo
	
	read -p "Do you wish to proceed? (y/n): " ans # Copied from http://www.linuxjournal.com/content/asking-yesno-question-bash-script
	
	case "${ans}" in
	y | Y | yes | YES | Yes)
	echo "Ok. Proceeding with compile and installation of GRUB2 BIOS."
	echo
	
	_GRUB2_BIOS_PRECOMPILE_STEPS
	
	echo
	
	_GRUB2_BIOS_COMPILE_STEPS
	
	echo
	
	_GRUB2_BIOS_POSTCOMPILE_SETUP_PREFIX_DIR
	
	echo
	
	_GRUB2_BIOS_BACKUP_OLD_DIR
	
	echo
	
	_GRUB2_BIOS_SETUP_BOOT_PART_DIR
	
	echo
	
	set +x +e
	
	echo "GRUB2 BIOS setup in ${_GRUB2_BOOT_PART_DIR} successfully."
	
	echo
	
	;; # End of "y" option in the case list
	
	n | N | no | NO | No)
	echo "You said no. Exiting to shell."
	;; # End of "n" option in the case list
	
	*) # Any other input
	echo "Invalid answer. Exiting to shell."
	;;
	esac # ends the case list
	
fi

# _GRUB2_BIOS_UNSET_ENV_VARS() {
	
	unset _WD
	unset GRUB_CONTRIB
	unset _PROCESS_CONTINUE
	unset _GRUB2_INSTALL_DEVICE
	unset _GRUB2_BOOT_PART_MP
	unset _GRUB2_BIOS_NAME
	unset _GRUB2_BIOS_BACKUP_DIR
	unset _GRUB2_BIOS_UTILS_BACKUP_DIR
	unset _GRUB2_BIOS_PREFIX_DIR
	unset _GRUB2_BIOS_BIN_DIR
	unset _GRUB2_BIOS_SBIN_DIR
	unset _GRUB2_BIOS_SYSCONF_DIR
	unset _GRUB2_BIOS_LIB_DIR
	unset _GRUB2_BIOS_DATAROOT_DIR
	unset _GRUB2_BIOS_INFO_DIR
	unset _GRUB2_BIOS_LOCALE_DIR
	unset _GRUB2_BIOS_MAN_DIR
	unset _GRUB2_BIOS_MENU_CONFIG
	unset _GRUB2_BOOT_PART_DIR
	unset _GRUB2_BIOS_CONFIGURE_OPTIONS
	unset _GRUB2_BIOS_OTHER_CONFIGURE_OPTIONS
	unset _GRUB2_BIOS_CONFIGURE_PATHS_1
	unset _GRUB2_BIOS_CONFIGURE_PATHS_2
	unset _GRUB2_BIOS_CORE_IMG_MODULES
	unset _GRUB2_EXTRAS_MODULES
	unset _GRUB2_UNIFONT_PATH
	
# }

# _GRUB2_BIOS_UNSET_ENV_VARS
