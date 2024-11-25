extension Emoji {
	public struct Value: Hashable, Sendable {
		public let unicodeScalars: [Unicode.Scalar]
		public let version: SemanticVersion
		public let status: Status
		public let name: String
		public let attributes: [String]

		public init(
			unicodeScalars: [Unicode.Scalar],
			version: SemanticVersion,
			status: Status,
			name: String,
			attributes: [String]
		) {
			self.unicodeScalars = unicodeScalars
			self.version = version
			self.status = status
			self.name = name
			self.attributes = attributes
		}

		public init?(
			unicodeScalars: [UInt32],
			version: SemanticVersion,
			status: Status,
			name: String,
			attributes: [String]
		) {
			let scalars = unicodeScalars.compactMap(Unicode.Scalar.init)
			guard scalars.count == unicodeScalars.count else { return nil }
			self.init(
				unicodeScalars: scalars,
				version: version,
				status: status,
				name: name,
				attributes: attributes
			)
		}

		public func emojiString() -> String {
			String(String.UnicodeScalarView(unicodeScalars))
		}

		public var attributedName: String {
			if attributes.isEmpty {
				return name
			} else {
				return name + ": " + attributes.joined(separator: ", ")
			}
		}
	}
}

extension Emoji.Value {
	public enum Status: String, Hashable, Sendable, CaseIterable {
		case component = "component"
		case fullyQualified = "fully-qualified"
		case minimallyQualified = "minimally-qualified"
		case unqualified = "unqualified"
	}
}
