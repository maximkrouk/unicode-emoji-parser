import UnicodeEmojiModels
import OrderedCollections
import Parsing

public struct EmojiAPIClient: Sendable {
	public var fetchEmojis: @Sendable () async throws -> EmojiList

	public init(fetchEmojis: @escaping @Sendable () async throws -> EmojiList) {
		self.fetchEmojis = fetchEmojis
	}
}

extension EmojiAPIClient {
	public static var `default`: EmojiAPIClient {
		return .default()
	}

	public static func `default`(
		for sourceAPIClient: EmojiSourceAPIClient = .default,
		parser: any Parser<EmojiList, Substring> = UnicodeEmojiSourceParser()
	) -> EmojiAPIClient {
		let parserContainer = UncheckedSendableEmojiSourceParserContainer(
			parser: parser
		)

		return .init(
			fetchEmojis: {
				let source = try await sourceAPIClient.fetchSource()
				return try parserContainer.parser.parse(source)
			}
		)
	}
}

private struct UncheckedSendableEmojiSourceParserContainer: @unchecked Sendable {
	let parser: any Parser<EmojiList, Substring>
}
