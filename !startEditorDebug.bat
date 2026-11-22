@echo off

set curpath=%~dp0
cd /D %curpath%

set edit=-e
if b%1 == bnoedit set edit=

set project=--path %curpath%TheWorld
if b%2 == bnoproject set project=

copy /Y ..\build\x64\*.dll %curpath%TheWorld\addons\twviewer\native\
rem copy /Y ..\shapelib\shapelib.dll %curpath%TheWorld\addons\twviewer\native\

rem RELEASE single OFFICIAL
rem set executable=Godot_v4.2.1-stable_win64.exe

rem CUSTOM BUILD RELEASE single	precision	==> scons platform=windows bits=64 -j11 vsproj=yes target=editor
rem set executable=..\..\godot\bin\godot.windows.editor.x86_64.exe

rem CUSTOM BUILD DEBUG single precision		==> scons platform=windows bits=64 -j11 vsproj=yes target=editor dev_build=yes
set executable=..\..\godot\bin\godot.windows.editor.dev.x86_64.console.exe

				rem rem rem rem rem rem rem CUSTOM BUILD RELEASE double	precision	==> scons platform=windows bits=64 -j10 vsproj=yes target=editor precision=double
				rem rem rem rem rem rem rem set executable=..\..\godot\bin\godot.windows.editor.double.x86_64.exe

				rem rem rem rem rem rem rem CUSTOM BUILD DEBUG double precision		==> scons platform=windows bits=64 -j10 vsproj=yes target=editor dev_build=yes precision=double
				rem rem rem rem rem rem rem set executable=..\..\godot\bin\godot.windows.editor.dev.double.x86_64.exe

dir %executable%

rem call %executable% -v %project% %edit% 2>&1 1>log.txt

set verbose=--verbose

set command=powershell -NoProfile -Command "& '%executable%' %project% %verbose% 2>&1 | ForEach-Object { '{0:HH:mm:ss.fff} {1}' -f (Get-Date), $_ } | Tee-Object -FilePath 'godot_log.txt'"
echo %command%
%command%

rem pause

