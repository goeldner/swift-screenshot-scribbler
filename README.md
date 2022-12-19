# ScreenshotScribbler (scrscr)

A command line tool and library that creates a new image with same dimensions as a given screenshot, adds a background, reduces the size of the original screenshot, places it nicely and scribbles a caption besides it.

## Build and install

Clone the repository, change into the folder, then execute:

```
$ swift build --configuration release
$ cp -f .build/release/scrscr /usr/local/bin/scrscr
```

You can also use the `install.sh` script.

## Usage

By default the tool places the caption on top and the screenshot on bottom of the image. It uses a white background, black text and a subtle shadow around the screenshot:

```
$ scrscr --caption "Scribble this caption" --input example-input.png --output example-output-default.png
```

The layout may be customized with command line options. Following example defines all possible options including their default values:

```
$ scrscr \
    --caption "Example output with default options and long caption" \
    --input example-input.png \
    --output example-output-default.png \
    --layout-type "text-before-image" \
    --layout-text-ratio 0.25 \
    --background-color "#FFFFFF" \
    --text-color "#000000" \
    --font-name "SF Compact" \
    --font-style "Bold" \
    --font-size 32 \
    --image-size-reduction 0.85 \
    --image-corner-radius 5 \
    --image-shadow-color "#000000" \
    --image-shadow-size 5 \
    --verbose
```

Please also have a look at the `examples.sh` script and `Examples` folder for more usage scenarios.

## About

I started developing this tool as a side project, because I did not want to use fastlane for any reason, which provides something similar with its frameit plugin. I wanted to have a simple command line tool, which I just can call in my scripts (that already generate screenshots automatically) in order to beautify them for the App Store.

This project uses pure CoreGraphics and CoreText APIs for layouting (no AppKit or UIKit), so it should be quite portable.

There will be updates and new features from time to time and I try to keep working on it, as long as I use it myself.

## Coffee

If you like this tool, you could buy me a coffee :)

<a href="https://www.buymeacoffee.com/goeldner" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" height="50" width="217"></a>
