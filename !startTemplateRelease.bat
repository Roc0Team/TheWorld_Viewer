@echo off

set curpath=%~dp0
cd /D %curpath%

set project=--path %curpath%TheWorld

copy /Y ..\build\x64\*.dll %curpath%TheWorld\addons\twviewer\native\
rem copy /Y ..\shapelib\shapelib.dll %curpath%TheWorld\addons\twviewer\native\

rem CUSTOM BUILD RELEASE single	precision	==> scons platform=windows bits=64 -j11 vsproj=yes target=editor
set executable=..\..\godot\bin\godot.windows.template_release.x86_64.console.exe

rem CUSTOM BUILD DEBUG single precision		==> scons platform=windows bits=64 -j11 vsproj=yes target=editor dev_build=yes
rem set executable=..\..\godot\bin\godot.windows.editor.dev.x86_64.console.exe

				rem rem rem rem rem rem rem CUSTOM BUILD RELEASE double	precision	==> scons platform=windows bits=64 -j10 vsproj=yes target=editor precision=double
				rem rem rem rem rem rem rem set executable=..\..\godot\bin\godot.windows.editor.double.x86_64.console.exe

				rem rem rem rem rem rem rem CUSTOM BUILD DEBUG double precision		==> scons platform=windows bits=64 -j10 vsproj=yes target=editor dev_build=yes precision=double
				rem rem rem rem rem rem rem set executable=..\..\godot\bin\godot.windows.editor.dev.double.x86_64.console.exe

rem RELEASE single OFFICIAL
rem set executable=..\..\godot\Bin\Godot_v4.6.2-stable_win64.console.exe

dir %executable%

rem set verbose=--verbose
rem set proj_params=--WorldDepthQuads=1 --WorldCacheQuads=0 --StrictToBuildMode
set proj_params=--WorldDepthQuads=12 --WorldCacheQuads=2 --StrictToBuildMode

rem Add Timestamp to log file
rem set command=powershell -NoProfile -Command "& '%executable%' %project% %verbose% %proj_params% 2>&1 | ForEach-Object { '{0:HH:mm:ss.fff} {1}' -f (Get-Date), $_ } | Tee-Object -FilePath 'godot_log.txt'"
set command=%executable% %project% %verbose% %proj_params% 2>&1 1>godot_log.txt

echo %command%
call %command%

rem pause

