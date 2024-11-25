import UnicodeEmojiModels

extension UnicodeEmojiPrinter {
	@StringBuilder
	static func print(
		header: String,
		accessorName: String,
		input: [Emoji]
	) -> String {
		comment {
			header
		}

		"\n"

		"""
		import UnicodeEmojiModels
		
		extension [Emoji] {
			static let \(accessorName): Self = 
		"""

		array(
			input,
			indent: 2,
			indentClosingBrace: true,
			printer: { emoji($0) }
		)

		"\n}"
	}
}
