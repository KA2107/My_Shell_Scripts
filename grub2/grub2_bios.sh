#!/bin/bash

## This is a script to compile and install GRUB2 for BIOS systems. Just copy this script to the (GRUB2 Source Root dir) and run this script by passing the correct parameters. This script will be updated as and when the commands change in GRUB2 bzr repo and not just stick to any release version.

## For example if you did 'bzr branch bzr://bzr.savannah.gnu.org/grub/trunk/grub /home/user/grub'
## Then copy this script to /home/user/grub and cd into /home/user/grub and the run this script.

## This script assumes all the build dependencies to be installed and it does not try to install those for you.

## This script has configure options specific to my requirements and my system. Please read this script fully and modify it to suite your requirements. 

## For MBR partitioned disks, make sure the 63-sector gap exists after the 1st 512-byte MBR region. For GPT partitioned disks, create a "BIOS Boot Partition" of about 1 MB size before running this script.

## The "GRUB2_BIOS_NAME" parameter refers to the GRUB2 folder name in the your /boot partition or /boot directory. The final GRUB2 BIOS files including core.img will be installed in /boot/<GRUB2_BIOS_NAME>/ folder, where <GRUB2_BIOS_NAME> refers to the "GRUB2_BIOS_NAME" parameter you passed to this script.

## For xman_dos2unix.sh download https://raw.github.com/skodabenz/My_Shell_Scripts/master/xmanutility/xman_dos2unix.sh

## This script uses the 'sudo' tool at certain places so make sure you have that installed.

SCRIPTNAME="$(basename "${0}")" 

export PROCESS_CONTINUE="TRUE"

