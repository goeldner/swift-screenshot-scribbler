#!/bin/bash

# Default 1: all optional options ommitted
swift run scrscr \
    --caption "Example output with default options and long caption" \
    --input Examples/example-input.png \
    --output Examples/example-output-default-1.png

# Default 2: all options explicitly defined
swift run scrscr \
    --caption "Example output with default options and long caption" \
    --input Examples/example-input.png \
    --output Examples/example-output-default-2.png \
    --layout-type "text-before-image" \
    --text-area-ratio 0.25 \
    --image-size-reduction 0.85 \
    --background-color "#FFFFFF" \
    --text-color "#000000" \
    --font-name "SF Compact" \
    --font-style "Bold" \
    --font-size 32 \
    --shadow-color "#000000" \
    --shadow-size 5

# Smaller text area and fully visible screenshot with dark background
swift run scrscr \
    --caption "Dark example with full screenshot" \
    --input Examples/example-input.png \
    --output Examples/example-output-full-screenshot.png \
    --layout-type "text-before-image" \
    --text-area-ratio 0.15 \
    --image-size-reduction 0.80 \
    --background-color "#000000" \
    --text-color "#EEDD00" \
    --font-name "Futura" \
    --font-style "Bold" \
    --font-size 28 \
    --shadow-size 0
