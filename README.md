# ScreenshotScribbler (scrscr)

A command line tool `scrscr` and a library that creates a new image with same dimensions as a given screenshot, adds a background, reduces the size of the original screenshot, places it nicely and scribbles a caption next to it.

## Setup

The `scrscr` command can be easily installed via Homebrew, or by cloning the repository and using the Makefile or by building everything manually.

### Homebrew

Tap this repository:

```
$ brew tap goeldner/formulae
```

Install the package:

```
$ brew install scrscr
```

### Make

If you want to use `make`, there is a `Makefile` defined for this project. Clone the repository, change into the folder, then execute following to install the `scrscr` command to your `/usr/local/bin` folder:

```
$ make clean install
```

### Build

You can also build and install manually. Clone the repository, change into the folder, then execute:

```
$ swift build --configuration release
$ cp -f .build/release/scrscr /usr/local/bin/scrscr
```

## Usage

By default, the tool places the caption on top and the screenshot on bottom of the image. It uses a white background, black caption and a subtle shadow behind the screenshot.

Following example uses the default settings:

```
$ scrscr --caption "Scribble this caption" --screenshot example-input.png --output example-output.png
```

The layout may be customized by using several command line options. Display the help about all available commands and options:

```
$ scrscr --help
$ scrscr help decorate
```

Following example defines all basic options including their default values:

```
$ scrscr decorate \
    --caption "Example output with default options and long caption" \
    --screenshot example-input.png \
    --output example-output-default.png \
    --layout "caption-before-screenshot" \
    --background-color "#FFFFFF" \
    --background-image-scaling "stretch-fill" \
    --background-image-alignment "middle center" \
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
  alt="Layout: caption-before-screenshot"
  title="Layout: caption-before-screenshot"
  width="160"> &nbsp; 
<img
  src="https://github.com/goeldner/swift-screenshot-scribbler/blob/main/Examples/example-output-layout-caption-after-screenshot.png?raw=true"
  alt="Layout: caption-after-screenshot"
  title="Layout: caption-after-screenshot"
  width="160"> &nbsp; 
<img
  src="https://github.com/goeldner/swift-screenshot-scribbler/blob/main/Examples/example-output-layout-caption-between-screenshots.png?raw=true"
  alt="Layout: caption-between-screenshots"
  title="Layout: caption-between-screenshots"
  width="160"> &nbsp; 
<img
  src="https://github.com/goeldner/swift-screenshot-scribbler/blob/main/Examples/example-output-layout-screenshot-only.png?raw=true"
  alt="Layout: screenshot-only"
  title="Layout: screenshot-only"
  width="160">

### Colors and gradients

Defining colors on the command line is inspired by a subset of the widely known CSS syntax.

A single color may be defined in hexadecimal syntax as follows, where each two digits define the red, green and blue part of the color:

```
--background-color "#0099FF"
```

Some options also support gradients, i.e. the `--caption-color`, `--background-color` and `--screenshot-border-color`. For gradients, at least two colors have to be defined. The colors are rendered from top to bottom by default.

Linear gradients:

```
--background-color "linear-gradient(#FF0000, #FFA500, #FFFF00, #00FF00, #0000FF, #FF00FF)"
```

Radial gradients:

```
--background-color "radial-gradient(#FF0000, #0000FF)"
```

Specify gradient directions by using an optional direction argument before the list of color arguments. This is "to-bottom" by default but can be a horizontal direction (i.e. "to-right" or "to-left"), a vertical direction (i.e. "to-bottom" or "to-top") or a diagonal direction (i.e. "to-bottom-right", "to-bottom-left", "to-top-right" or "to-top-left"):

```
--background-color "linear-gradient(to-bottom-right, #FFFFFF, #000000)"
```

More specialized backgrounds are possible by defining a background image that is rendered behind the screenshot, for example with following options:

```
--background-image Examples/example-background.jpg
--background-image-scaling "aspect-fill"
--background-image-alignment "bottom"    
```

Examples of background gradients and images:

<img
  src="https://github.com/goeldner/swift-screenshot-scribbler/blob/main/Examples/example-output-gradient-linear-rainbow.png?raw=true"
  alt="Background: linear-gradient"
  title="Background: linear-gradient"
  width="160"> &nbsp;
<img
  src="https://github.com/goeldner/swift-screenshot-scribbler/blob/main/Examples/example-output-gradient-radial-red-blue.png?raw=true"
  alt="Background: radial-gradient"
  title="Background: radial-gradient"
  width="160"> &nbsp;
<img
  src="https://github.com/goeldner/swift-screenshot-scribbler/blob/main/Examples/example-output-background-image.png?raw=true"
  alt="Background: background-image"
  title="Background: background-image"
  width="160">

### Config file

It is possible to load all options from a JSON file instead of defining them on command line. Specify a path to a JSON file using the `--config` option. The settings from the file are applied first and can be overridden by settings from command line.

All settings have the same names as on command line, but written in camel case. Partial JSON files are supported, so it is possible to define only a small set of options inside the file. All missing options are supplied with default values.

Following example defines all options and their default values in JSON:

```
{
  "layout" : {
    "layoutType" : "caption-before-screenshot"
  },
  "screenshot" : {
    "screenshotBorderColor" : "#000000",
    "screenshotBorderSize" : 0,
    "screenshotCornerRadius" : 5,
    "screenshotShadowColor" : "#000000",
    "screenshotShadowSize" : 5,
    "screenshotSizeFactor" : 0.85
  },
  "background" : {
    "backgroundColor" : "#FFFFFF",
    "backgroundImageAlignment" : "middle center",
    "backgroundImageScaling" : "stretch-fill"
  },
  "caption" : {
    "captionAlignment" : "center",
    "captionColor" : "#000000",
    "captionFontName" : "SF Compact",
    "captionFontSize" : 32,
    "captionFontStyle" : "Bold",
    "captionSizeFactor" : 0.25
  }
}
```

## About

I started developing this tool as a side project, because I did not want to use fastlane for any reason, which provides something similar with its frameit plugin. I wanted to have a simple command line tool, which I just can call in my scripts (that already generate screenshots automatically) in order to beautify them for the App Store.

This project uses pure CoreGraphics and CoreText APIs for layouting (no AppKit or UIKit), so it should be quite portable.

There will be updates and new features from time to time and I try to keep working on it, as long as I use it myself.

## Coffee

If you like this project, you could buy me a coffee or become my GitHub Sponsor:

<a href="https://www.buymeacoffee.com/goeldner" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" height="35"></a> &nbsp; 
<a href="https://github.com/sponsors/goeldner" target="_blank"><img src="https://img.shields.io/static/v1?label=Sponsor&message=%E2%9D%A4&logo=GitHub&color=FF813F&style=flat-square" alt="GitHub Sponsor" height="35"></a>
