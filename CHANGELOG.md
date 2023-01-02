# CHANGELOG

## [Unreleased]

<!-- After release: *No changes yet.* -->

### Added

- Draw a colored border around the screenshot by using the new options "screenshot-border-size" and "screenshot-border-color".
- New layout type "screenshot-only" that enables to render a screenshot without a caption. The screenshot is centered inside the original image at the desired size factor and may be decorated with a background, border and shadow as usual.
- Support screenshots in JPEG format, additionally to PNG. Note that the output is still always in PNG format.

### Changed

- The caption parameter is now optional, in order to support the "screenshot-only" layout. This enables to use the other layouts without a caption, too. Note that the caption area is still reserved unless the "caption-size-factor" is reduced accordingly.

---

## [1.0.0] - 2022-12-22

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

[Unreleased]: https://github.com/goeldner/swift-screenshot-scribbler/compare/1.0.0...HEAD
[1.1.0]: https://github.com/goeldner/swift-screenshot-scribbler/compare/1.0.0...1.1.0
[1.0.0]: https://github.com/goeldner/swift-screenshot-scribbler/releases/tag/1.0.0
