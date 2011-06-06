#! /bin/sh

## This is a script to compile and install GRUB2 for BIOS systems. Just copy this script to the GRUB2 Source Root dir and run this script by passing the correct parameters. This script will be updated as and when the commands change in GRUB2 bzr repo and not just stick to any release version.

## For MBR partitioned disks, make sure the 63-sector gap exists after the 1st 512-byte MBR region. For GPT partitioned disks, create a "BIOS Boot Partition" of about 1 MB size before running this script.

## The "GRUB2_BIOS_NAME" parameter refers to the GRUB2 folder name in the your /boot Partition or /boot directory. The final GRUB2 BIOS files including core.img will be installed in /boot/<GRUB2_BIOS_NAME>/ folder, where <GRUB2_BIOS_NAME> refers to the "GRUB2_BIOS_NAME" parameter you passed to this script.

export WD="${PWD}/"

## The location of grub-extras source folder if you have.
export GRUB_CONTRIB="${WD}/grub2_extras_BZR/"

export PROCESS_CONTINUE="TRUE"

export GRUB2_Install_Device=${1}
export GRUB2_Root_Part_MP=${2}
export GRUB2_BIOS_NAME=${3}
export GRUB2_BIOS_Backup=${4}
export GRUB2_BIOS_TOOLS_Backup=${5}
export GRUB2_BIOS_PREFIX=${6}
## If not mentioned, GRUB2_BIOS_PREFIX env variable will be set to /grub2/grub2_BIOS dir

export GRUB2_BIOS_MENU_CONFIG="${GRUB2_BIOS_NAME}"
export GRUB2_UNIFONT_PATH="/usr/share/fonts/misc"

if [ "${GRUB2_BIOS_PREFIX}" == "" ]
then
	export GRUB2_BIOS_PREFIX="/grub2/grub2_bios"
fi

export GRUB2_BOOT_PART_DIR="${GRUB2_Root_Part_MP}/boot/${GRUB2_BIOS_NAME}"
export GRUB2_BIOS_Configure_Flags="--with-platform=pc --program-transform-name=s,grub,${GRUB2_BIOS_NAME},"
export GRUB2_Other_Configure_Flags="--enable-mm-debug --enable-grub-mkfont --disable-nls"

export GRUB2_BIOS_CORE_IMG_MODULES="part_gpt part_msdos fat ext2 ntfs ntfscomp"
export GRUB2_EXTRAS_MODULES="lua.mod 915resolution.mod"

## GRUB2_BIOS_CORE_IMG_MODULES - Those modules that will be included in the core.img image generated for your system. Note the maximum permitted size of core.img image is 32 KB.

if [ \
	"${1}" == "" -o \
	"${1}" == "-h" -o \
	"${1}" == "-u" -o \
	"${1}" == "--help" -o \
	"${1}" == "--usage" \
	]
then
	echo
	echo Usage : ${0} [GRUB2_Install_Device] [GRUB2_Root_Partition_MountPoint] [GRUB2_BIOS_Install_Dir_Name] [GRUB2_BIOS_Backup_Path] [GRUB2_BIOS_Tools_Backup_Path] [GRUB2_BIOS_PREFIX_FOLDER]
	echo
	echo Example : ${0} /dev/sda / grub2 /media/Data_3/grub2_BIOS_Backup /media/Data_3/grub2_BIOS_Tools_Backup /grub2/grub2_BIOS
	echo
	export PROCESS_CONTINUE=FALSE
fi

