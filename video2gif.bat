@ECHO OFF
REM By: Nabi KaramAliZadeh <nabikaz@gmail.com>
REM Description: video to gif converter
REM Version: 1.0.1
REM Url: https://github.com/NabiKAZ/video2gif
REM License: The MIT License (MIT)

SETLOCAL

SET "input="
SET "output="
SET "overwrite="
SET "fps="
SET "width="
SET "start_time="
SET "duration="
SET "time_range="
SET "palette="
SET "max_colors="
SET "dither="

SET input=%~1
SET base_file=%~dpn1
SET input_filename=%~n1%~x1
SHIFT

IF "%input%" == "" (
    ECHO Video to GIF converter v1.0.0 ^(C^) 2017, Nabi KaramAliZadeh ^<nabikaz@gmail.com^>
    ECHO You can download it from here: https://github.com/NabiKAZ/video2gif
    ECHO This tools use of ffmpeg here: http://ffmpeg.zeranoe.com/builds
    ECHO.
    ECHO Usage: video2gif SOURCE_FILE [OPTIONS]
    ECHO.
    ECHO Options:
    ECHO   SOURCE_FILE      Source video file name for convert
    ECHO                    also you can drag and drop source video file to this batch file directly
    ECHO   -o               Output destination .GIF file name
    ECHO                    if not set it, use video source file name with new .gif extension
    ECHO   -y               Overwrite destination file
    ECHO                    if not set it, appears prompt for overwrite destination file
    ECHO   -f               Frame per second ^(fps^)
    ECHO                    default: 15
    ECHO   -w               Width scale of destination gif file
    ECHO                    in pixel unit and ^(-1^) for use original width, default: -1
    ECHO   -s               Start time of video source for crop
    ECHO                    in second or time format ^(ex. 1:12^), if set it, so must be set ^(-d^) param
    ECHO   -d               Duration time of video source for crop
    ECHO                    in second, if set it, so must be set ^(-s^) param
    ECHO   -c               Maximum number of colors to the palette
    ECHO                    must be ^(^<=256^), default: 256
    ECHO   -q               Quality of destination gif file
    ECHO                    must be a number between 1^(low^) to 6^(high^), default: 5
    ECHO.
    ECHO Examples:
    ECHO   video2gif sample.mp4
    ECHO   video2gif sample.mp4 -y -w 60 -q 1 -f 10
    ECHO   video2gif sample.mp4 -o new_file.gif -y -w 100 -f 10 -s 10 -d 5
    ECHO   video2gif sample.mp4 -s 0:30 -d 20 -c 128 -q 6
    ECHO   video2gif sample.mp4 -s 1:16.5 -d 8.3
    GOTO :EOF
)

:loop
IF NOT "%~1"=="" (
    IF "%~1"=="-o" SET "output=%~2" & SHIFT
    IF "%~1"=="-y" SET "overwrite=-y"
    IF "%~1"=="-f" SET "fps=%~2" & SHIFT
    IF "%~1"=="-w" SET "width=%~2" & SHIFT
    IF "%~1"=="-s" SET "start_time=%~2" & SHIFT
    IF "%~1"=="-d" SET "duration=%~2" & SHIFT
    IF "%~1"=="-c" SET "max_colors=%~2" & SHIFT
    IF "%~1"=="-q" SET "dither=%~2" & SHIFT
    SHIFT
    GOTO :loop
)

if "%output%"=="" SET output=%base_file%.gif
if "%fps%"=="" SET fps=15
if "%width%"=="" SET width=-1
if not "%start_time%"=="" if not "%duration%"=="" SET time_range=-ss %start_time% -t %duration%
if "%max_colors%"=="" SET max_colors=256
if "%dither%"=="" SET dither=sierra2_4a
if "%dither%"=="1" SET dither=none
if "%dither%"=="2" SET dither=sierra2
if "%dither%"=="3" SET dither=floyd_steinberg
if "%dither%"=="4" SET dither=heckbert
if "%dither%"=="5" SET dither=sierra2_4a
if "%dither%"=="6" SET dither=bayer

SET palette=%TEMP%\%input_filename%.png
SET filters=fps=%fps%,scale=%width%:-1:flags=lanczos

ECHO Generating palette file. Please wait...

CALL ffmpeg -v error %time_range% -i "%input%" -vf "%filters%,palettegen=max_colors=%max_colors%" -y "%palette%"

IF NOT EXIST "%palette%" (
	ECHO Failed to generate palette file.
	GOTO :EOF
)

ECHO Generating gif file. Please wait...

CALL ffmpeg -v error %time_range% -i "%input%" -i "%palette%" -lavfi "%filters% [x]; [x][1:v] paletteuse=dither=%dither%" %overwrite% "%output%"

IF NOT EXIST "%output%" (
	ECHO Failed to generate gif file.
	GOTO :EOF
)

DEL /F /Q "%palette%"

ECHO "%output%" Gif file generated successfully.
ECHO Done.
