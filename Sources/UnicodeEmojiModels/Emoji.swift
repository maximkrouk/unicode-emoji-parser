import Foundation

public struct Emoji: Hashable, Sendable {
	public let value: Value
	public let skinTones: [Value]

	public init(
		value: Value,
		skinTones: [Value]
	) {
		self.value = value
		self.skinTones = skinTones
	}

	public init?(
		value: Value?,
		skinTones: [Value?]
	) {
		guard let value else { return nil }
		self.init(value: value, skinTones: skinTones.compactMap { $0 })
	}
}

extension Emoji {
	public var allSkinTones: [Value] {
		[value] + skinTones
	}
}