_USAGE() {
	
	echo
	echo Usage : ${SCRIPTNAME} [GRUB2_Install_Device] [GRUB2_Boot_Partition_MountPoint] [GRUB2_BIOS_Install_Dir_Name] [GRUB2_BIOS_Backup_Path] [GRUB2_BIOS_Tools_Backup_Path] [GRUB2_BIOS_PREFIX_DIR_Path]
	echo
	echo Example : ${SCRIPTNAME} /dev/sda /boot grub2 /media/Data_3/grub2_BIOS_Backup /media/Data_3/grub2_BIOS_Tools_Backup /grub2/grub2_BIOS
	echo
	echo "For example if you did 'bzr branch bzr://bzr.savannah.gnu.org/grub/trunk/grub /home/user/grub'"
	echo "Then copy this script to /home/user/grub and cd into /home/user/grub and then run this script from /home/user/grub."
	echo
	echo "This script uses the 'sudo' tool at certain places so make sure you have that installed."
	echo
	echo "Please read this script fully and modify it to suite your requirements before actually running it"
	echo
	export PROCESS_CONTINUE="FALSE"
	
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
	exit 0
fi

# _GRUB2_BIOS_SET_ENV_VARS() {
	
	export WD="${PWD}/"
	
	## The location of grub-extras source folder if you have.
	export GRUB_CONTRIB="${WD}/grub2_extras__GIT_BZR/"
	
	export REPLACE_GRUB2_BIOS_MENU_CONFIG="0"
	
	export GRUB2_Install_Device="${1}"
	export GRUB2_Boot_Part_MP="${2}"
	export GRUB2_BIOS_NAME="${3}"
	export GRUB2_BIOS_Backup="${4}"
	export GRUB2_BIOS_TOOLS_Backup="${5}"
	export GRUB2_BIOS_PREFIX_DIR="${6}"
	## If not mentioned, GRUB2_BIOS_PREFIX_DIR env variable will be set to /grub2/grub2_BIOS dir
	
	export GRUB2_BIOS_MENU_CONFIG="grub"
	[ "${REPLACE_GRUB2_BIOS_MENU_CONFIG}" == "1" ] && GRUB2_BIOS_MENU_CONFIG="${GRUB2_BIOS_NAME}"
	
	[ "${GRUB2_BIOS_PREFIX_DIR}" == "" ] && export GRUB2_BIOS_PREFIX_DIR="/grub2/grub2_bios"
	
	export GRUB2_BIOS_BIN_DIR="${GRUB2_BIOS_PREFIX_DIR}/bin"
	export GRUB2_BIOS_SBIN_DIR="${GRUB2_BIOS_PREFIX_DIR}/sbin"
	export GRUB2_BIOS_SYSCONF_DIR="${GRUB2_BIOS_PREFIX_DIR}/etc"
	export GRUB2_BIOS_LIB_DIR="${GRUB2_BIOS_PREFIX_DIR}/lib"
	export GRUB2_BIOS_DATAROOT_DIR="${GRUB2_BIOS_PREFIX_DIR}/share"
	export GRUB2_BIOS_INFO_DIR="${GRUB2_BIOS_DATAROOT_DIR}/info"
	export GRUB2_BIOS_LOCALE_DIR="${GRUB2_BIOS_DATAROOT_DIR}/locale"
	export GRUB2_BIOS_MAN_DIR="${GRUB2_BIOS_DATAROOT_DIR}/man"
	
	export GRUB2_BOOT_PART_DIR="${GRUB2_Boot_Part_MP}/${GRUB2_BIOS_NAME}"
	export GRUB2_BIOS_Configure_Flags="--with-platform=pc --program-transform-name=s,grub,${GRUB2_BIOS_NAME},"
	export GRUB2_Other_BIOS_Configure_Flags="--enable-mm-debug --enable-grub-mkfont --disable-nls"
	
	export GRUB2_BIOS_Configure_PATHS_1="--prefix="${GRUB2_BIOS_PREFIX_DIR}" --bindir="${GRUB2_BIOS_BIN_DIR}" --sbindir="${GRUB2_BIOS_SBIN_DIR}" --sysconfdir="${GRUB2_BIOS_SYSCONF_DIR}" --libdir="${GRUB2_BIOS_LIB_DIR}""
	export GRUB2_BIOS_Configure_PATHS_2="--datarootdir="${GRUB2_BIOS_DATAROOT_DIR}" --infodir="${GRUB2_BIOS_INFO_DIR}" --localedir="${GRUB2_BIOS_LOCALE_DIR}" --mandir="${GRUB2_BIOS_MAN_DIR}""
	
	export GRUB2_UNIFONT_PATH="/usr/share/fonts/misc"
	
	export GRUB2_BIOS_CORE_IMG_MODULES="part_gpt part_msdos fat ext2 ntfs ntfscomp"
	export GRUB2_EXTRAS_MODULES="lua.mod 915resolution.mod"
	
	## GRUB2_BIOS_CORE_IMG_MODULES - Those modules that will be included in the core.img image generated for your system. Note the maximum permitted size of core.img image is 32 KB.
	
# }

# _GRUB2_BIOS_ECHO_CONFIG() {
	
	echo
	echo GRUB2_Install_Device="${GRUB2_Install_Device}"
	echo
	echo GRUB2_Boot_Partition_MountPoint="${GRUB2_Boot_Part_MP}"
	echo
	echo GRUB2_BIOS_Install_Dir_Name="${GRUB2_BOOT_PART_DIR}"
	echo
	echo GRUB2_BIOS_Backup_Path="${GRUB2_BIOS_Backup}"
	echo
	echo GRUB2_BIOS_Tools_Backup_Path="${GRUB2_BIOS_TOOLS_Backup}"
	echo
	echo GRUB2_BIOS_PREFIX_DIR_FOLDER="${GRUB2_BIOS_PREFIX_DIR}"
	echo
	
# }

_GRUB2_BIOS_PRECOMPILE_STEPS() {
	
	## Load device-mapper kernel module - needed by grub-probe
	sudo modprobe -q dm-mod || true
	
	set -x -e
	
	cd "${WD}/"
	
	## Convert the line endings of all the source files from DOS to UNIX mode
	[ ! -e "${WD}/xman_dos2unix.sh" ] && wget --no-check-certificate --output-file="${WD}/xman_dos2unix.sh" "https://raw.github.com/skodabenz/My_Shell_Scripts/master/xmanutility/xman_dos2unix.sh" || true
	chmod +x "${WD}/xman_dos2unix.sh" || true
	"${WD}/xman_dos2unix.sh" * || true
	echo
	
	## Check whether python2 exists, otherwise create /usr/bin/python2 symlink to python executable 
	# [ "$(which python2)" ] || sudo ln -s "$(which python)" "/usr/bin/python2"
	
	## Archlinux changed default /usr/bin/python to python3, need to use /usr/bin/python2 instead
	if [ "$(which python2)" ]
	then
		install -D -m755 "${WD}/autogen.sh" "${WD}/autogen_unmodified.sh"
		sed 's|python |python2 |g' -i "${WD}/autogen.sh" || true
	fi
	
	chmod +x "${WD}/autogen.sh" || true
	
	if [ ! -e "${WD}/po/LINGUAS" ]
	then
		cd "${WD}/"
		rsync -Lrtvz translationproject.org::tp/latest/grub/ "${WD}/po" || true
		(cd "${WD}/po" && ls *.po | cut -d. -f1 | xargs) > "${WD}/po/LINGUAS" || true
	fi
	
	"${WD}/autogen.sh"
	echo
	
	## GRUB2 BIOS Build Directory
	install -d "${PWD}/GRUB2_BIOS_BUILD_DIR"
	cp --verbose "${WD}/grub.default" "${WD}/GRUB2_BIOS_BUILD_DIR/" || true
	cp --verbose "${WD}/grub.cfg" "${WD}/GRUB2_BIOS_BUILD_DIR/" || true
	
}

_GRUB2_BIOS_COMPILE_STEPS() {
	
	## Uncomment below to use ${GRUB2_BIOS_MENU_CONFIG}.cfg as the menu config file instead of grub.cfg
	sed "s|grub.cfg|${GRUB2_BIOS_MENU_CONFIG}.cfg|g" -i "${WD}/grub-core/normal/main.c" || true
	
	cd GRUB2_BIOS_BUILD_DIR
	echo
	
	## fix unifont.bdf location
	sed "s|/usr/share/fonts/unifont|${GRUB2_UNIFONT_PATH}|g" -i "${WD}/configure"
	
	"${WD}/configure" ${GRUB2_BIOS_Configure_Flags} ${GRUB2_Other_BIOS_Configure_Flags} ${GRUB2_BIOS_Configure_PATHS_1} ${GRUB2_BIOS_Configure_PATHS_2}
	echo
	
	make
	echo
	
	sed "s|${GRUB2_BIOS_MENU_CONFIG}.cfg|grub.cfg|g" -i "${WD}/grub-core/normal/main.c" || true
	
}

_GRUB2_BIOS_POSTCOMPILE_SETUP_PREFIX_DIR() {
	
	if [ \
		"${GRUB2_BIOS_PREFIX_DIR}" != '/' -o \
		"${GRUB2_BIOS_PREFIX_DIR}" != '/usr' -o \
		"${GRUB2_BIOS_PREFIX_DIR}" != '/usr/local' -o \
		"${GRUB2_BIOS_PREFIX_DIR}" != '/media' -o \
		"${GRUB2_BIOS_PREFIX_DIR}" != '/mnt' -o \
		"${GRUB2_BIOS_PREFIX_DIR}" != '/home' -o \
		"${GRUB2_BIOS_PREFIX_DIR}" != '/lib' -o \
		"${GRUB2_BIOS_PREFIX_DIR}" != '/lib64' -o \
		"${GRUB2_BIOS_PREFIX_DIR}" != '/lib32' -o \
		"${GRUB2_BIOS_PREFIX_DIR}" != '/tmp' -o \
		"${GRUB2_BIOS_PREFIX_DIR}" != '/var' -o \
		"${GRUB2_BIOS_PREFIX_DIR}" != '/run' -o \
		"${GRUB2_BIOS_PREFIX_DIR}" != '/etc' -o \
		"${GRUB2_BIOS_PREFIX_DIR}" != '/opt' \
		]
	then
		sudo cp -r --verbose "${GRUB2_BIOS_PREFIX_DIR}" "${GRUB2_BIOS_TOOLS_Backup}" || true
		echo
		sudo rm -rf --verbose "${GRUB2_BIOS_PREFIX_DIR}" || true
		echo
	fi
	
	sudo make install
	echo
	
	cd "${WD}/GRUB2_BIOS_BUILD_DIR/grub-core/"
	# sudo cp --verbose ${GRUB2_EXTRAS_MODULES} "${GRUB2_BIOS_LIB_DIR}/${GRUB2_BIOS_NAME}/i386-pc/" || true
	echo
	
	sudo install -d "${GRUB2_BIOS_SYSCONF_DIR}/default"
	[ -e "${WD}/grub.default" ] && sudo cp --verbose "${WD}/grub.default" "${GRUB2_BIOS_SYSCONF_DIR}/default/grub" || true
	sudo chmod --verbose -x "${GRUB2_BIOS_SYSCONF_DIR}/default/grub" || true
	echo
	
	sudo cp --verbose "$(which gettext.sh)" "${GRUB2_BIOS_BIN_DIR}/" || true
	sudo chmod --verbose -x "${GRUB2_BIOS_SYSCONF_DIR}/grub.d/README" || true
	echo
	
	# sudo "${GRUB2_BIOS_BIN_DIR}/${GRUB2_BIOS_NAME}-mkfont" --verbose --output="${GRUB2_BIOS_DATAROOT_DIR}/${GRUB2_BIOS_NAME}/unicode.pf2" "${GRUB2_UNIFONT_PATH}/unifont.bdf" || true
	echo
	# sudo "${GRUB2_BIOS_BIN_DIR}/${GRUB2_BIOS_NAME}-mkfont" --verbose --ascii-bitmaps --output=""${GRUB2_BIOS_DATAROOT_DIR}/${GRUB2_BIOS_NAME}/ascii.pf2" "${GRUB2_UNIFONT_PATH}/unifont.bdf" || true
	echo
	
}


_GRUB2_BIOS_BACKUP_OLD_DIR() {
	
	## Backup the old GRUB2 folder in the /boot folder.
	sudo cp -r --verbose "${GRUB2_BOOT_PART_DIR}" "${GRUB2_BIOS_Backup}" || true
	echo
	
	## Delete the old GRUB2 folder in the /boot folder.
	sudo rm -rf --verbose "${GRUB2_BOOT_PART_DIR}" || true
	echo
	
}

_GRUB2_BIOS_SETUP_BOOT_PART_DIR() {
	
	sudo "${GRUB2_BIOS_SBIN_DIR}/${GRUB2_BIOS_NAME}-install" --modules="${GRUB2_BIOS_CORE_IMG_MODULES}" --boot-directory="${GRUB2_Boot_Part_MP}" --no-floppy --recheck --debug "${GRUB2_Install_Device}" # Setup the GRUB2 folder in the /boot directory, create the core.img image and embed the image in the disk.
	echo
	
	sudo cp "${GRUB2_BIOS_DATAROOT_DIR}/${GRUB2_BIOS_NAME}"/*.pf2 "${GRUB2_BOOT_PART_DIR}/" || true
	echo
	
	sudo cp --verbose "${GRUB2_BIOS_Backup}/${GRUB2_BIOS_MENU_CONFIG}.cfg" "${GRUB2_BOOT_PART_DIR}/${GRUB2_BIOS_MENU_CONFIG}_backup.cfg" || true
	# sudo cp --verbose "${GRUB2_BIOS_Backup}/${GRUB2_BIOS_MENU_CONFIG}.cfg" "${GRUB2_BOOT_PART_DIR}/${GRUB2_BIOS_MENU_CONFIG}.cfg" || true
	
	[ -e "${WD}/grub.cfg" ] && sudo cp --verbose "${WD}/grub.cfg" "${GRUB2_BOOT_PART_DIR}/${GRUB2_BIOS_MENU_CONFIG}.cfg" || true
	
	# sudo ${GRUB2_BIOS_SBIN_DIR}/${GRUB2_BIOS_NAME}-mkconfig --output=${GRUB2_BOOT_PART_DIR}/${GRUB2_BIOS_MENU_CONFIG}.cfg || true
	echo
	
	sudo chmod --verbose -x "${GRUB2_BOOT_PART_DIR}/${GRUB2_BIOS_MENU_CONFIG}.cfg" || true
	echo
	
	sudo cp --verbose "${GRUB2_BIOS_Backup}"/*.{png,jpg,tga} "${GRUB2_BOOT_PART_DIR}/" || true
	echo
	
}

if [ "${PROCESS_CONTINUE}" == "TRUE" ]
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
	
	echo "GRUB2 BIOS setup in ${GRUB2_BOOT_PART_DIR} successfully."
	
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
	
	unset WD
	unset GRUB_CONTRIB
	unset PROCESS_CONTINUE
	unset GRUB2_Install_Device
	unset GRUB2_Boot_Part_MP
	unset GRUB2_BIOS_NAME
	unset GRUB2_BIOS_Backup
	unset GRUB2_BIOS_TOOLS_Backup
	unset GRUB2_BIOS_PREFIX_DIR
	unset GRUB2_BIOS_BIN_DIR
	unset GRUB2_BIOS_SBIN_DIR
	unset GRUB2_BIOS_SYSCONF_DIR
	unset GRUB2_BIOS_LIB_DIR
	unset GRUB2_BIOS_DATAROOT_DIR
	unset GRUB2_BIOS_INFO_DIR
	unset GRUB2_BIOS_LOCALE_DIR
	unset GRUB2_BIOS_MAN_DIR
	unset GRUB2_BIOS_MENU_CONFIG
	unset GRUB2_BOOT_PART_DIR
	unset GRUB2_BIOS_Configure_Flags
	unset GRUB2_Other_BIOS_Configure_Flags
	unset GRUB2_BIOS_Configure_PATHS_1
	unset GRUB2_BIOS_Configure_PATHS_2
	unset GRUB2_BIOS_CORE_IMG_MODULES
	unset GRUB2_EXTRAS_MODULES
	unset GRUB2_UNIFONT_PATH
	
# }

# _GRUB2_BIOS_UNSET_ENV_VARS
