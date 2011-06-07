@rem set EDK_SOURCE=%CD%\Firmware\UEFI\TianoCore_Sourceforge\efidevkit__GIT_SVN\Edk
@set EDK_SOURCE=%CD%\efidevkit__GIT_SVN\Edk

@rem Change %EDK_SOURCE%\Edk\Sample\LocalTools.env -> VC8_X64_PATH = c:\Program Files (x86)\Microsoft Visual Studio 9.0\VC\bin\x86_amd64
@rem Change %EDK_SOURCE%\Edk\Sample\Platform\DUET\Build\Config.env -> USE_VC8 = YES && USE_VC8_X64 = YES

C:
cd C:\Program Files (x86)\Microsoft Visual Studio 9.0\Common7\Tools\
call vsvars32.bat

@set VS_PATH=C:\Program Files (x86)\Microsoft Visual Studio 9.0\

E:
cd %EDK_SOURCE%\Sample\Platform\DUET
call nmake uefi64