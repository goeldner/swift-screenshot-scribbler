# ScreenshotScribbler (scrscr)

A command line tool and library that creates a new image with same dimensions as a given screenshot, adds a background, reduces the size of the original screenshot, places it nicely and scribbles a caption besides it.

## Build and install

Clone the repository, change into the folder, then execute:

```
$ swift build --configuration release
$ cp -f .build/release/scrscr /usr/local/bin/scrscr
```

## Execute

By default the tool places the caption on top and the screenshot on bottom of the image. It uses a white background, black text and a subtle shadow around the screenshot:

```
$ scrscr --caption "Scribble this caption" --input example-screenshot.png --output example-result.png
```

## About

I developed this tool as a side project, because I did not want to use fastlane for any reason, which provides something similar.

There will be updates and new features from time to time and I try to keep it working, as long as I use it myself.

## Coffee

If you like this tool, you could buy me a coffee :)

<a href="https://www.buymeacoffee.com/goeldner" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" height="50" width="217"></a>