if [ "${PROCESS_CONTINUE}" == TRUE ]
then
	echo
	echo GRUB2_Install_Device="${GRUB2_Install_Device}"
	echo
	echo GRUB2_Root_Partition_MountPoint="${GRUB2_Root_Part_MP}"
	echo
	echo GRUB2_BIOS_Install_Dir_Name="${GRUB2_BOOT_PART_DIR}"
	echo
	echo GRUB2_BIOS_Backup_Path="${GRUB2_BIOS_Backup}"
	echo
	echo GRUB2_BIOS_Tools_Backup_Path="${GRUB2_BIOS_TOOLS_Backup}"
	echo
	echo GRUB2_BIOS_PREFIX_FOLDER="${GRUB2_BIOS_PREFIX}"
	echo
	
	read -p "Do you wish to proceed? (y/n): " ans # Copied from http://www.linuxjournal.com/content/asking-yesno-question-bash-script
	
	case "${ans}" in
	y | Y | yes | YES | Yes)
	echo "Ok. Proceeding with compile and installation of GRUB2 BIOS."
	echo
	
	## Load device-mapper kernel module - needed by grub-probe
	sudo modprobe dm-mod || true
	
	set -x -e
	
	cd "${WD}/"
	
	## Convert the line endings of all the source files from DOS to UNIX mode
	"${WD}/xman_dos2unix.sh" * || true
	echo
	
	## Uncomment below to use ${GRUB2_BIOS_MENU_CONFIG}.cfg as the menu config file instead of grub.cfg
	sed -i "s|grub.cfg|${GRUB2_BIOS_MENU_CONFIG}.cfg|" "${WD}/grub-core/normal/main.c" || true
	
	## Archlinux changed default /usr/bin/python to 3.1.2, need to use /usr/bin/python2 instead
	cp "${WD}/autogen.sh" "${WD}/autogen_unmodified.sh"
	sed -i 's|python |python2 |' "${WD}/autogen.sh" || true
	
	if [ ! -e "${WD}/po/LINGUAS" ]
	then
		cd "${WD}/"
		# rsync -Lrtvz translationproject.org::tp/latest/grub/ "${WD}/po" || true
		(cd "${WD}/po" && ls *.po | cut -d. -f1 | xargs) > "${WD}/po/LINGUAS" || true
	fi
	
	"${WD}/autogen.sh"
	echo
	
	## GRUB2 BIOS Build Directory
	mkdir -p GRUB2_BIOS_BUILD_DIR
	cp --verbose "${WD}/grub.default" "${WD}/GRUB2_BIOS_BUILD_DIR/" || true
	cp --verbose "${WD}/grub.cfg" "${WD}/GRUB2_BIOS_BUILD_DIR/" || true
	
	cd GRUB2_BIOS_BUILD_DIR
	echo
	
	## fix unifont.bdf location
	sed -i "s|/usr/share/fonts/unifont|${GRUB2_UNIFONT_PATH}|" "${WD}/configure"
	
	"${WD}/configure" ${GRUB2_BIOS_Configure_Flags} ${GRUB2_Other_Configure_Flags} --prefix="${GRUB2_BIOS_PREFIX}"
	echo
	
	make
	echo
	
	sudo cp --verbose -r "${GRUB2_BIOS_PREFIX}" "${GRUB2_BIOS_TOOLS_Backup}" || true
	echo
	sudo rm --verbose -r "${GRUB2_BIOS_PREFIX}" || true
	echo
	
	sudo make install
	echo
	
	cd "${WD}/GRUB2_BIOS_BUILD_DIR/grub-core/"
	# sudo cp --verbose ${GRUB2_EXTRAS_MODULES} "${GRUB2_BIOS_PREFIX}/lib/${GRUB2_BIOS_NAME}/i386-pc/" || true
	echo
	
	cd "${WD}/GRUB2_BIOS_BUILD_DIR/grub-core/"
	# sudo cp --verbose g2hdr.bin g2ldr.mbr grldr.img "${GRUB2_BIOS_PREFIX}/lib/${GRUB2_BIOS_NAME}/i386-pc/" || true
	# sudo cp --verbose grubinst "${GRUB2_BIOS_PREFIX}/bin/grubinst" || true
	echo
	
	sudo mkdir -p "${GRUB2_BIOS_PREFIX}/etc/default"
	sudo cp --verbose "${WD}/grub.default" "${GRUB2_BIOS_PREFIX}/etc/default/grub" || true
	sudo chmod --verbose -x "${GRUB2_BIOS_PREFIX}/etc/default/grub" || true
	echo
	
	sudo cp --verbose /usr/bin/gettext.sh "${GRUB2_BIOS_PREFIX}/bin/" || true
	sudo chmod --verbose -x "${GRUB2_BIOS_PREFIX}/etc/grub.d/README" || true
	echo
	
	## Backup the old GRUB2 folder in the /boot folder.
	sudo cp --verbose -r "${GRUB2_BOOT_PART_DIR}" "${GRUB2_BIOS_Backup}" || true
	echo
	## Delete the old GRUB2 folder in the /boot folder.
	sudo rm --verbose -r "${GRUB2_BOOT_PART_DIR}" || true
	echo
	
	sudo "${GRUB2_BIOS_PREFIX}/sbin/${GRUB2_BIOS_NAME}-install" --modules="${GRUB2_BIOS_CORE_IMG_MODULES}" --root-directory="${GRUB2_Root_Part_MP}" --no-floppy --recheck --debug "${GRUB2_Install_Device}" # Setup the GRUB2 folder in the /boot directory, create the core.img image and embed the image in the disk.
	echo
	
	# sudo ${GRUB2_BIOS_PREFIX}/sbin/${GRUB2_BIOS_NAME}-mkconfig --output=${GRUB2_BOOT_PART_DIR}/${GRUB2_BIOS_MENU_CONFIG}.cfg || true
	echo
	
	cd ..
	sed -i "s|${GRUB2_BIOS_MENU_CONFIG}.cfg|grub.cfg|" "${WD}/grub-core/normal/main.c" || true
	
	# sudo "${GRUB2_BIOS_PREFIX}/bin/${GRUB2_BIOS_NAME}-mkfont" --verbose --output="${GRUB2_BOOT_PART_DIR}/unicode.pf2" "${GRUB2_UNIFONT_PATH}/unifont.bdf" || true
	echo
	# sudo "${GRUB2_BIOS_PREFIX}/bin/${GRUB2_BIOS_NAME}-mkfont" --verbose --ascii-bitmaps --output="${GRUB2_BOOT_PART_DIR}/ascii.pf2" "${GRUB2_UNIFONT_PATH}/unifont.bdf" || true
	echo
	
	sudo cp "${GRUB2_BIOS_PREFIX}/share/${GRUB2_BIOS_NAME}"/*.pf2 "${GRUB2_BOOT_PART_DIR}/" || true
	echo
	
	sudo cp --verbose "${GRUB2_BIOS_Backup}/${GRUB2_BIOS_MENU_CONFIG}.cfg" "${GRUB2_BOOT_PART_DIR}/${GRUB2_BIOS_MENU_CONFIG}_backup.cfg" || true
	# sudo cp --verbose "${GRUB2_BIOS_Backup}/${GRUB2_BIOS_MENU_CONFIG}.cfg" "${GRUB2_BOOT_PART_DIR}/${GRUB2_BIOS_MENU_CONFIG}.cfg" || true
	sudo cp --verbose "${WD}/grub.cfg" "${GRUB2_BOOT_PART_DIR}/${GRUB2_BIOS_MENU_CONFIG}.cfg" || true
	sudo cp --verbose "${GRUB2_BIOS_Backup}"/*.jpg "${GRUB2_BIOS_Backup}"/*.png "${GRUB2_BIOS_Backup}"/*.tga "${GRUB2_BOOT_PART_DIR}/" || true
	echo
	
	sudo chmod --verbose -x "${GRUB2_BOOT_PART_DIR}/${GRUB2_BIOS_MENU_CONFIG}.cfg" || true
	echo
	
	echo "GRUB 2 BIOS setup in ${GRUB2_BOOT_PART_DIR} successfully."
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
unset GRUB2_Install_Device
unset GRUB2_Root_Part_MP
unset GRUB2_BIOS_NAME
unset GRUB2_BIOS_Backup
unset GRUB2_BIOS_TOOLS_Backup
unset GRUB2_BIOS_PREFIX
unset GRUB2_BIOS_MENU_CONFIG
unset GRUB2_BOOT_PART_DIR
unset GRUB2_BIOS_Configure_Flags
unset GRUB2_Other_Configure_Flags
unset GRUB2_BIOS_CORE_IMG_MODULES
unset GRUB2_EXTRAS_MODULES
unset GRUB2_UNIFONT_PATH
