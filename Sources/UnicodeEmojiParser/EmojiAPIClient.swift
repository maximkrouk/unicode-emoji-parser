import UnicodeEmojiModels
import OrderedCollections

public struct EmojiAPIClient: Sendable {
	public var fetchEmojis: @Sendable () async throws -> EmojiList

	public init(fetchEmojis: @escaping @Sendable () async throws -> EmojiList) {
		self.fetchEmojis = fetchEmojis
	}
}

extension EmojiAPIClient {
	public static var `default`: EmojiAPIClient {
		return .default(for: .default)
	}

	public static func `default`(for sourceAPIClient: EmojiSourceAPIClient) -> EmojiAPIClient {
		let parserContainer = UncheckedSendableEmojiSourceParserContainer(
			parser: UnicodeEmojiSourceParser()
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
	let parser: UnicodeEmojiSourceParser
}
