import UnicodeEmojiModels

extension UnicodeEmojiPrinter {
	@StringBuilder
	static func emoji(_ input: Emoji) -> String {
		initializer("Emoji") {
			"""
			value: \(emojiValue(input.value)),
			skinTones: \(array(input.skinTones, printer: { emojiValue($0) }))
			"""
		}
	}

	@StringBuilder
	static func emojiValue(_ input: Emoji.Value) -> String {
		initializer("Emoji.Value", forceUnwrap: true) {
			"""
			unicodeScalars: \(unicodeScalars(input.unicodeScalars)),
			version: \(emojiVersion(input.version)),
			status: \(emojiStatus(input.status)),
			name: \(escapedString(input.name)),
			attributes: \(array(input.attributes, printer: escapedString))
			"""
		}
	}

	@StringBuilder
	static func emojiVersion(_ input: SemanticVersion) -> String {
		"SemanticVersion(\(input.major), \(input.minor), \(input.patch))"
	}

	@StringBuilder
	static func emojiStatus(_ input: Emoji.Value.Status) -> String {
		switch input {
		case .component:
			".component"
		case .fullyQualified:
			".fullyQualified"
		case .minimallyQualified:
			".minimallyQualified"
		case .unqualified:
			".unqualified"
		}
	}

	@StringBuilder
	static func unicodeScalars(_ input: [Unicode.Scalar]) -> String {
		"["
		input.map { String(format: "0x%X", $0.value) }.joined(separator: ", ")
		"]"
	}
}
