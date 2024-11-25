import Parsing
import Foundation
import UnicodeEmojiModels
import OrderedCollections

extension Parsers {
	public struct UnicodeEmojiSource: Parser {
		public typealias Input = Substring
		public typealias Output = Groups
		public typealias Groups = OrderedDictionary<String, Subgroups>
		public typealias Subgroups = OrderedDictionary<String, OrderedSet<Emoji>>

		public init() {}

		public var body: some Parser<Input, Output> {
			Self.buildParser()
		}
	}
}

extension Parsers.UnicodeEmojiSource {
	static func unicodeScalarsParser() -> some Parser<Input, [Unicode.Scalar]> {
		Many(1...) {
			Prefix { $0 != " " }
				.pipe { UInt32.parser(radix: 16) }
				.compactMap(Unicode.Scalar.init)
		} separator: {
			Whitespace()
		}
	}

	static func statusParser() -> some Parser<Input, Emoji.Value.Status> {
		Prefix { $0 != " " }
			.map(String.init)
			.compactMap(Emoji.Value.Status.init(rawValue:))
	}

	static func versionParser() -> some Parser<Input, SemanticVersion> {
		Many(1...3) {
			UInt.parser()
		} separator: {
			"."
		}.compactMap { components in
			switch components.count {
			case 1:
				return SemanticVersion(
					major: components[0]
				)
			case 2:
				return SemanticVersion(
					major: components[0],
					minor: components[1]
				)
			case 3:
				return SemanticVersion(
					major: components[0],
					minor: components[1],
					patch: components[2]
				)
			default:
				return nil
			}
		}
	}

	typealias AttributedName = (name: String, attributes: [String])
	static func nameAndAdditionalKeysParser() -> some Parser<Input, AttributedName> {
		Parse {
			OneOf {
				Parse {
					Prefix { $0 != ":" && $0 != "\n" }.map(String.init)
					":"
					Whitespace()
					Many(1...) {
						Prefix { $0 != "\n" && $0 != "," }.map(String.init)
					} separator: {
						", "
					}
				}
				Prefix { $0 != "\n" }.map(String.init).map { ($0, []) }
			}
		}
		.map { AttributedName($0, $1) }
	}

	static func emojiValueParser() -> some Parser<Input, Emoji.Value> {
		Parse {
			unicodeScalarsParser()
			Skip {
				Whitespace()
				";"
				Whitespace()
			}
			statusParser()
			Skip {
				PrefixThrough("E")
			}
			Prefix { $0 != " " }.pipe {
				versionParser()
			}
			Whitespace()
			nameAndAdditionalKeysParser()
		}.map { (
			unicodeScalars: [Unicode.Scalar],
			status: Emoji.Value.Status,
			version: SemanticVersion,
			attributedName: AttributedName
		) in
			Emoji.Value.init(
				unicodeScalars: unicodeScalars,
				version: version,
				status: status,
				name: attributedName.name,
				attributes: attributedName.attributes
			)
		}
	}

	typealias RawSubgroup = (name: String, values: [Emoji.Value])
	static func subgroupParser() -> some Parser<Input, RawSubgroup> {
		Parse {
			Whitespace(.vertical)
			"# subgroup:"
			Whitespace()
			Prefix { $0 != "\n" }.map(String.init)
			Whitespace(.vertical)
			Many {
				emojiValueParser()
			} separator: {
				Whitespace(.vertical)
			}
		}
		.map { RawSubgroup($0, $1) }
	}

	typealias RawGroup = (name: String, subgroups: [RawSubgroup])
	static func groupParser() -> some Parser<Input, RawGroup> {
		Parse {
			Whitespace(.vertical)
			"# group:"
			Whitespace()
			Prefix { $0 != "\n" }.map(String.init)
			Whitespace(.vertical)
			Many {
				subgroupParser()
			} separator: {
				Whitespace(.vertical)
			}
			Skip {
				Whitespace(.vertical)
				Parse {
					"#"
					PrefixThrough("subtotal:")
					Prefix { $0 != "\n" }
					Whitespace(.vertical)
				}
				Parse {
					"#"
					PrefixThrough("subtotal:")
					Prefix { $0 != "\n" }
					Whitespace(.vertical)
				}
			}
		}
		.map { RawGroup($0, $1) }
	}

	static func prefixParser() -> some Parser<Input, Void> {
		Skip {
			Optionally {
				Many {
					"#"
					Prefix { $0 != "\n" }
				} separator: {
					Whitespace(1, .vertical)
				}
			}
		}
	}

	static func buildParser() -> some Parser<Input, Output> {
		Parse {
			prefixParser()
			Many {
				groupParser()
			} separator: {
				Whitespace(.vertical)
			}
			Skip {
				PrefixThrough("#EOF")
				Whitespace()
			}
		}
		.pipe {
			finalResultParser()
		}
	}

	static func finalResultParser() -> some Parser<[RawGroup], Output> {
		enum Error: Swift.Error {
			case couldNotCollectFinalResult
		}

		func collectIntoEmojis(_ values: [Emoji.Value]) throws -> OrderedSet<Emoji> {
			try OrderedDictionary(grouping: values, by: \.name).reduce(into: OrderedSet<Emoji>()) { (buffer, entry) in
				var rawEmoji = ([Emoji.Value](), [Emoji.Value]())
				entry.value.forEach { value in
					if value.attributes.isEmpty {
						rawEmoji.0.append(value)
					} else {
						rawEmoji.1.append(value)
					}
				}

				if !rawEmoji.0.isEmpty {
					rawEmoji.0.forEach { baseValue in
						buffer.append(Emoji(
							value: baseValue,
							skinTones: rawEmoji.1
						))
					}
				}	else if !rawEmoji.1.isEmpty {
					rawEmoji.1.forEach { baseValue in
						buffer.append(Emoji(
							value: baseValue,
							skinTones: []
						))
					}
				} else {
					throw Error.couldNotCollectFinalResult
				}
			}
		}

		return AnyParser { rawGroups in
			var output = Groups(minimumCapacity: rawGroups.count)

			try rawGroups.forEach { name, rawSubgroups in
				var suboutput = Subgroups(minimumCapacity: rawSubgroups.count)

				try rawSubgroups.forEach { name, values in
					suboutput[name] = try collectIntoEmojis(values)
				}

				output[name] = suboutput
			}

			return output
		}
	}
}

private extension Emoji {
	mutating func appendSkinTone(_ value: Emoji.Value) {
		self = .init(
			value: value,
			skinTones: skinTones + [value]
		)
	}
}
