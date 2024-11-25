import OrderedCollections

public enum UnicodeEmojiPrinter {
	public static func print(_ config: PrintConfig) -> String {
		switch config.style {
		case let .values(values):
			print(header: config.header, accessorName: config.accessorName, input: values)
		case let .emojis(emojis):
			print(header: config.header, accessorName: config.accessorName, input: emojis)
		case let .grouped(emojiGroups):
			print(header: config.header, accessorName: config.accessorName, input: emojiGroups)
		}
	}
}
