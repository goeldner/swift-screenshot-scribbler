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

### Layout types

There are four different layout types available, which can be defined using the `--layout` option:

- caption-before-screenshot (default)
- caption-after-screenshot
- caption-between-screenshots
- screenshot-only

All layouts can be customized further, i.e. the options `--caption-size-factor` and `--screenshot-size-factor` enable more variations.

Examples of the four different layout types:

<img
  src="https://github.com/goeldner/swift-screenshot-scribbler/blob/main/Examples/example-output-layout-caption-before-screenshot.png?raw=true"
  alt="Layout: caption-before-screenshot" title="Layout: caption-before-screenshot"
  width="160" style="margin-right: 20px; max-width: 160px">
<img
  src="https://github.com/goeldner/swift-screenshot-scribbler/blob/main/Examples/example-output-layout-caption-after-screenshot.png?raw=true"
  alt="Layout: caption-after-screenshot" title="Layout: caption-after-screenshot"
  width="160" style="margin-right: 20px; max-width: 160px">
<img
  src="https://github.com/goeldner/swift-screenshot-scribbler/blob/main/Examples/example-output-layout-caption-between-screenshots.png?raw=true"
  alt="Layout: caption-between-screenshots" title="Layout: caption-between-screenshots"
  width="160" style="margin-right: 20px; max-width: 160px">
<img
  src="https://github.com/goeldner/swift-screenshot-scribbler/blob/main/Examples/example-output-layout-screenshot-only.png?raw=true"
  alt="Layout: screenshot-only" title="Layout: screenshot-only"
  width="160" style="margin-right: 20px; max-width: 160px">

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

Examples of the two different gradient types:

<img
  src="https://github.com/goeldner/swift-screenshot-scribbler/blob/main/Examples/example-output-gradient-linear-rainbow.png?raw=true"
  alt="Gradient: linear-gradient" title="Gradient: linear-gradient"
  width="160" style="margin-right: 20px; max-width: 160px">
<img
  src="https://github.com/goeldner/swift-screenshot-scribbler/blob/main/Examples/example-output-gradient-radial-red-blue.png?raw=true"
  alt="Gradient: radial-gradient" title="Gradient: radial-gradient"
  width="160" style="margin-right: 20px; max-width: 160px">

## About

I started developing this tool as a side project, because I did not want to use fastlane for any reason, which provides something similar with its frameit plugin. I wanted to have a simple command line tool, which I just can call in my scripts (that already generate screenshots automatically) in order to beautify them for the App Store.

This project uses pure CoreGraphics and CoreText APIs for layouting (no AppKit or UIKit), so it should be quite portable.

There will be updates and new features from time to time and I try to keep working on it, as long as I use it myself.

## Coffee

If you like this tool, you could buy me a coffee :)

<a href="https://www.buymeacoffee.com/goeldner" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" height="50" width="217"></a>
