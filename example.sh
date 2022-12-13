#!/bin/bash

swift run scrscr \
    --caption "Example output with default options and long caption" \
    --input example-input.png \
    --output example-output-default.png \
    --layout-type "text-before-image" \
    --text-area-ratio 0.25 \
    --image-size-reduction 0.85 \
    --background-color "#FFFFFF" \
    --text-color "#000000" \
    --font-name "SF Compact" \
    --font-style "Bold" \
    --font-size 32 \
    --shadow-color "#000000" \
    --shadow-size 5 \
    --verbose

swift run scrscr \
    --caption "Dark example with full screenshot" \
    --input example-input.png \
    --output example-output-custom.png \
    --layout-type "text-before-image" \
    --text-area-ratio 0.15 \
    --image-size-reduction 0.80 \
    --background-color "#000000" \
    --text-color "#EEDD00" \
    --font-name "Futura" \
    --font-style "Bold" \
    --font-size 28 \
    --shadow-color "#000000" \
    --shadow-size 0 \
    --verbose
