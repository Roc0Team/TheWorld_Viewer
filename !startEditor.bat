@echo off

set curpath=%~dp0
cd /D %curpath%

set edit=--editor
if b%1 == bnoedit set edit=

set project=--path %curpath%TheWorld
if b%2 == bnoproject set project=

copy /Y ..\build\x64\*.dll %curpath%TheWorld\addons\twviewer\native\
rem copy /Y ..\shapelib\shapelib.dll %curpath%TheWorld\addons\twviewer\native\

rem CUSTOM BUILD RELEASE single	precision	==> scons platform=windows bits=64 -j11 vsproj=yes target=editor
rem set executable=..\..\godot\bin\godot.windows.editor.x86_64.exe
set executable=..\..\godot\bin\godot.windows.editor.x86_64.console.exe

rem CUSTOM BUILD DEBUG single precision		==> scons platform=windows bits=64 -j11 vsproj=yes target=editor dev_build=yes
rem set executable=..\..\godot\bin\godot.windows.editor.dev.x86_64.exe

				rem rem rem rem rem rem rem CUSTOM BUILD RELEASE double	precision	==> scons platform=windows bits=64 -j10 vsproj=yes target=editor precision=double
				rem rem rem rem rem rem rem set executable=..\..\godot\bin\godot.windows.editor.double.x86_64.exe

				rem rem rem rem rem rem rem CUSTOM BUILD DEBUG double precision		==> scons platform=windows bits=64 -j10 vsproj=yes target=editor dev_build=yes precision=double
				rem rem rem rem rem rem rem set executable=..\..\godot\bin\godot.windows.editor.dev.double.x86_64.exe

rem RELEASE single OFFICIAL
rem set executable=..\Bin\Godot_v4.6.2-stable_win64.exe

dir %executable%

rem set command=%executable% -v %project% %edit%
rem echo %command%
rem call %command% 2>&1 1>godot_log.txt

set verbose=--verbose

set command=powershell -NoProfile -Command "& '%executable%' %project% %edit% %verbose% 2>&1 | ForEach-Object { '{0:HH:mm:ss.fff} {1}' -f (Get-Date), $_ } | Tee-Object -FilePath 'godot_log.txt'"
echo %command%
%command%

rem call %executable% -v %project% %edit% 2>&1 1>log.txt
rem pause

