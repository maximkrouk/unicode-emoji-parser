import ArgumentParser
import Foundation

// MARK: - Command

public struct App: ParsableCommand {
	public static let _commandName: String = "unicode-emoji-parser"
	public static let _version = "0.0.1"

	public static let configuration = CommandConfiguration(
		subcommands: [Fetch.self, Generate.self]
	)

	@Flag(help: "Display version of the app")
	var version = false

	public init() {}

	public func run() throws {
		if version {
			print(Self._version)
		} else {
			throw CleanExit.helpRequest(self)
		}
	}
}
