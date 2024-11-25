import Testing
import UnicodeEmojiModels
@testable import UnicodeEmojiPrinter
import OrderedCollections

@Suite("UnicodeEmojiPrinter+Model Tests")
struct UnicodeEmojiPrinterModelTests {
	@Test func unicodeScalar() async throws {
		let input: [Unicode.Scalar] = ["\u{1F9D8}", "\u{1F3FB}", "\u{200D}", "\u{2642}"]
		let expected: [String] = ["\\u{1F9D8}", "\\u{1F3FB}", "\\u{200D}", "\\u{2642}"]


		zip(input, expected).forEach { input, expected in
			let actual = UnicodeEmojiPrinter.unicodeScalar(input)
			#expect(actual == expected)
		}
	}

	@Test func unicodeScalars() async throws {
		let input: [Unicode.Scalar] = ["\u{1F9D8}", "\u{1F3FB}", "\u{200D}", "\u{2642}"]
		let expected = "[\"\\u{1F9D8}\", \"\\u{1F3FB}\", \"\\u{200D}\", \"\\u{2642}\"]"

		let actual = UnicodeEmojiPrinter.unicodeScalars(input)

		#expect(actual == expected)
	}

	@Test func emojiStatus() async throws {
		let inputs: [Emoji.Value.Status] = [
			.component,
			.fullyQualified,
			.minimallyQualified,
			.unqualified
		]

		let expecteds: [String ] = [
			".component",
			".fullyQualified",
			".minimallyQualified",
			".unqualified"
		]

		zip(inputs, expecteds).forEach { input, expected in
			let actual = UnicodeEmojiPrinter.emojiStatus(input)
			#expect(actual == expected)
		}
	}

	@Test func emojiVersion() async throws {
		let input: (UInt, UInt, UInt) = (1, 0, 0)
		let expected = "SemanticVersion(1, 0, 0)"
		let actual = UnicodeEmojiPrinter.emojiVersion(.init(input.0, input.1, input.2))
		#expect(actual == expected)
	}

	@Test func emojiValue() async throws {
		let input = Emoji.Value(
			unicodeScalars: ["\u{1F9D8}", "\u{1F3FB}", "\u{200D}", "\u{2642}"],
			version: SemanticVersion(0, 5, 0),
			status: .minimallyQualified,
			name: "man in lotus position",
			attributes: [
				"light skin tone",
				"medium-light skin tone"
			]
		)

		let expected = """
		Emoji.Value(
			unicodeScalars: ["\\u{1F9D8}", "\\u{1F3FB}", "\\u{200D}", "\\u{2642}"],
			version: SemanticVersion(0, 5, 0),
			status: .minimallyQualified,
			name: "man in lotus position",
			attributes: [
				"light skin tone",
				"medium-light skin tone"
			]
		)
		"""

		let actual = UnicodeEmojiPrinter.emojiValue(input)
		#expect(actual == expected)
	}

	@Test func emoji() async throws {
		let input = Emoji(
			value: Emoji.Value(
				unicodeScalars: ["\u{1F600}"],
				version: SemanticVersion(0, 1, 0),
				status: .fullyQualified,
				name: "grinning face",
				attributes: []
			),
			skinTones: [
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
		)

		let expected = """
		Emoji(
			value: Emoji.Value(
				unicodeScalars: ["\\u{1F600}"],
				version: SemanticVersion(0, 1, 0),
				status: .fullyQualified,
				name: "grinning face",
				attributes: []
			),
			skinTones: [
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
		)
		"""

		let actual = UnicodeEmojiPrinter.emoji(input)
		#expect(actual == expected)
	 }
}
