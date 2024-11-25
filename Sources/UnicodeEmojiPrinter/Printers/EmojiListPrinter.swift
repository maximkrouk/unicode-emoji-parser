import UnicodeEmojiModels

extension UnicodeEmojiPrinter {
	@StringBuilder
	static func print(
		header: String,
		accessorName: String,
		input: EmojiList
	) -> String {
		comment {
			header
		}

		"\n"

		"""
		import UnicodeEmojiModels
		
		extension EmojiList {
			static let generated: Self = 
		"""

		array(
			Array(input.elements),
			indentClosingBrace: true,
			printer: { emojiListElement($0) }
		)

		"\n}"
	}

	@StringBuilder
	static func emojiListDecl(_ input: EmojiList) -> String {
		"\tstatic let emojiGroups: Self = "
		array(
			Array(input.elements),
			indentClosingBrace: true,
			printer: { emojiListElement($0) }
		)
	}

	@StringBuilder
	static func emojiListElement(_ input: EmojiList.Element) -> String {
		"\t\(escapedString(input.key)): "
		array(
			Array(input.value),
			indentClosingBrace: true,
			printer: { emojiGroupElement($0) }
		)
	}

	@StringBuilder
	static func emojiGroupElement(_ input: EmojiGroup.Element) -> String {
		indent {
			"\(escapedString(input.key)): "
			array(input.value, printer: { emoji($0) })
		}
	}
}
