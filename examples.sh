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
    --screenshot-border-color "#000000"

# Layout: caption-before-screenshot
swift run scrscr \
    --caption "Example with caption before screenshot" \
    --screenshot Examples/example-input.png \
    --output Examples/example-output-caption-before-screenshot.png \
    --layout "caption-before-screenshot" \
    --background-color "#C0FFEE"

# Layout: caption-after-screenshot
swift run scrscr \
    --caption "Example with caption after screenshot" \
    --screenshot Examples/example-input.png \
    --output Examples/example-output-caption-after-screenshot.png \
    --layout "caption-after-screenshot" \
    --background-color "#C0FFEE"

# Layout: caption-between-screenshots
swift run scrscr \
    --caption "Example with caption between both screenshot parts" \
    --screenshot Examples/example-input.png \
    --output Examples/example-output-caption-between-screenshots.png \
    --layout "caption-between-screenshots" \
    --background-color "#C0FFEE" \
    --caption-alignment "left"

# Layout: screenshot-only
swift run scrscr \
    --screenshot Examples/example-input.png \
    --output Examples/example-output-screenshot-only.png \
    --layout "screenshot-only" \
    --background-color "#C0FFEE"

# Smaller caption area and fully visible screenshot with dark background
swift run scrscr \
    --caption "Dark example with full screenshot" \
    --screenshot Examples/example-input.png \
    --output Examples/example-output-full-screenshot.png \
    --layout "caption-before-screenshot" \
    --background-color "#000000" \
    --caption-size-factor 0.15 \
    --caption-color "#EEDD00" \
    --caption-font-name "Futura" \
    --caption-font-style "Bold" \
    --caption-font-size 28 \
    --screenshot-size-factor 0.80 \
    --screenshot-corner-radius 8 \
    --screenshot-shadow-size 0
