# CHANGELOG

## [Unreleased]

<!-- After release: *No changes yet.* -->

*No changes yet.*

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
