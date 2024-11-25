import UnicodeEmojiModels

extension UnicodeEmojiPrinter {
	@StringBuilder
	static func print(
		header: String,
		accessorName: String,
		input: [Emoji.Value]
	) -> String {
		comment {
			header
		}

		"\n"

		"""
		import UnicodeEmojiModels
		
		extension [Emoji.Value] {
			static let \(accessorName): Self = 
		"""

		array(
			input,
			indent: 2,
			indentClosingBrace: true,
			printer: { emojiValue($0) }
		)

		"\n}"
	}
}
