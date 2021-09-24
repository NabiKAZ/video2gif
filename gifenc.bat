@ECHO OFF
REM  By: MDHEXT, Nabi KaramAliZadeh <nabikaz@gmail.com>
REM Description: Video to GIF converter
REM Version: 2.2b
REM Url: https://github.com/MDHEXT/video2gif, forked from https://github.com/NabiKAZ/video2gif
REM License: The MIT License (MIT)

SET input=%~1
SET vid=%1
SET scale=%2
SET fps=%3
SET mode=%4

SET dither=%5
SET WD=%CD%\tmp
SET palette=%WD%\template
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
ECHO 1: Bayer
ECHO 2: Heckbert
ECHO 3: Floyd Steinberg
ECHO 4: Sierra2
ECHO 5: Sierra2_4a
ECHO 6: No Dithering
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
SET frames=%palette%

IF %mode% == 1 SET encode=palettegen=stats_mode=diff
IF %mode% == 2 (
	SET encode=palettegen=stats_mode=single
	SET frames=%palette%_%%05d
)
IF %mode% == 3 SET encode=palettegen
ffmpeg -v warning -i "%vid%" -vf "%filters%,%encode%" -y "%frames%.png"
IF NOT EXIST "%palette%_00001.png" (
	IF NOT EXIST "%palette%.png" (
		ECHO Failed to generate palette file
		GOTO :cleanup
		)
)

ECHO Encoding Gif file...
SET frames=%palette%

IF %dither% == 1 SET ditherenc=dither=bayer & GOTO :ditheringenc
IF %dither% == 2 SET ditherenc=dither=heckbert & GOTO :ditheringenc
IF %dither% == 3 SET ditherenc=dither=floyd_steinberg & GOTO :ditheringenc
IF %dither% == 4 SET ditherenc=sierra2 & GOTO :ditheringenc
IF %dither% == 5 SET ditherenc=sierra2_4a & GOTO :ditheringenc
IF %dither% == 6 GOTO :nodither

:ditheringenc
IF %mode% == 1 SET decode=paletteuse=diff_mode=rectangle
IF %mode% == 2 SET decode=paletteuse=new=1 & SET frames=%palette%_%%05d
IF %mode% == 3 SET decode=paletteuse

ffmpeg -v warning -i "%vid%" -thread_queue_size 512 -i "%frames%.png" -lavfi "%filters% [x]; [x][1:v] %decode%:%ditherenc%" -y "%vid%.gif"

IF NOT EXIST "%vid%.gif" (
	ECHO Failed to generate gif file
	GOTO :cleanup
)
GOTO :cleanup

:nodither
IF %mode% == 1 SET decode=paletteuse=diff_mode=rectangle
IF %mode% == 2 (
	SET decode=paletteuse=new=1
	SET frames=%palette%_%%05d.png
)
IF %mode% == 3 SET decode=paletteuse
ffmpeg -v warning -i "%vid%" -thread_queue_size 512 -i "%frames%" -lavfi "%filters% [x]; [x][1:v] %decode%" -y "%vid%.gif"

:cleanup
ECHO Deleting Temporary files...
DEL /Q "%WD%"
RMDIR "%WD%"
ECHO Done!