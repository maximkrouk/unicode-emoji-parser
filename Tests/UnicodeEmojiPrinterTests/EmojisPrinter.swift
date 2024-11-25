import Testing
import UnicodeEmojiModels
@testable import UnicodeEmojiPrinter
import OrderedCollections

@Suite("EmojisPrinter Tests")
struct EmojisPrinterTests {
	@Test func print() async throws {
		let header = "Generated"
		let accessorName = "generated"
		let input = [
			Emoji(
				value: Emoji.Value(
					unicodeScalars: [0x1F600],
					version: SemanticVersion(0, 1, 0),
					status: .fullyQualified,
					name: "grinning face",
					attributes: []
				)!,
				skinTones: [
					Emoji.Value(
						unicodeScalars: [0x1F9D8, 0x1F3FB, 0x200D, 0x2642],
						version: SemanticVersion(0, 5, 0),
						status: .minimallyQualified,
						name: "man in lotus position",
						attributes: [
							"light skin tone",
							"medium-light skin tone"
						]
					)!,
					Emoji.Value(
						unicodeScalars: [0x1F9D8, 0x1F3FB, 0x200D],
						version: SemanticVersion(0, 5, 0),
						status: .minimallyQualified,
						name: "man in lotus position",
						attributes: [
							"light skin tone",
							"medium-light skin tone"
						]
					)!
				]
			),
			Emoji(
				value: Emoji.Value(
					unicodeScalars: [0x1F3FB],
					version: SemanticVersion(0, 1, 0),
					status: .fullyQualified,
					name: "grinning face",
					attributes: []
				)!,
				skinTones: [
					Emoji.Value(
						unicodeScalars: [0x1F9D8, 0x200D, 0x2642],
						version: SemanticVersion(0, 5, 0),
						status: .minimallyQualified,
						name: "man in lotus position",
						attributes: [
							"light skin tone",
							"medium-light skin tone"
						]
					)!,
					Emoji.Value(
						unicodeScalars: [0x1F3FB, 0x200D],
						version: SemanticVersion(0, 5, 0),
						status: .minimallyQualified,
						name: "man in lotus position",
						attributes: [
							"light skin tone",
							"medium-light skin tone"
						]
					)!
				]
			)
		]

		let expected = """
		// Generated
		import UnicodeEmojiModels

		extension [Emoji] {
			static let generated: Self = [
				Emoji(
					value: Emoji.Value(
						unicodeScalars: [0x1F600],
						version: SemanticVersion(0, 1, 0),
						status: .fullyQualified,
						name: "grinning face",
						attributes: []
					)!,
					skinTones: [
						Emoji.Value(
							unicodeScalars: [0x1F9D8, 0x1F3FB, 0x200D, 0x2642],
							version: SemanticVersion(0, 5, 0),
							status: .minimallyQualified,
							name: "man in lotus position",
							attributes: [
								"light skin tone",
								"medium-light skin tone"
							]
						)!,
						Emoji.Value(
							unicodeScalars: [0x1F9D8, 0x1F3FB, 0x200D],
							version: SemanticVersion(0, 5, 0),
							status: .minimallyQualified,
							name: "man in lotus position",
							attributes: [
								"light skin tone",
								"medium-light skin tone"
							]
						)!
					]
				),
				Emoji(
					value: Emoji.Value(
						unicodeScalars: [0x1F3FB],
						version: SemanticVersion(0, 1, 0),
						status: .fullyQualified,
						name: "grinning face",
						attributes: []
					)!,
					skinTones: [
						Emoji.Value(
							unicodeScalars: [0x1F9D8, 0x200D, 0x2642],
							version: SemanticVersion(0, 5, 0),
							status: .minimallyQualified,
							name: "man in lotus position",
							attributes: [
								"light skin tone",
								"medium-light skin tone"
							]
						)!,
						Emoji.Value(
							unicodeScalars: [0x1F3FB, 0x200D],
							version: SemanticVersion(0, 5, 0),
							status: .minimallyQualified,
							name: "man in lotus position",
							attributes: [
								"light skin tone",
								"medium-light skin tone"
							]
						)!
					]
				)
			]
		}
		"""

		let actual = UnicodeEmojiPrinter.print(header: header, accessorName: accessorName, input: input)
		#expect(actual == expected)
	}
}