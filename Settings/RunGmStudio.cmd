:: Description: this script may be used to run gmStudio in batch.  Used in CI process.
@echo off

set GmStudioExe="C:\Program Files (x86)\GreatMigrations\gmStudio\gmStudio.exe"

::-----------------------------------------------------------------
:: mig is the gmStudio project to process
::-----------------------------------------------------------------

set report=C:\gmClients\CIMS\proj\report
set mig=C:\gmClients\CIMS\proj\CIMS_Full.gmproj


::-----------------------------------------------------------------
:: Filter may contain a string specifying one or more migration
:: tasks to include in processing.  Multiple tasks can be joined
:: by '+', wildcard = '*'.  This string should not be quoted.
:: if blank, all tasks in tasks list are processed.
::-----------------------------------------------------------------
set filter="*"
:: remove double quotes
set filter=%filter:~1,-1%

::-----------------------------------------------------------------
:: If AutoBatch=YES then  the tasks/tools specified in the
:: migrationSet file (.gmproj) will be performed.  Otherwise, the 
:: set of task/tools specified below will be performed.
:: must be =NO for reports to run.
::-----------------------------------------------------------------

set autobatch="/AUTOBATCH='NO'"
   
::-----------------------------------------------------------------
:: Select Migration Tasks (only used when AUTOBATCH=NO)
::-----------------------------------------------------------------
set tasks=
::set tasks=%tasks%Validate Source,
::set tasks=%tasks%Build VB6,
::set tasks=%tasks%Snapshot a Baseline,
::set tasks=%tasks%Reset Task Status,
set tasks=%tasks%Run Translation,
set tasks=%tasks%Deploy Translation,
::set tasks=%tasks%Build Translation

::-----------------------------------------------------------------
:: Select Migration Tools (only used when AUTOBATCH=NO)
::-----------------------------------------------------------------

set tools=
set tools=%tools%Apply Task Filter,
::set tools=%tools%Author Interop Assemblies,
::set tools=%tools%Author Interface Descriptions,
::set tools=%tools%Run Assessment Wizard,
::set tools=%tools%Set Build Order,
::set tools=%tools%Author Resx Files,

::-----------------------------------------------------------------
:: Select Reports
::-----------------------------------------------------------------

set rprts=
::-----------------------------------------------------------------
:: Code Scans
::-----------------------------------------------------------------
::set rprts=%rprts%Source Structure,
::set rprts=%rprts%Source References,
::set rprts=%rprts%Source Members,
::set rprts=%rprts%Source GUI Scan,
::set rprts=%rprts%Source Code Scan,
::set rprts=%rprts%Iceberg,
::-----------------------------------------------------------------
:: Project Reports
::-----------------------------------------------------------------
::set rprts=%rprts%Project Summary,
::set rprts=%rprts%Metrics Summary,
::set rprts=%rprts%Migration Set,
::set rprts=%rprts%Interface File Headers,
::set rprts=%rprts%Interface File ProgIds,
::set rprts=%rprts%Code Bundle Metrics,
::set rprts=%rprts%.NET Build Logs,
::set rprts=%rprts%Translation Logs,
set rprts=%rprts%All Logs,
::-----------------------------------------------------------------
:: Semantic Model Reports
::-----------------------------------------------------------------
::set rprts=%rprts%Semantic Definitions,
::set rprts=%rprts%Semantic References,
::set rprts=%rprts%Semantic Audit,
::-----------------------------------------------------------------
:: Utility Reports
::-----------------------------------------------------------------
::set rprts=%rprts%Migration Project List,
::set rprts=%rprts%Target Code Scan,
set rprts=%rprts%Generate Visual Studio Solution,

::-----------------------------------------------------------------
:: Assemble Command Line to run/deploy all translations
::-----------------------------------------------------------------

set logstart=
::"/logstart='\temp\gmStudioStartUp.log'"
set    mig="/MIG='%mig%'"
set    tasks="/TASKS='%tasks%'"
set    tools="/TOOLS='%tools%'"
set    rprts=/REPORTS='%rprts%'" 
set    cfg=
::"/CFG='%wrk%\batch\gmStudioBatch.cfg'"
set   filter="/FILTER='%filter%'"

if exist "%report%\*-AllLog.txt" del "%report%\*-AllLog.txt"

echo running %GmStudioExe%
%GmStudioExe% %autoBatch% %filter% %mig% %tasks% %tools% %rprts% %cfg% %logstart%

:: report results
if NOT exist "%report%\*-AllLog.txt" echo Translation logs not found & exit/b 1
findstr /c:"---- TASK" /c:"Translation Status" /c:".NET Lines" "%report%\*-AllLog.txt"    

:: raise error if errors are found in AllLog report
SET ERRORLEVEL=
findstr /c:"[ABEND]" "%report%\*-AllLog.txt">nul
if ERRORLEVEL 1 echo NO ERRORS DETECTED & exit/b 0
echo ERRORS DETECTED & exit/b 1



