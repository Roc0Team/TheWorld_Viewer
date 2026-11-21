@echo off

set curpath=%~dp0
cd /D %curpath%

set project=--path %curpath%TheWorld

copy /Y ..\build\x64\*.dll %curpath%TheWorld\addons\twviewer\native\
rem copy /Y ..\shapelib\shapelib.dll %curpath%TheWorld\addons\twviewer\native\

rem RELEASE single OFFICIAL
rem set executable=Godot_v4.2.1-stable_win64.exe

rem CUSTOM BUILD RELEASE single	precision	==> scons platform=windows bits=64 -j11 vsproj=yes target=editor
set executable=..\..\godot\bin\godot.windows.template_debug.x86_64.console.exe

rem CUSTOM BUILD DEBUG single precision		==> scons platform=windows bits=64 -j11 vsproj=yes target=editor dev_build=yes
rem set executable=..\..\godot\bin\godot.windows.editor.dev.x86_64.exe

				rem rem rem rem rem rem rem CUSTOM BUILD RELEASE double	precision	==> scons platform=windows bits=64 -j10 vsproj=yes target=editor precision=double
				rem rem rem rem rem rem rem set executable=..\..\godot\bin\godot.windows.editor.double.x86_64.exe

				rem rem rem rem rem rem rem CUSTOM BUILD DEBUG double precision		==> scons platform=windows bits=64 -j10 vsproj=yes target=editor dev_build=yes precision=double
				rem rem rem rem rem rem rem set executable=..\..\godot\bin\godot.windows.editor.dev.double.x86_64.exe

dir %executable%

rem set command=%executable% -v %project% --WorldDepthQuads=1 --WorldCacheQuads=0 --StrictToBuildMode
set command=%executable% -v %project% --WorldDepthQuads=7 --WorldCacheQuads=2 --StrictToBuildMode
rem set command=%executable% -v %project% --WorldDepthQuads=12 --WorldCacheQuads=2 --StrictToBuildMode
echo %command%
call %command% 2>&1 1>log.txt
rem call %executable% -v %project% %edit% 2>&1 1>log.txt

set verbose=--verbose
set proj_params=--WorldDepthQuads=7 --WorldCacheQuads=2 --StrictToBuildMode

set command=powershell -NoProfile -Command "& '%executable%' %project% %verbose% %proj_params% 2>&1 | ForEach-Object { '{0:HH:mm:ss.fff} {1}' -f (Get-Date), $_ } | Tee-Object -FilePath 'godot_log.txt'"
echo %command%
%command%

rem pause

