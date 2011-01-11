#! /bin/sh

## This is a script to compile and install GRUB2 for UEFI systems. Just copy this script to the GRUB2 Source Root dir and run this script by passing the correct parameters. This script will be updated as and when the commands change in GRUB2 bzr repo and not just stick to any release version.

## The "GRUB2_EFI_NAME" parameter refers to the GRUB2 folder name in the EFI System Partition. The final GRUB2 UEFI files will be installed in <EFI SYSTEM PARTITION>/efi/<GRUB2_EFI_NAME>/ folder. The final GRUB2 EFI Application will be <EFI SYSTEM PARTITION>/efi/<GRUB2_EFI_NAME>/<GRUB2_EFI_NAME>.efi where <GRUB2_EFI_NAME> refers to the "GRUB2_EFI_NAME" parameter you passed to this script.

## The "GRUB2_EFI_PREFIX" parameter is not compulsory.

export WD=${PWD}/

## The location of grub-extras source folder if you have.
export GRUB_CONTRIB=${WD}/grub2_extras_BZR/

export PROCESS_CONTINUE=TRUE

export TARGET_EFI_ARCH=$1
export EFI_SYSTEM_PART_MP=$2
export GRUB2_EFI_NAME=$3
export GRUB2_UEFI_Backup=$4
export GRUB2_UEFI_TOOLS_Backup=$5
export GRUB2_EFI_PREFIX=$6
## If not mentioned, GRUB2_EFI_PREFIX env variable will be set to /grub2/grub2_efi_${TARGET_EFI_ARCH} dir

export GRUB2_EFI_APP_PREFIX=efi/${GRUB2_EFI_NAME}
export GRUB2_EFISYS_PART_DIR=${EFI_SYSTEM_PART_MP}/${GRUB2_EFI_APP_PREFIX}
export GRUB2_EFI_MENU_CONFIG="${GRUB2_EFI_NAME}"
export GRUB2_UNIFONT_PATH="/usr/share/fonts/misc/unifont.bdf"

export GRUB2_EFI_Configure_Flags="--with-platform=efi --target=${TARGET_EFI_ARCH} --program-transform-name=s,grub,${GRUB2_EFI_NAME},"
export GRUB2_Other_Configure_Flags="--enable-mm-debug --enable-grub-mkfont --disable-nls"

export GRUB2_EFI_LST_files="command.lst crypto.lst fs.lst handler.lst moddep.lst partmap.lst parttool.lst terminal.lst video.lst"

export GRUB2_PARTMAP_FS_MODULES="ata part_gpt part_msdos fat ntfs ntfscomp ext2 iso9660 udf hfsplus"
export GRUB2_COMMON_IMP_MODULES="fshelp normal chain linux ls memdisk tar search search_fs_file search_fs_uuid search_label help loopback boot configfile echo png jpeg tga"
export GRUB2_EFI_APP_MODULES="efi_gop"
export GRUB2_EXTRAS_MODULES="lua.mod zfs.mod zfsinfo.mod"
# export GRUB2_EFI_FINAL_MODULES="${GRUB2_PARTMAP_FS_MODULES} ${GRUB2_COMMON_IMP_MODULES} ${GRUB2_EFI_APP_MODULES} ${GRUB2_EXTRAS_MODULES}"
export GRUB2_EFI_FINAL_MODULES="${GRUB2_PARTMAP_FS_MODULES} ${GRUB2_COMMON_IMP_MODULES} ${GRUB2_EFI_APP_MODULES}"

## GRUB2_EFI_FINAL_MODULES - Those modules that will be in the final <GRUB2_EFI_NAME>.efi application.

if [ \
     "$1" == "" -o \
     "$1" == "-h" -o \
     "$1" == "-u" -o \
     "$1" == "--help" -o \
     "$1" == "--usage" \
   ]
then
    echo
    echo Usage : $0 [TARGET_EFI_ARCH] [EFI_SYS_PART_MOUNTPOINT] [GRUB2_EFI_Install_Dir_Name] [GRUB2_UEFI_Backup_Path] [GRUB2_UEFI_Tools_Backup_Path] [GRUB2_EFI_PREFIX_FOLDER]
    echo
    echo Example : $0 x86_64 /boot/efi grub2 /media/Data_3/grub2_UEFI_Backup /media/Data_3/grub2_UEFI_Tools_Backup /grub2/grub2_efi_x86_64
    echo
    export PROCESS_CONTINUE=FALSE
fi

if [ "${GRUB2_EFI_PREFIX}" == "" ]
then
    export ${GRUB2_EFI_PREFIX}="/grub2/grub2_efi_${TARGET_EFI_ARCH}"
fi

