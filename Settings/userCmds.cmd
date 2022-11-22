::----------------------------------------------------------------
:: This command script is executed before and after major steps 
:: in processing each migration job.  You may insert your pre- 
:: or post processing steps as appropriate.
:: This sample includes steps for setting up a web site build.
::
:: The following gmStudio variables are available to use in the script
::
:: AppExeFolder      gmStudio Install Folder                      = %AppExeFolder%      
:: BldFileStem       Path of Source Build File without Extension  = %BldFileStem%       
:: BldPath           Path of Source Build File                    = %BldPath%           
:: BndPath           Path to generated code bundle file           = %BndPath%           
:: DeployFolder      Root folder for deploying .NET projects      = %DeployFolder%      
:: DevEnv            Visual Studio Version                        = %DevEnv%            
:: Dialect           Target .NET Language                         = %Dialect%           
:: GenExternFolder   Folder for generating interop files          = %GenExternFolder%   
:: IdfFromCodeFolder Folder for IDFs generated from code          = %IdfFromCodeFolder% 
:: IdfFromIdlFolder  Folder for IDFs generated from COM binaries  = %IdfFromIdlFolder%  
:: IntName           Internal Name of Upgrade Task                = %IntName%           
:: JobId             Full ID of Task                              = %JobId%             
:: MigName           Migration Project Name                       = %MigName%           
:: MigType           Migration Project Type                       = %MigType%           
:: NetExtn           Target .NET Language File Extension          = %NetExtn%           
:: NetLang           Target .NET Language                         = %NetLang%           
:: NetProjFolder     Folder for deploying this task .NET project  = %NetProjFolder%     
:: NetProjName       .NET project name without Extension          = %NetProjName%       
:: ProjFolder        Folder for project workspace                 = %ProjFolder%        
:: ResxFolder        Folder for generated RESX files              = %ResxFolder%        
:: RuntimeFolder     Folder for runtime support assemblies        = %RuntimeFolder%     
:: SetEnvCmdPath     Path to SetEnv.Cmd Script                    = %SetEnvCmdPath%     
:: SettingsFolder    Folder for default Settings files            = %SettingsFolder%    
:: ShellToolExe      Path to Deployment Tool                      = %ShellToolExe%      
:: SrcFileStem       Source File Name without Extension           = %SrcFileStem%       
:: SrcFolder         Folder for source code for this task         = %SrcFolder%         
:: SrcName           Short ID of upgrade Task                     = %SrcName%           
:: SrcOrdr           Source Order for this task                   = %SrcOrdr%           
:: SrcPath           Path to Source project/page                  = %SrcPath%           
:: TaskTag           Task Tag                                     = %TaskTag%           
:: UserFolder        Folder for project user files                = %UserFolder%        
:: UsrCmnt           Task Comment                                 = %UsrCmnt%           
:: UsrDesc           Task Description                             = %UsrDesc%           
:: VirtualRoot       Root folder for source code tree             = %VirtualRoot%       
:: WorkFolder        Working Folder                               = %WorkFolder%         
:----------------------------------------------------------------

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
:: Enter post-translation processing here
goto END

::----------------------------------------------------------------
:PRE-DEPLOY
::----------------------------------------------------------------

echo USER COMMAND: %1 [%JobId%]
:: Enter pre-deployment processing here (e.g. file replacement)

::echo setup directory folders for ASP.NET site
::robocopy "%VirtualRoot%" "%NetProjFolder%" * /s /xf * /e 
::del "%NetProjFolder%\*.as*" /s
::del "%NetProjFolder%\*.cs*" /s

goto END

::----------------------------------------------------------------
:POST-DEPLOY
::----------------------------------------------------------------

echo USER COMMAND: %1 [%JobId%]
:: Enter post-deployment processing here (e.g. file replacement)

::echo copy supporting files to %NetProjFolder%
::robocopy "%VirtualRoot%" "%NetProjFolder%" *.jpg *.gif *.png *.vbs *.js *.css *.xls *.txt /np /s /NJH

goto END

::----------------------------------------------------------------
:PRE-MAKE
::----------------------------------------------------------------

echo USER COMMAND: %1 [%JobId%]
:: Enter pre-build processing here
goto END

::----------------------------------------------------------------
:POST-MAKE
::----------------------------------------------------------------

echo USER COMMAND: %1 [%JobId%]
:: Enter post-build processing here
goto END

::----------------------------------------------------------------
:TEST
::----------------------------------------------------------------

echo USER COMMAND: %1 [%JobId%]

:: a simple comparison reporting changes from last saved translation
echo Comparing "sav\%JobID%.bnd" "%JobID%.bnd"
if not exist "sav\%JobID%.bnd" goto END
if not exist "%JobID%.bnd" goto END
fc "sav\%JobID%.bnd" "%JobID%.bnd"
goto END


:: a simple functional testing script for batch programs
:: ----------------------
:: setup
:: ----------------------
set srclog=%SrcFolder%\%SrcName%.log
set netlog=%NetProjFolder%\bin\%SrcName%.log
if exist %srclog% del %srclog%>nul
if exist %netlog% del %netlog%>nul
:: ----------------------
:: run source program
:: ----------------------
pushd "%SrcFolder%"
"%SrcName%.exe"
popd
:: ----------------------
:: run .NET  program
:: ----------------------
pushd "%NetProjFolder%\bin"
"%SrcName%.exe"
popd
:: ----------------------
:: show results
:: ----------------------
echo ------------------------------------------------------------------
echo VB6 %srclog% & dir %srclog% | find "%SrcName%.log" & type %srcLog%
echo ------------------------------------------------------------------
echo %NetLang% %netlog% & dir %netlog% | find "%SrcName%.log" & type %netLog%
echo ------------------------------------------------------------------
:: ----------------------
:: compare results
:: ----------------------
set ERRORLEVEL=
fc "%srclog%" "%netlog%"
goto Result%ErrorLevel%
:Result-1
:Result2
echo ERROR
exit 2
:Result1
echo FAIL
exit 1
:Result0 
echo PASS
exit 0

:NOTEST
echo NOTEST
exit 2

:END