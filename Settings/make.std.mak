#  %JobId%

CSFLAGS = /d:DEBUG
PRJFOLDER = %ProjFolder%
PRJNAME = %VbpName%
MIGMODE = %MigMode%
DIALECT = %Dialect%
EXEC_NAME = %ExeName%
CODE_FILES = \
%CodeFiles%
REFR_FILES = \
%References%
IMPORTS = \
%Imports%

#COMMAND LINE
%BuildFolder%$(EXEC_NAME):  $(CODE_FILES)
  @echo ----- Job Attributes --------------------------------------------------------
  @echo PRJNAME = $(PRJNAME)
  @echo PRJFOLDER = $(PRJFOLDER)
  @echo MIGMODE = $(MIGMODE)
  @echo DIALECT = $(DIALECT)
  @echo ----- Creating Resources ----------------------------------------------------
%ResCommands%
  @echo ---------- Compiling --------------------------------------------------------
  "%NetCompiler%" %Rootspace% $(CSFLAGS) /out:%BuildFolder%$(EXEC_NAME) %ResSwitches% /target:%OutputType% %StartUpObject% $(CODE_FILES)  $(REFR_FILES) $(IMPORTS) >> "%NetLogPath%" 2>&1
  @echo ----- Build of $(EXEC_NAME) succeeded.  -------------------------------------
  @echo ---------- Copying Binaries to Build Folder ---------------------------------
%CopyRefs%

