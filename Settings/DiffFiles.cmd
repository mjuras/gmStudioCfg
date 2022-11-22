:: Sample gmStudio File comparison script
:: This is an example of a comparison script that uses BeyondCompare
:: The default comparison tool is the windows fc.exe command
@echo off
set file1=%1
set file2=%2
set scr=diff.bc2
set difflog=%3

set bcomp="C:\Program Files (x86)\Beyond Compare 3\bcomp.com"
if not exist %bcomp% set bcomp="C:\Program Files\Beyond Compare 3\bcomp.com"
::----------------------------------
:: clear past results
::----------------------------------
if exist %difflog% del %difflog%
::----------------------------------
:: make sure both files are there
::----------------------------------
set e=0
if not exist %file1% echo NOT FOUND %file1%  && set e=1001
if not exist %file2% echo NOT FOUND %file2%  && set e=1001
::----------------------------------
:: do a quick samesness check 
::----------------------------------
if %e%==0 (
%bcomp% /qc %file1% %file2%
if ERRORLEVEL 10 set e=13
)
if %e%==0 (
echo MATCH %file1%> %difflog%
)
::----------------------------------
:: if files do not match, do a detailed comparison
::----------------------------------
if %e%==13 (
echo DIFFS %file1%
echo # this is a generated file; see diffFiles.cmd > %scr%
echo # compare %file1% to %file2%>> %scr%
echo log normal diff.Log>>%scr%
echo compare rules-based>>%scr%
echo text-report layout:patch options:ignore-unimportant,display-mismatches title:x output-to:%difflog% %file1% %file2%>>%scr%
rem side-by-side option
rem echo text-report layout:side-by-side options:ignore-unimportant,display-mismatches,line-numbers title:x output-to:%difflog% %file1% %file2%>>%scr%

%bcomp% @%scr% /silent

exit /b 1
)
exit /b 0

:end