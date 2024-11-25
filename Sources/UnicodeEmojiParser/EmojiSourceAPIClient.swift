import Foundation

public struct EmojiSourceAPIClient: Sendable {
	public var fetchSource: @Sendable () async throws -> String

	public init(fetchSource: @escaping @Sendable () async throws -> String) {
		self.fetchSource = fetchSource
	}
}

extension EmojiSourceAPIClient {
	public static var `default`: EmojiSourceAPIClient {
		typealias Response = (data: Data, response: URLResponse)

		enum Error: Swift.Error {
			case unexpectedResponseEncoding
		}

		let urlSession: URLSession = .shared
		let url = URL(string: "https://unicode.org/Public/emoji/latest/emoji-test.txt")!

		return .init(
			fetchSource: {
				let response: Response = try await urlSession.data(from: url)

				guard let source = String(data: response.data, encoding: .utf8) else {
					throw Error.unexpectedResponseEncoding
				}

				return source
			}
		)
	}
}
