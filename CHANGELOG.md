# CHANGELOG

## [Unreleased]

<!-- After release: *No unreleased changes yet.* -->

This release adds two missing pieces for gradients – changing the gradient direction and using gradients also for the caption.

### Added

- The caption color now also supports gradients. Use the same syntax as for the background and shadow color.
- Specify gradient directions by using an optional direction argument before the list of color arguments. This is "to-bottom" by default but can be a horizontal direction (i.e. "to-right" or "to-left"), a vertical direction (i.e. "to-bottom" or "to-top") or a diagonal direction (i.e. "to-bottom-right", "to-bottom-left", "to-top-right" or "to-top-left").

### Changed

- The CLI functionality has been refactored into a subcommand called `decorate` in order to support more subcommands in the future. This is the default command, so the CLI is compatible to previous versions. You can type `scrscr help decorate` in order to see the whole description. Internal option, config and action classes have also been refactored for reusability by other commands and actions in the future.
- References to `CGColor` inside the public API of the library have been removed. This affects the option, config and common enum types. A new `Color` type has been introduced additionally to the previously introduced `ColorType` enum.

## [1.1.0] (2023-01-10)

This release adds more features like color gradients, colored borders, background images, a new screenshot-only layout and JPEG support.

### Added

- Use linear and radial color gradients, instead of solid colors only. Can be used for "background-color" and "screenshot-border-color". See README for more details about color and gradient definition syntax.
- Use an image file as background by using the new options "background-image", "background-image-scaling" and "background-image-alignment".
- Draw a colored border around the screenshot by using the new options "screenshot-border-size" and "screenshot-border-color".
- New layout type "screenshot-only" that enables to render a screenshot without a caption. The screenshot is centered inside the original image at the desired size factor and may be decorated with a background, border and shadow as usual.
- Support screenshots in JPEG format, additionally to PNG. Note that the output is still always in PNG format.

### Changed

- The caption parameter is now optional, in order to support the "screenshot-only" layout. This enables to use the other layouts without a caption, too. Note that the caption area is still reserved unless the "caption-size-factor" is reduced accordingly.
- Replaced install.sh file with a Makefile, now supporting install, uninstall, build and clean commands.

---

## [1.0.0] (2022-12-22)

This is the initial release of the `ScreenshotScribbler` library and `scrscr`
command line tool.

It is able to decorate a screenshot with a caption and a background, based on
several freely configurable layout and style options.

### Features

- Takes a screenshot as input in PNG format
- Takes a caption as input that is rendered next to the screenshot
- Generates a PNG as output with same dimensions as the original screenshot
- Layout types
  - Caption before screenshot
  - Caption after screenshot
  - Caption between two half screenshot parts
- Background style options
  - Color
- Caption style options
  - Color
  - Font name, style and size
  - Horizontal alignment
  - Relative size
- Screenshot style options
  - Corner radius
  - Shadow color and size
  - Relative size

Please have a look at the README and the examples for a more detailed overview
about the possible options.

---

<!-- Link references for releases -->

[Unreleased]: https://github.com/goeldner/swift-screenshot-scribbler/compare/1.1.0...HEAD
[1.1.0]: https://github.com/goeldner/swift-screenshot-scribbler/compare/1.0.0...1.1.0
[1.0.0]: https://github.com/goeldner/swift-screenshot-scribbler/releases/tag/1.0.0
