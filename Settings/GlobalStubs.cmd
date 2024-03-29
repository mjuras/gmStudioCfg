::----------------------------------------------------------------
:: Description: Stub Framework Batch Build
::
:: This command script is used to rebuild the COM Stub Framework projects 
:: generated by a GlobalStubs script.  
::
:: The following gmStudio variables are available to use in the script
::
:: JobId             = %JobId%
:: JobName           = %JobName%
:: SrcName           = %SrcName%
:: ShellToolExe      = %ShellToolExe%
:: NetProjFolder     = %NetProjFolder%
:: ProjFolder        = %ProjFolder%
:: UserFolder        = %UserFolder%
:: VirtualRoot       = %VirtualRoot%
:: RuntimeFolder     = %RuntimeFolder%
:: SrcPath           = %SrcPath%
:: DeployFolder      = %DeployFolder%
:: SrcFolder         = %SrcFolder%
:: Dialect           = %Dialect%
:: MigName           = %MigName%
:: IdfFromIdlFolder  = %IdfFromIdlFolder%
:: IdfFromCodeFolder = %IdfFromCodeFolder%
:: GenExternFolder   = %GenExternFolder%
:: DevEnv            = %DevEnv%
:: BndPath           = %BndPath%
:: ResxFolder        = %ResxFolder%
:: TaskTag           = %TaskTag%
:: SrcOrdr           = %SrcOrdr%
:: NetLang           = %NetLang%
:: NetExtn           = %NetExtn%
:: SettingsFolder    = %SettingsFolder%
:: UserDesc          = %UserDesc%
:: UserCmnt          = %UserCmnt%
::----------------------------------------------------------------

@ECHO OFF

IF .%1==.PRE-TRAN goto PRE-TRAN
IF .%1==.POST-TRAN goto POST-TRAN
IF .%1==.PRE-DEPLOY goto PRE-DEPLOY
IF .%1==.POST-DEPLOY goto POST-DEPLOY
IF .%1==.PRE-MAKE goto PRE-MAKE
IF .%1==.POST-MAKE goto POST-MAKE
IF .%1==.TEST goto TEST

echo UNKNOWN USER COMMAND: %1%
goto END

::----------------------------------------------------------------
:PRE-TRAN
::----------------------------------------------------------------

echo USER COMMAND: %1 [%JobId%]
:: Enter pre-translation processing here
goto END

::----------------------------------------------------------------
:POST-TRAN
::----------------------------------------------------------------

echo USER COMMAND: %1 [%JobId%]
goto END

::----------------------------------------------------------------
:PRE-DEPLOY
::----------------------------------------------------------------

echo USER COMMAND: %1 [%JobId%]
goto END

::----------------------------------------------------------------
:POST-DEPLOY
::----------------------------------------------------------------
echo USER COMMAND: %1 [%JobId%]
goto END

::----------------------------------------------------------------
:PRE-MAKE
::----------------------------------------------------------------

echo USER COMMAND: %1 [%JobId%]

set opts=/verbosity:normal /t:rebuild /p:Configuration=Debug /p:Platform=AnyCPU

msbuild "%DeployFolder%\gmRTL.Core\gmRTL.Core.csproj" %opts%
msbuild "%DeployFolder%\gmRTL.GUI\gmRTL.GUI.csproj" %opts%

%BuildList%

goto END

::----------------------------------------------------------------
:POST-MAKE
::----------------------------------------------------------------

echo USER COMMAND: %1 [%JobId%]
goto END

::----------------------------------------------------------------
:TEST
::----------------------------------------------------------------

echo USER COMMAND: %1 [%JobId%]
:: Enter functional testing script here
::pushd "%NetProjFolder%\bin"
::"%SrcName%.exe"
::popd
::set ERRORLEVEL=
::fc "%SrcFolder%\%SrcName%.log" "%NetProjFolder%\bin\%SrcName%.log"
::goto Result%ErrorLevel%
:::Result-1
:::Result2
::echo ERROR
::exit 2
:::Result1
::echo FAIL
::exit 1
:::Result0 
::echo PASS
::exit 0



goto END

:END