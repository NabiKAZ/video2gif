# video2gif

![sample gif file generated](sample.gif)

A batch script for convert video to GIF files by FFmpeg.exe on Windows.

## Installation
* Clone the repo
* Install [FFmpeg](http://ffmpeg.zeranoe.com/builds/) for Windows.
* Make sure the `ffmpeg.exe` and `gifenc.bat` are on your systems path.

## Usage
```
gifenc [input_file] [width_in_pixels] [framerate_in_Hz] [palettegen_mode] [Dithering_Algorithm]
```

## Options:
```
Palettegen Modes:
      1: diff - only what moves affects the palette
      2: single - one palette per frame
      3: full - one palette for the whole gif
-----------------------------------------------------------------------------------------------
Dithering Options:
      1: bayer
      2: heckbert
      3: floyd steinberg
      4: sierra2
      5 sierra2_4a
```

## Examples:
```
  gifenc sample.mp4 300 15 1 1
  gifenc sample.mp4 600 10 2 3
  gifenc sample.mp4 350 13 3 1

```

## Tips
Special thanks to [this article](http://blog.pkh.me/p/21-high-quality-gif-with-ffmpeg.html).
