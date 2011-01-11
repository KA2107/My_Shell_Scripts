#! /bin/sh

export PROCESS_CONTINUE=TRUE

export YUM_GRUB2_Compile_Requires="gcc-multilib make bison dos2unix binutils python autoconf automake autogen gettext gettext-devel freetype freetype-devel ncurses ncurses-static gcypt ncurses-devel glibc-static lzo-devel texinfo texinfo-devel flex"
export CLYDE_GRUB2_Compile_Requires="gcc-multilib lib32-gcc-libs binutils-multilib libtool-multilib lib32-glibc glibc make bison python autoconf automake autogen hd2u bdf-unifont gettext freetype2 ncurses texinfo flex help2man"

echo
echo The following packages are required to compile GRUB2
echo

if [ "$1" = "" ]
then
    export PROCESS_CONTINUE=FALSE

elif [ "$1" = "--yum-rpm" ]
then
    if [ "${PROCESS_CONTINUE}" = TRUE ]
    then
        set -x
        sudo yum install ${YUM_GRUB2_Compile_Requires}
        set +x
    fi
elif [ "$1" = "--apt-deb" ]
then
    if [ "${PROCESS_CONTINUE}" = TRUE ]
    then
        set -x
        sudo apt-get install ${GRUB2_Compile_Requires}
        set +x
    fi
elif [ "$1" = "--clyde" ]
then
    if [ "${PROCESS_CONTINUE}" = TRUE ]
    then
        set -x
        sudo pacman -Sy --needed clyde
        echo
        sudo clyde -Sy --needed ${CLYDE_GRUB2_Compile_Requires}
        echo
        set +x
    fi
fi

unset PROCESS_CONTINUE
unset YUM_GRUB2_Compile_Requires
unset CLYDE_GRUB2_Compile_Requires
