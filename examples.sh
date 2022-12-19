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
    --layout-text-ratio 0.25 \
    --background-color "#FFFFFF" \
    --text-color "#000000" \
    --font-name "SF Compact" \
    --font-style "Bold" \
    --font-size 32 \
    --image-size-reduction 0.85 \
    --image-corner-radius 5 \
    --image-shadow-color "#000000" \
    --image-shadow-size 5

# Layout: text-before-image
swift run scrscr \
    --caption "Example output with caption before image" \
    --input Examples/example-input.png \
    --output Examples/example-output-text-before-image.png \
    --layout-type "text-before-image" \
    --background-color "#C0FFEE"

# Layout: text-after-image
swift run scrscr \
    --caption "Example output with caption after image" \
    --input Examples/example-input.png \
    --output Examples/example-output-text-after-image.png \
    --layout-type "text-after-image" \
    --background-color "#C0FFEE"

# Layout: text-between-images
swift run scrscr \
    --caption "Example output with caption between both image parts" \
    --input Examples/example-input.png \
    --output Examples/example-output-text-between-images.png \
    --layout-type "text-between-images" \
    --background-color "#C0FFEE"

# Smaller text area and fully visible screenshot with dark background
swift run scrscr \
    --caption "Dark example with full screenshot" \
    --input Examples/example-input.png \
    --output Examples/example-output-full-screenshot.png \
    --layout-type "text-before-image" \
    --layout-text-ratio 0.15 \
    --background-color "#000000" \
    --text-color "#EEDD00" \
    --font-name "Futura" \
    --font-style "Bold" \
    --font-size 28 \
    --image-size-reduction 0.80 \
    --image-corner-radius 8 \
    --image-shadow-size 0
