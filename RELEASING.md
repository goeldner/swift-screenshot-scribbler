# Checklist for releasing this package

- Increase version number in ScreenshotScribblerCommand.swift
- Create release section in CHANGELOG.md
  - define release version and date
  - move content of Unreleased section into release section
  - add short summary
  - update version links at end of file
- Create GitHub release
  - use release version as tag and name
  - copy contents of release section from CHANGELOG.md
- Increase version number in Homebrew formula
  - see repo goeldner/homebrew-formulae/Formula/scrscr.rb
- Publish release announcement
  - Mastodon
  - Twitter
