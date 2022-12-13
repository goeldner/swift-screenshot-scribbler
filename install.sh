#!/bin/bash

swift build --configuration release
cp -f .build/release/scrscr /usr/local/bin/scrscr
