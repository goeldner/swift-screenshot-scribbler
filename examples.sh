#!/bin/bash

# Default 1: all optional options omitted; JPEG input
swift run scrscr \
    --caption "Example with small JPEG image as input" \
    --screenshot Examples/example-input.jpg \
    --output Examples/example-output-default-1.png

# Default 2: all optional options omitted; PNG input
swift run scrscr \
    --caption "Example output with default options and long caption" \
    --screenshot Examples/example-input.png \
    --output Examples/example-output-default-2.png

# Default 3: all options explicitly defined; PNG input
swift run scrscr \
    --caption "Example output with default options and long caption" \
    --screenshot Examples/example-input.png \
    --output Examples/example-output-default-3.png \
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
    --caption-rotation "0" \
    --screenshot-size-factor 0.85 \
    --screenshot-corner-radius 5 \
    --screenshot-shadow-size 5 \
    --screenshot-shadow-color "#000000" \
    --screenshot-border-size 0 \
    --screenshot-border-color "#000000" \
    --screenshot-rotation "0"

# Layout: caption-before-screenshot
swift run scrscr \
    --caption "Example with caption before screenshot" \
    --screenshot Examples/example-input.png \
    --output Examples/example-output-layout-caption-before-screenshot.png \
    --layout "caption-before-screenshot" \
    --background-color "#C0FFEE"

# Layout: caption-after-screenshot
swift run scrscr \
    --caption "Example with caption after screenshot" \
    --screenshot Examples/example-input.png \
    --output Examples/example-output-layout-caption-after-screenshot.png \
    --layout "caption-after-screenshot" \
    --background-color "#C0FFEE"

# Layout: caption-between-screenshots
swift run scrscr \
    --caption "Example with caption between both screenshot parts" \
    --screenshot Examples/example-input.png \
    --output Examples/example-output-layout-caption-between-screenshots.png \
    --layout "caption-between-screenshots" \
    --background-color "#C0FFEE" \
    --caption-alignment "left"

# Layout: screenshot-only
swift run scrscr \
    --screenshot Examples/example-input.png \
    --output Examples/example-output-layout-screenshot-only.png \
    --layout "screenshot-only" \
    --background-color "#C0FFEE"

# Background: Custom background color and colored border, custom font and colored text
swift run scrscr \
    --screenshot Examples/example-input.png \
    --output Examples/example-output-background-color-black.png \
    --layout "caption-before-screenshot" \
    --background-color "#000000" \
    --caption "Black background and custom font" \
    --caption-color "#EEDD00" \
    --caption-font-name "Futura" \
    --caption-font-style "Bold" \
    --caption-font-size 28 \
    --caption-size-factor 0.15 \
    --screenshot-size-factor 0.80 \
    --screenshot-corner-radius 8 \
    --screenshot-shadow-size 0 \
    --screenshot-border-size 5 \
    --screenshot-border-color "#EEDD00"

# Background: Custom background image, radial gradient border
swift run scrscr \
    --screenshot Examples/example-input.png \
    --output Examples/example-output-background-image.png \
    --layout "caption-before-screenshot" \
    --background-color "#000000" \
    --background-image Examples/example-background.jpg \
    --background-image-scaling "aspect-fill" \
    --background-image-alignment "bottom" \
    --caption "Background image" \
    --caption-color "#CC0040" \
    --caption-size-factor 0.15 \
    --screenshot-size-factor 0.75 \
    --screenshot-shadow-size 15 \
    --screenshot-border-size 5 \
    --screenshot-border-color "radial-gradient(#CC0040, #0000FF)"

# Gradient: Background with linear gradient in rainbow colors, screenshot surrounded by "white cloud" border
swift run scrscr \
    --caption "Linear gradient" \
    --screenshot Examples/example-input.png \
    --output Examples/example-output-gradient-linear-rainbow.png \
    --layout "caption-before-screenshot" \
    --background-color "linear-gradient(#FF0000,#FFA500,#FFFF00,#00FF00,#0000FF,#FF00FF)" \
    --caption-size-factor 0.15 \
    --caption-color "#FFFFFF" \
    --screenshot-size-factor 0.75 \
    --screenshot-shadow-size 15 \
    --screenshot-shadow-color "#FFFFFF" \
    --screenshot-border-size 5 \
    --screenshot-border-color "#FFFFFF"

# Gradient: Background with two color radial gradient, border with another gradient
swift run scrscr \
    --caption "Radial gradient" \
    --screenshot Examples/example-input.png \
    --output Examples/example-output-gradient-radial-red-blue.png \
    --layout "caption-before-screenshot" \
    --background-color "radial-gradient(#FF0000, #0000FF)" \
    --caption-size-factor 0.15 \
    --caption-color "#FFFF00" \
    --screenshot-size-factor 0.75 \
    --screenshot-shadow-size 0 \
    --screenshot-border-size 5 \
    --screenshot-border-color "radial-gradient(#FFFF00, #FFA500)" \

# Gradient: Background with linear gradient in diagonal direction and caption with horizontal gradient
swift run scrscr \
    --caption "Diagonal gradient background and gradient caption" \
    --screenshot Examples/example-input.png \
    --output Examples/example-output-gradient-diagonal-black-white.png \
    --layout "caption-before-screenshot" \
    --background-color "linear-gradient(to-bottom-right, #000000, #000000, #AAAAAA, #0000FF)" \
    --caption-size-factor 0.25 \
    --caption-color "linear-gradient(to-right, #FF0000, #0000FF)" \
    --screenshot-size-factor 0.70 \
    --screenshot-corner-radius 0 \
    --screenshot-shadow-size 20 \
    --screenshot-border-size 0

# Rotation: Screenshot rotated to the left, caption to the right, like a zig-zag
swift run scrscr \
    --caption "Rotated caption and screenshots" \
    --screenshot Examples/example-input.png \
    --output Examples/example-output-rotation.png \
    --layout "caption-between-screenshots" \
    --background-color "#000000" \
    --caption-size-factor 0.20 \
    --caption-color "linear-gradient(to-right, #FF0000, #0000FF)" \
    --caption-rotation "-5deg" \
    --screenshot-size-factor 0.75 \
    --screenshot-shadow-size 0 \
    --screenshot-border-size 5 \
    --screenshot-border-color "radial-gradient(#FF0000, #0000FF)" \
    --screenshot-rotation "5deg"

# Load all options from JSON file
swift run scrscr \
    --caption "Example with options from JSON file" \
    --screenshot Examples/example-input.png \
    --config Examples/example-config-rainbow.json \
    --output Examples/example-output-config-file.png
