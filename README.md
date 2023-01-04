# ScreenshotScribbler (scrscr)

A command line tool and library that creates a new image with same dimensions as a given screenshot, adds a background, reduces the size of the original screenshot, places it nicely and scribbles a caption next to it.

## Build and install

Clone the repository, change into the folder, then execute:

```
$ swift build --configuration release
$ cp -f .build/release/scrscr /usr/local/bin/scrscr
```

You can also use the `install.sh` script.

## Usage

By default, the tool places the caption on top and the screenshot on bottom of the image. It uses a white background, black caption and a subtle shadow behind the screenshot.

Following example uses the default settings:

```
$ scrscr --caption "Scribble this caption" --screenshot example-input.png --output example-output.png
```

The layout may be customized by using several command line options. The `--help` describes all options:

```
$ scrscr --help
```

Following example defines all possible options including their default values:

```
$ scrscr \
    --caption "Example output with default options and long caption" \
    --screenshot example-input.png \
    --output example-output-default.png \
    --layout "caption-before-screenshot" \
    --background-color "#FFFFFF" \
    --caption-size-factor 0.25 \
    --caption-alignment "center" \
    --caption-color "#000000" \
    --caption-font-name "SF Compact" \
    --caption-font-style "Bold" \
    --caption-font-size 32 \
    --screenshot-size-factor 0.85 \
    --screenshot-corner-radius 5 \
    --screenshot-shadow-size 5 \
    --screenshot-shadow-color "#000000" \
    --screenshot-border-size 0 \
    --screenshot-border-color "#000000" \
    --verbose
```

Please also have a look at the `examples.sh` script and `Examples` folder for more usage scenarios.

### Colors and gradients

Defining colors on the command line is inspired by a subset of the widely known CSS syntax.

A single color may be defined in hexadecimal syntax as follows, where each two digits define the red, green and blue part of the color:

```
--background-color "#0099FF"
```

Some options also support gradients, i.e. the `--background-color` and `--screenshot-border-color`. For gradients, at least two colors have to be defined. The colors are rendered from top to bottom.

Linear gradients:

```
--background-color "linear-gradient(#FF0000, #FFA500, #FFFF00, #00FF00, #0000FF, #FF00FF)"
```

Radial gradients:

```
--background-color "radial-gradient(#FF0000, #0000FF)"
```

## About

I started developing this tool as a side project, because I did not want to use fastlane for any reason, which provides something similar with its frameit plugin. I wanted to have a simple command line tool, which I just can call in my scripts (that already generate screenshots automatically) in order to beautify them for the App Store.

This project uses pure CoreGraphics and CoreText APIs for layouting (no AppKit or UIKit), so it should be quite portable.

There will be updates and new features from time to time and I try to keep working on it, as long as I use it myself.

## Coffee

If you like this tool, you could buy me a coffee :)

<a href="https://www.buymeacoffee.com/goeldner" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" height="50" width="217"></a>
