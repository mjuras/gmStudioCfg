@echo off
:: SetEnv.cmd: Script for setting .NET environment when shelling VS and running MSBuild

echo Requested Visual Studio Version: %1

:: default to VS2010 if not specified.
set vssetup=
if [%1]==[] set vssetup="%VS100COMNTOOLS%vsvars32.bat"

if [%1]==[VS2003] set vssetup="%VS71COMNTOOLS%vsvars32.bat"
if [%1]==[VS2005] set vssetup="%VS80COMNTOOLS%vsvars32.bat"
if [%1]==[VS2008] set vssetup="%VS90COMNTOOLS%vsvars32.bat"
if [%1]==[VS2010] set vssetup="%VS100COMNTOOLS%vsvars32.bat"
if [%1]==[VS2012] set vssetup="%VS110COMNTOOLS%vsvars32.bat"
if [%1]==[VS2013] set vssetup="%VS120COMNTOOLS%vsvars32.bat"
if [%1]==[VS2015] set vssetup="%VS140COMNTOOLS%vsvars32.bat"

:: Starting with VS2017 the rules changed, so look for different editions:
set vsv=
if [%1]==[VS2017] set vsv=2017
if [%1]==[VS2019] set vsv=2019
if [%1]==[VS2022] set vsv=2022
set Programs=
if [%1]==[VS2017] set Programs=%ProgramFiles(x86)%
if [%1]==[VS2019] set Programs=%ProgramFiles(x86)%
if [%1]==[VS2022] set Programs=C:\Program Files

:: If you do not have VisualStudio installed, and only the SDK, you will need something 
:: like the following command depending on the target framework SDK installation.
:: if [%1]==[VS2008] set vssetup="C:\Program Files\Microsoft.NET\SDK\v2.0\Bin\sdkvars.bat"

if exist %vssetup% goto callvs

:FindVSNew
set vssetup="%Programs%\Microsoft Visual Studio\%vsv%\Enterprise\Common7\Tools\VsDevCmd.bat"
set foundVS=VS%vsv% Enterprise
if exist %vssetup% goto callOtherVS

set vssetup="%Programs%\Microsoft Visual Studio\%vsv%\Professional\Common7\Tools\VsDevCmd.bat"
set foundVS=VS%vsv% Professional
if exist %vssetup% goto callOtherVS

set vssetup="%Programs%\Microsoft Visual Studio\%vsv%\Community\Common7\Tools\VsDevCmd.bat"
set foundVS=VS%vsv% Community
if exist %vssetup% goto callOtherVS

:: If Visual Studio was not detected we scan for one
echo WARNING: Selected Visual Studio Not Found, scanning for most recent installed

set vssetup="%VS140COMNTOOLS%vsvars32.bat"
set foundVS=VS2015
if exist %vssetup% goto callOtherVS

set vssetup="%VS120COMNTOOLS%vsvars32.bat"
set foundVS=VS2013
if exist %vssetup% goto callOtherVS

set vssetup="%VS110COMNTOOLS%vsvars32.bat"
set foundVS=VS2012
if exist %vssetup% goto callOtherVS

set vssetup="%VS100COMNTOOLS%vsvars32.bat"
set foundVS=VS2010
if exist %vssetup% goto callOtherVS

set vssetup="%VS90COMNTOOLS%vsvars32.bat"
set foundVS=VS2008
if exist %vssetup% goto callOtherVS

set vssetup="%VS80COMNTOOLS%vsvars32.bat"
set foundVS=VS2005
if exist %vssetup% goto callOtherVS

set vssetup="%VS71COMNTOOLS%vsvars32.bat"
set foundVS=VS2003

if not exist %vssetup% goto err

:callOtherVS

echo Found Version %foundVS%

:callvs
echo ------------------------------------------------------------------

:: For VS2017+, calling vssetup changes the working folder to VSCMD_START_DIR.
set VSCMD_START_DIR=%CD%
CALL %vssetup%
goto end

:err
echo %vssetup% NOT FOUND
echo Unable to setup .NET Framework SDK command line tools.
echo See %0.
exit /b 1

:end
