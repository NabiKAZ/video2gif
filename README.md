# video2gif

![sample gif file generated](sample.gif)

A batch script for convert video to GIF files by FFmpeg.exe on Windows.

## Installation
* Clone the repo
* Install [FFmpeg](http://ffmpeg.zeranoe.com/builds/) for Windows.
* Make sure the `ffmpeg.exe` and `video2gif.bat` are on your systems path.

## Usage
**Method #1:** Anywhere you can use it by this command in `cmd`:
```
video2gif myvideo.mp4
```
Then you have `myvideo.gif` in current directory.

If `myvideo.gif` there is existed, question from you for overwrite it.

**Method #2:** You can just drag and drop `.gif` file on the `video2gif.bat` file.

## Advance Usage

```
video2gif SOURCE_FILE [OPTIONS]
```

## Options:
```
  SOURCE_FILE      Source video file name for convert
                   also you can drag and drop source video file to this batch file directly
  -o               Output destination .GIF file name
                   if not set it, use video source file name with new .gif extension
  -y               Overwrite destination file
                   if not set it, appears prompt for overwrite destination file
  -f               Frame per second (fps)
                   default: 15
  -w               Width scale of destination gif file
                   in pixel unit and (-1) for use original width, default: -1
  -s               Start time of video source for crop
                   in second or time format (ex. 1:12), if set it, so must be set (-d) param
  -d               Duration time of video source for crop
                   in second, if set it, so must be set (-s) param
  -c               Maximum number of colors to the palette
                   must be (<=256), default: 256
  -q               Quality of destination gif file
                   must be a number between 1(low) to 6(high), default: 5
```

## Examples:
```
  video2gif sample.mp4
  video2gif sample.mp4 -y -w 60 -q 1 -f 10
  video2gif sample.mp4 -o new_file.gif -y -w 100 -f 10 -s 10 -d 5
  video2gif sample.mp4 -s 0:30 -d 20 -c 128 -q 6
  video2gif sample.mp4 -s 1:16.5 -d 8.3
```

## Tips
Special thanks to [this article](http://blog.pkh.me/p/21-high-quality-gif-with-ffmpeg.html).