if [ "${PROCESS_CONTINUE}" == TRUE ]
then
   echo
   echo TARGET_EFI_ARCH=${TARGET_EFI_ARCH}
   echo
   echo EFI_SYS_PART_MOUNTPOINT=${EFI_SYSTEM_PART_MP}
   echo
   echo GRUB2_EFI_Final_Installation_Directory=${GRUB2_EFISYS_PART_DIR}
   echo
   echo GRUB2_UEFI_Backup_Path=${GRUB2_UEFI_Backup}
   echo
   echo GRUB2_UEFI_Tools_Backup_Path=${GRUB2_UEFI_TOOLS_Backup}
   echo
   echo GRUB2_EFI_PREFIX_FOLDER=${GRUB2_EFI_PREFIX} ## Not compulsory
   echo

   read -p "Do you wish to proceed? (y/n): " ans ## Copied from http://www.linuxjournal.com/content/asking-yesno-question-bash-script

   case ${ans} in
   y | Y | yes | YES | Yes)
   echo "Ok. Proceeding with compile and installation of GRUB2 UEFI ${TARGET_EFI_ARCH}."
   echo

   ## Load device-mapper kernel module - needed by grub-probe
   sudo modprobe dm-mod || true

   set -x -e

   cd ${WD}

   ## Convert the line endings of all the source files from DOS to UNIX mode
   ${WD}/xman_dos2unix.sh * || true
   echo

   ## Uncomment below to use ${GRUB2_EFI_MENU_CONFIG}.cfg as the menu config file instead of grub.cfg
   sed -i "s|grub.cfg|${GRUB2_EFI_MENU_CONFIG}.cfg|" ${WD}/grub-core/normal/main.c || true

   ## Archlinux changed default /usr/bin/python to 3.1.2, need to use /usr/bin/python2 instead
   cp ${WD}/autogen.sh ${WD}/autogen_unmodified.sh
   sed -i 's|python |python2 |' ${WD}/autogen.sh || true
   
   ${WD}/autogen.sh
   echo

   ## GRUB2 UEFI Build Directory
   mkdir GRUB2_EFI_BUILD_DIR_${TARGET_EFI_ARCH}
   cp --verbose ${WD}/grub.default ${WD}/GRUB2_EFI_BUILD_DIR_${TARGET_EFI_ARCH}/ || true
   cp --verbose ${WD}/grub.cfg ${WD}/GRUB2_EFI_BUILD_DIR_${TARGET_EFI_ARCH}/ || true

   cd GRUB2_EFI_BUILD_DIR_${TARGET_EFI_ARCH}
   echo

   ../configure ${GRUB2_EFI_Configure_Flags} ${GRUB2_Other_Configure_Flags} --prefix=${GRUB2_EFI_PREFIX}
   echo

   make
   echo

   sudo cp --verbose -r ${GRUB2_EFI_PREFIX} ${GRUB2_UEFI_TOOLS_Backup} || true
   echo
   sudo rm --verbose -rf ${GRUB2_EFI_PREFIX} || true
   echo

   sudo make install
   echo

   cd ${WD}/GRUB2_EFI_BUILD_DIR_${TARGET_EFI_ARCH}/grub-core/
   # sudo cp --verbose ${GRUB2_EXTRAS_MODULES} ${GRUB2_EFI_PREFIX}/lib/${GRUB2_EFI_NAME}/${TARGET_EFI_ARCH}-efi/ || true
   echo

   ## Backup the old GRUB2 folder in the EFI System Partition
   sudo cp --verbose -r ${GRUB2_EFISYS_PART_DIR} ${GRUB2_UEFI_Backup} || true
   echo
   ## Delete the old GRUB2 folder in the EFI System Partition
   sudo rm --verbose -rf ${GRUB2_EFISYS_PART_DIR} || true
   echo

   sudo sed -i 's|--bootloader_id=|--bootloader-id=|' ${GRUB2_EFI_PREFIX}/sbin/${GRUB2_EFI_NAME}-install || true

   ## Setup the GRUB2 folder in the EFI System Partition and create the grub.efi application
   sudo ${GRUB2_EFI_PREFIX}/sbin/${GRUB2_EFI_NAME}-install --boot-directory=${EFI_SYSTEM_PART_MP}/efi --bootloader-id=${GRUB2_EFI_NAME} --no-floppy --recheck --debug
   echo

   sudo rm ${GRUB2_EFISYS_PART_DIR}/core.efi || true
   echo

   ## Create the grub2 efi application
   sudo ${GRUB2_EFI_PREFIX}/bin/${GRUB2_EFI_NAME}-mkimage --verbose --directory=${GRUB2_EFI_PREFIX}/lib/${GRUB2_EFI_NAME}/${TARGET_EFI_ARCH}-efi --prefix="" --output=${GRUB2_EFISYS_PART_DIR}/${GRUB2_EFI_NAME}.efi --format=${TARGET_EFI_ARCH}-efi ${GRUB2_EFI_FINAL_MODULES}
   echo

   cd ${WD}/GRUB2_EFI_BUILD_DIR_${TARGET_EFI_ARCH}/grub-core/
   # sudo cp --verbose ${GRUB2_EXTRAS_MODULES} ${GRUB2_EFISYS_PART_DIR}/ || true
   sudo cp --verbose ${GRUB2_EFI_PREFIX}/lib/${GRUB2_EFI_NAME}/${TARGET_EFI_ARCH}-efi/*.img ${GRUB2_EFISYS_PART_DIR}/ || true
   echo

   sudo mkdir ${GRUB2_EFI_PREFIX}/etc/default
   sudo cp ${WD}/grub.default ${GRUB2_EFI_PREFIX}/etc/default/grub || true
   sudo chmod --verbose -x ${GRUB2_EFI_PREFIX}/etc/default/grub || true
   echo

   sudo cp --verbose /usr/bin/gettext.sh ${GRUB2_EFI_PREFIX}/bin/ || true
   sudo chmod --verbose -x ${GRUB2_EFI_PREFIX}/etc/grub.d/README || true
   echo
   # sudo ${GRUB2_EFI_PREFIX}/sbin/${GRUB2_EFI_NAME}-mkconfig --output=${GRUB2_EFISYS_PART_DIR}/${GRUB2_EFI_MENU_CONFIG}.cfg || true
   echo

   sudo ${GRUB2_EFI_PREFIX}/bin/${GRUB2_EFI_NAME}-mkfont --verbose --output=${GRUB2_EFISYS_PART_DIR}/unifont.pf2 ${GRUB2_UNIFONT_PATH} || true
   echo
   sudo ${GRUB2_EFI_PREFIX}/bin/${GRUB2_EFI_NAME}-mkfont --verbose --ascii-bitmaps --output=${GRUB2_EFISYS_PART_DIR}/ascii.pf2 ${GRUB2_UNIFONT_PATH} || true
   echo

   cd ..
   sed -i "s|${GRUB2_EFI_MENU_CONFIG}.cfg|grub.cfg|" ${WD}/grub-core/normal/main.c || true

   ## Copy the old config file as ${GRUB2_EFI_MENU_CONFIG}_backup.cfg
   sudo cp --verbose ${GRUB2_UEFI_Backup}/${GRUB2_EFI_MENU_CONFIG}.cfg ${GRUB2_EFISYS_PART_DIR}/${GRUB2_EFI_MENU_CONFIG}_backup.cfg || true
   # sudo cp --verbose ${GRUB2_UEFI_Backup}/${GRUB2_EFI_MENU_CONFIG}.cfg ${GRUB2_EFISYS_PART_DIR}/${GRUB2_EFI_MENU_CONFIG}.cfg || true
   sudo cp --verbose ${WD}/grub.cfg ${GRUB2_EFISYS_PART_DIR}/${GRUB2_EFI_MENU_CONFIG}.cfg || true
   sudo cp --verbose ${GRUB2_UEFI_Backup}/*.jpg ${GRUB2_UEFI_Backup}/*.png ${GRUB2_UEFI_Backup}/*.tga ${GRUB2_EFISYS_PART_DIR}/ || true
   echo

   sudo chmod --verbose -x ${GRUB2_EFISYS_PART_DIR}/${GRUB2_EFI_MENU_CONFIG}.cfg || true
   echo

   echo "GRUB 2 UEFI ${TARGET_EFI_ARCH} Setup in ${GRUB2_EFISYS_PART_DIR} successfully."
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
unset TARGET_EFI_ARCH
unset EFI_SYSTEM_PART_MP
unset GRUB2_EFI_NAME
unset GRUB2_UEFI_Backup
unset GRUB2_UEFI_TOOLS_Backup
unset GRUB2_EFI_PREFIX
unset GRUB2_EFI_APP_PREFIX
unset GRUB2_EFISYS_PART_DIR
unset GRUB2_EFI_MENU_CONFIG
unset GRUB2_EFI_Configure_Flags
unset GRUB2_Other_Configure_Flags
unset GRUB2_EFI_LST_files
unset GRUB2_PARTMAP_FS_MODULES
unset GRUB2_COMMON_IMP_MODULES
unset GRUB2_EFI_APP_MODULES
unset GRUB2_EXTRAS_MODULES
unset GRUB2_EFI_FINAL_MODULES
unset GRUB2_UNIFONT_PATH
