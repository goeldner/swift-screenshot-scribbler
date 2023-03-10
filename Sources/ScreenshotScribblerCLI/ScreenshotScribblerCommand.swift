//
// Copyright © 2022 Christoph Göldner. All rights reserved.
//

import Foundation
import ArgumentParser
import ScreenshotScribbler

///
/// Command line interface of the `ScreenshotScribbler` library.
///
@main
struct ScreenshotScribblerCommand: ParsableCommand {

    static let configuration = CommandConfiguration(
        commandName: "scrscr",
        abstract: "A command line tool that decorates screenshots with nice backgrounds and captions.",
        version: "1.1.0",
        subcommands: [DecorateCommand.self],
        defaultSubcommand: DecorateCommand.self
    )

}
