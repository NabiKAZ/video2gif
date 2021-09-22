@ECHO off
REM  By: MDHEXT, Nabi KaramAliZadeh <nabikaz@gmail.com>
REM Description: Video to GIF converter
REM Version: 2.0b
REM Url: https://github.com/MDHEXT/video2gif, forked from https://github.com/NabiKAZ/video2gif
REM License: The MIT License (MIT)

SET input=%~1
SET vid=%1
SET scale=%2
SET fps=%3
SET mode=%4

SET dither=%5
SET WD=%CD%\tmp
SET palette=%CD%\tmp\template
SET filters=fps=%fps%,scale=%scale%:-1:flags=lanczos
GOTO :help_check

:help_message
ECHO -----------------------------------------------------------------------------------------------
ECHO Video to GIF converter v2.0b ^(C^) 2017-2021, MDHEXT ^&^ Nabi KaramAliZadeh ^<nabikaz@gmail.com^>
ECHO You can download this fork from here: https://github.com/MDHEXT/video2gif
ECHO you can download the original release here: https://github.com/NabiKAZ/video2gif
ECHO This tool uses ffmpeg, you can download that here: http://ffmpeg.zeranoe.com/builds
ECHO -----------------------------------------------------------------------------------------------
ECHO Usage:
ECHO gifenc [input_file] [width_in_pixels] [framerate_in_Hz] [palettegen_mode] [Dithering_Algorithm]
ECHO -----------------------------------------------------------------------------------------------
ECHO Palettegen Modes:
ECHO 1: diff - only what moves affects the palette
ECHO 2: single - one palette per frame
ECHO 3: full - one palette for the whole gif
ECHO -----------------------------------------------------------------------------------------------
ECHO Dithering Options:
ECHO 1: bayer
ECHO 2: heckbert
ECHO 3: floyd steinberg
ECHO 4: sierra2
ECHO 5 sierra2_4a
GOTO :EOF

:help_check
IF "%input%" == "" GOTO :help_message
IF "%input%" == "help" GOTO :help_message
IF "%input%" == "h" GOTO :help_message
IF "%vid%" == "" GOTO :help_message
IF "%scale%" == "" GOTO :help_message
IF "%fps%" == "" GOTO :help_message
IF "%mode%" == "" GOTO :help_message
IF "%dither%" == "" GOTO :help_message

ECHO Creating Working Directory...
MD "%WD%"

ECHO Generating Palette...
IF %mode% == 1 ffmpeg -v warning -i "%vid%" -vf "%filters%,palettegen=stats_mode=diff" -y "%palette%.png"
IF %mode% == 2 ffmpeg -v warning -i "%vid%" -vf "%filters%,palettegen=stats_mode=single" -y "%palette%_%%05d.png"
IF %mode% == 3 ffmpeg -v warning -i "%vid%" -vf "%filters%,palettegen" -y "%palette%.png"
IF NOT EXIST "%palette%_00001.png" (
	IF NOT EXIST "%palette%.png" (
		ECHO Failed to generate palette file
		GOTO :cleanup
	)
)

ECHO Encoding Gif file...
IF %mode% == 1 (
	IF %dither% == 1 ffmpeg -v warning -i "%vid%" -i "%palette%.png" -lavfi "%filters% [x]; [x][1:v] paletteuse=diff_mode=rectangle:dither=bayer" -y "%vid%.gif"
	IF %dither% == 2 ffmpeg -v warning -i "%vid%" -i "%palette%.png" -lavfi "%filters% [x]; [x][1:v] paletteuse=diff_mode=rectangle:dither=heckbert" -y "%vid%.gif"
	IF %dither% == 3 ffmpeg -v warning -i "%vid%" -i "%palette%.png" -lavfi "%filters% [x]; [x][1:v] paletteuse=diff_mode=rectangle:dither=floyd_steinberg" -y "%vid%.gif"
	IF %dither% == 4 ffmpeg -v warning -i "%vid%" -i "%palette%.png" -lavfi "%filters% [x]; [x][1:v] paletteuse=diff_mode=rectangle:dither=sierra2" -y "%vid%.gif"
	IF %dither% == 5 ffmpeg -v warning -i "%vid%" -i "%palette%.png" -lavfi "%filters% [x]; [x][1:v] paletteuse=diff_mode=rectangle:dither=sierra2_4a" -y "%vid%.gif"
)

IF %mode% == 2 (
	IF %dither% == 1 ffmpeg -v warning -i "%vid%" -thread_queue_size 512 -i "%palette%_%%05d.png" -lavfi "%filters% [x]; [x][1:v] paletteuse=new=1:dither=bayer" -y "%vid%.gif"
	IF %dither% == 2 ffmpeg -v warning -i "%vid%" -thread_queue_size 512 -i "%palette%_%%05d.png" -lavfi "%filters% [x]; [x][1:v] paletteuse=new=1:dither=heckbert" -y "%vid%.gif"
	IF %dither% == 3 ffmpeg -v warning -i "%vid%" -thread_queue_size 512 -i "%palette%_%%05d.png" -lavfi "%filters% [x]; [x][1:v] paletteuse=new=1:dither=floyd_steinberg" -y "%vid%.gif"
	IF %dither% == 4 ffmpeg -v warning -i "%vid%" -thread_queue_size 512 -i "%palette%_%%05d.png" -lavfi "%filters% [x]; [x][1:v] paletteuse=new=1:dither=sierra2" -y "%vid%.gif"
	IF %dither% == 5 ffmpeg -v warning -i "%vid%" -thread_queue_size 512 -i "%palette%_%%05d.png" -lavfi "%filters% [x]; [x][1:v] paletteuse=new=1:dither=sierra2_4a" -y "%vid%.gif"
)

IF %mode% == 3 (
	IF %dither% == 1 ffmpeg -v warning -i "%vid%" -i "%palette%.png" -lavfi "%filters% [x]; [x][1:v] paletteuse=dither=bayer" -y "%vid%.gif"
	IF %dither% == 2 ffmpeg -v warning -i "%vid%" -i "%palette%.png" -lavfi "%filters% [x]; [x][1:v] paletteuse=dither=heckbert" -y "%vid%.gif"
	IF %dither% == 3 ffmpeg -v warning -i "%vid%" -i "%palette%.png" -lavfi "%filters% [x]; [x][1:v] paletteuse=dither=floyd_steinberg" -y "%vid%.gif"
	IF %dither% == 4 ffmpeg -v warning -i "%vid%" -i "%palette%.png" -lavfi "%filters% [x]; [x][1:v] paletteuse=dither=sierra2" -y "%vid%.gif"
	IF %dither% == 5 ffmpeg -v warning -i "%vid%" -i "%palette%.png" -lavfi "%filters% [x]; [x][1:v] paletteuse=dither=sierra2_4a" -y "%vid%.gif"
)

IF NOT EXIST "%vid%.gif" (
	ECHO Failed to generate gif file
	GOTO :cleanup
)

:cleanup
ECHO Deleting Temporary files...
DEL /Q "%CD%\tmp"
RMDIR "%CD%\tmp"
	
ECHO Done!