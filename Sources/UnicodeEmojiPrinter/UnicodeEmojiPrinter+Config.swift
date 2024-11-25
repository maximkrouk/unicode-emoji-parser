import UnicodeEmojiModels
import OrderedCollections

extension UnicodeEmojiPrinter {
	public struct PrintConfig {
		public let header: String
		public let accessorName: String
		public let style: Style

		public init(
			header: String = "Generated, do not edit!",
			accessorName: String = "generated",
			style: Style
		) {
			self.header = header
			self.accessorName = accessorName
			self.style = style
		}
	}

	public enum Style {
		case values([Emoji.Value])
		case emojis([Emoji])
		case grouped(EmojiList)

		public static func uniqueValues(_ values: OrderedSet<Emoji.Value>) -> Self {
			return .values(Array(values))
		}

		public static func uniqueEmojis(_ values: OrderedSet<Emoji>) -> Self {
			return .emojis(Array(values))
		}

		public static func extractValues(from list: EmojiList) -> Self {
			let emojis = list.flatMap(\.value).flatMap(\.value)
			let values = emojis.flatMap { [$0.value] + $0.skinTones }
			return .values(values)
		}

		public static func extractEmojis(from list: EmojiList) -> Self {
			let emojis = list.flatMap(\.value).flatMap(\.value)
			return .emojis(Array(emojis))
		}
	}
}
