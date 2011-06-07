@rem set EDK2_DIR=%CD%\Firmware\UEFI\TianoCore_Sourceforge\edk2_GIT
@set EDK2_DIR=%CD%\edk2_GIT

C:
cd C:\Program Files (x86)\Microsoft Visual Studio 9.0\Common7\Tools\
call vsvars32.bat

E:
cd %EDK2_DIR%
call edksetup.bat --nt32
call edksetup.bat --nt32 reconfig

@rem set WORKSPACE=%EDK2_DIR%

build -p Nt32Pkg\Nt32Pkg.dsc -a IA32 -t VS2008x86

@rem edit this bat file to point to DEBUG_VS2008x86