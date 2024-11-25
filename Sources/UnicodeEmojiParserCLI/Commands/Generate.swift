import ArgumentParser
import UnicodeEmojiParser
import Foundation
import UnicodeEmojiPrinter

extension App {
	public struct Generate: AsyncParsableCommand {
		public static var _commandName: String { "generate" }

		public enum Style: String, ExpressibleByArgument {
			case values
			case emojis
			case grouped
		}

		public init() {}

		public init(
			input: String? = nil,
			output: String,
			style: Style = .grouped,
			indentor: String = "\t",
			tabSize: Int = 1
		) {
			self.input = input
			self.output = output
			self.style = style
			self.indentor = indentor
			self.tabSize = tabSize
		}

		@Argument(help: "Path to local input file for parsing")
		public var input: String? = nil

		@Option(help: "Path to output file")
		public var output: String

		@Argument(help: "Style")
		public var style: Style = .grouped

		@Option(help: "Indentation character")
		public var indentor: String = "\t"

		@Option(help: "Tab size")
		public var tabSize: Int = 1

		enum Error: Swift.Error {
			case unexpectedInputEncoding
			case couldNotCreateFile
			case couldNotEncodeOutput
		}

		public func run() async throws {
			let emojiList = try await fetchAndParse()

			var output = switch style {
			case .values:
				UnicodeEmojiPrinter.print(.init(style: .extractValues(from: emojiList)))
			case .emojis:
				UnicodeEmojiPrinter.print(.init(style: .extractEmojis(from: emojiList)))
			case .grouped:
				UnicodeEmojiPrinter.print(.init(style: .grouped(emojiList)))
			}

			if indentor != "\t" || tabSize != 1 {
				output = reindentSingleTab(output, indentor: indentor, tabSize: tabSize)
		 }

			guard let data = output.data(using: .utf8) else { throw Error.couldNotEncodeOutput }

			let outputURL = URL(fileURLWithPath: self.output)
			if !FileManager.default.fileExists(atPath: outputURL.path()) {

				let directoryURL = outputURL.deletingLastPathComponent()
				if !FileManager.default.fileExists(atPath: directoryURL.path()) {
					try FileManager.default.createDirectory(
						at: directoryURL,
						withIntermediateDirectories: true
					)
				}

				guard FileManager.default.createFile(atPath: outputURL.path(), contents: data)
				else { throw Error.couldNotCreateFile }
			} else {
				try data.write(to: outputURL)
			}
		}

		func fetchAndParse() async throws -> EmojiList {
			if let input {
				let data = try Data(contentsOf: URL(fileURLWithPath: input))
				guard let rawInput = String(data: data, encoding: .utf8) else {
					throw Error.unexpectedInputEncoding
				}

				return try UnicodeEmojiSourceParser().parse(rawInput)
			} else {
				return try await EmojiAPIClient.default.fetchEmojis()
			}
		}
	}
}

private func reindentSingleTab(_ source: String, indentor: String, tabSize: Int) -> String {
	let _indentor = String(repeating: indentor, count: tabSize)
	return source.replacingOccurrences(of: "\t", with: _indentor)
}
