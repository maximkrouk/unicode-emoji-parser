import Testing
import UnicodeEmojiModels
@testable import UnicodeEmojiPrinter
import OrderedCollections

@Suite("EmojiValuesPrinter Tests")
struct EmojiValuesPrinterTests {
	@Test func print() async throws {
		let header = "Generated"
		let accessorName = "generated"
		let input = [
			Emoji.Value(
				unicodeScalars: ["\u{1F9D8}", "\u{1F3FB}", "\u{200D}", "\u{2642}"],
				version: SemanticVersion(0, 5, 0),
				status: .minimallyQualified,
				name: "man in lotus position",
				attributes: [
					"light skin tone",
					"medium-light skin tone"
				]
			),
			Emoji.Value(
				unicodeScalars: ["\u{1F9D8}", "\u{1F3FB}", "\u{200D}"],
				version: SemanticVersion(0, 5, 0),
				status: .minimallyQualified,
				name: "man in lotus position",
				attributes: [
					"light skin tone",
					"medium-light skin tone"
				]
			)
		]

		let expected = """
		// Generated
		import UnicodeEmojiModels

		extension [Emoji.Value] {
			static let generated: Self = [
				Emoji.Value(
					unicodeScalars: ["\\u{1F9D8}", "\\u{1F3FB}", "\\u{200D}", "\\u{2642}"],
					version: SemanticVersion(0, 5, 0),
					status: .minimallyQualified,
					name: "man in lotus position",
					attributes: [
						"light skin tone",
						"medium-light skin tone"
					]
				),
				Emoji.Value(
					unicodeScalars: ["\\u{1F9D8}", "\\u{1F3FB}", "\\u{200D}"],
					version: SemanticVersion(0, 5, 0),
					status: .minimallyQualified,
					name: "man in lotus position",
					attributes: [
						"light skin tone",
						"medium-light skin tone"
					]
				)
			]
		}
		"""

		let actual = UnicodeEmojiPrinter.print(header: header, accessorName: accessorName, input: input)
		#expect(actual == expected)
	}
}
