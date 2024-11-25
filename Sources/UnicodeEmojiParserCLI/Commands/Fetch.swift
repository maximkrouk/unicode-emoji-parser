import ArgumentParser
import UnicodeEmojiParser
import Foundation

extension App {
	public struct Fetch: AsyncParsableCommand {
		public static var _commandName: String { "fetch" }

		public init() {}

		public init(
			url: String,
			output: String,
			allowsOverwrites: Bool = false
		) {
			self.url = url
			self.output = output
			self.allowsOverwrites = allowsOverwrites
		}

		@Argument(help: "url to fetch file from, defaults to `https://unicode.org/Public/emoji/latest/emoji-test.txt`")
		public var url: String = "https://unicode.org/Public/emoji/latest/emoji-test.txt"

		@Option(help: "Path to output file")
		public var output: String

		@Flag(help: "Pass true to silence `file exists` error")
		var allowsOverwrites: Bool = false

		enum Error: Swift.Error {
			case couldNotParseURL
			case couldNotCreateFile
			case fileExists
		}

		public func run() async throws {
			guard let url = URL(string: url) else { throw Error.couldNotParseURL }
			let data = try Data(contentsOf: url)

			let outputURL = URL(fileURLWithPath: output)
			if !FileManager.default.fileExists(atPath: output) {
				let directoryURL = outputURL.deletingLastPathComponent()
				if FileManager.default.fileExists(atPath: directoryURL.path()) {
					try FileManager.default.createDirectory(
						at: directoryURL,
						withIntermediateDirectories: true
					)
				}

				guard FileManager.default.createFile(atPath: output, contents: data)
				else { throw Error.couldNotCreateFile }
			} else if allowsOverwrites {
				try data.write(to: outputURL)
			} else {
				throw Error.fileExists
			}
		}
	}

}
