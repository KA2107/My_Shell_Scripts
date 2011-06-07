@rem set EDK2_DIR=%CD%\Firmware\UEFI\TianoCore_Sourceforge\edk2_GIT
@set EDK2_DIR=%CD%\edk2_GIT
@set BIN_DIR="C:\Program Files (x86)\Git\bin\"

C:
cd C:\Program Files (x86)\Microsoft Visual Studio 9.0\Common7\Tools\
call vsvars32.bat

E:
cd %EDK2_DIR%

cmd /c rmdir /S /Q %EDK2_DIR%\Build\OvmfPkgX64
cmd /c rmdir /S /Q %EDK2_DIR%\Conf

@rem cmd /c "%BIN_DIR%"\git.exe reset --hard

cmd /c "%BIN_DIR%"\git.exe checkout keshav_pr

cmd /c "%BIN_DIR%"\git.exe reset --hard

cmd /c "%BIN_DIR%"\patch.exe -Np1 -i %EDK2_DIR%\..\EDK2_DuetPkg_Use_VS2008x86_Toolchain.patch
@rem cmd /c "%BIN_DIR%"\patch.exe -Np1 -i %EDK2_DIR%\..\EDK2_DuetPkg_Efivars_Use_MdeModulePkg_Universal_Variable_EmuRuntimeDxe.patch
@rem cmd /c patch -Np1 -i %EDK2_DIR%\..\EDK2_DuetPkg_Use_MdeModulePkg_Bus_ATA.patch

call edksetup.bat 
call edksetup.bat reconfig

@rem set WORKSPACE=%EDK2_DIR%

@rem Include/Enable appropriate modules in DuetPkgX64.dsc and DuetPkg.fdf

build -p OvmfPkg/OvmfPkgX64.dsc -a X64 -t VS2008x86

@rem edit PostBuild.bat to make BUILD_DIR point to DEBUG_VS2008x86

cd %EDK2_DIR%
cmd /c rmdir /S /Q %EDK2_DIR%\Conf
cmd /c "%BIN_DIR%"\git.exe reset --hard
