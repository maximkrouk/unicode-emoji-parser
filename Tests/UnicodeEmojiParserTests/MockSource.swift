@testable import UnicodeEmojiParser

protocol EmojiGroupMockProtocol {
	static var name: String { get }
	static var subgroups: [any EmojiSubgroupMockProtocol.Type] { get }
	static var raw: UnicodeEmojiSourceParser.RawGroup { get }
}

extension EmojiGroupMockProtocol {
	static var raw: UnicodeEmojiSourceParser.RawGroup {
		(name, subgroups.map { $0.raw })
	}
}

protocol EmojiSubgroupMockProtocol {
	static var name: String { get }
	static var emojis: [Emoji] { get }
	static var values: [Emoji.Value] { get }
	static var raw: UnicodeEmojiSourceParser.RawSubgroup { get }
}

extension EmojiSubgroupMockProtocol {
	static var raw: UnicodeEmojiSourceParser.RawSubgroup {
		(name, values)
	}
}

public enum MockSource {
	static var document: String {
		"""
		\(header)
		
		\(mockSource(for: EmojiGroups.PeopleAndBody.self))
		
		\(mockSource(for: EmojiGroups.Flags.self))
		
		\(footer)
		"""
	}

	static var header: String {
		"""
		# emoji-test.txt
		# Date: 2024-08-14, 23:51:54 GMT
		# © 2024 Unicode®, Inc.
		# Unicode and the Unicode Logo are registered trademarks of Unicode, Inc. in the U.S. and other countries.
		# For terms of use and license, see https://www.unicode.org/terms_of_use.html
		#
		# Emoji Keyboard/Display Test Data for UTS #51
		# Version: 16.0
		#
		# For documentation and usage, see https://www.unicode.org/reports/tr51
		#
		# This file provides data for testing which emoji forms should be in keyboards and which should also be displayed/processed.
		# Format: code points; status # emoji name
		#     Code points — list of one or more hex code points, separated by spaces
		#     Status
		#       component           — an Emoji_Component,
		#                             excluding Regional_Indicators, ASCII, and non-Emoji.
		#       fully-qualified     — a fully-qualified emoji (see ED-18 in UTS #51),
		#                             excluding Emoji_Component
		#       minimally-qualified — a minimally-qualified emoji (see ED-18a in UTS #51)
		#       unqualified         — a unqualified emoji (See ED-19 in UTS #51)
		# Notes:
		#   • This includes the emoji components that need emoji presentation (skin tone and hair)
		#     when isolated, but omits the components that need not have an emoji
		#     presentation when isolated.
		#   • The RGI set is covered by the listed fully-qualified emoji. 
		#   • The listed minimally-qualified and unqualified cover all cases where an
		#     element of the RGI set is missing one or more emoji presentation selectors.
		#   • The file is in CLDR order, not codepoint order. This is recommended (but not required!) for keyboard palettes.
		#   • The groups and subgroups are illustrative. See the Emoji Order chart for more information.
		"""
	}

	static var footer: String {
		"""
		# Status Counts
		# fully-qualified : 7
		# minimally-qualified : 0
		# unqualified : 1
		# component : 0
		
		#EOF
		"""
	}

	static func mockSource(for groupType: any EmojiGroupMockProtocol.Type) -> String {
		"""
		# group: \(groupType.name)
		
		\(groupType.subgroups.map(mockSource(for:)).joined(separator: "\n\n"))
		
		# \(groupType.name) subtotal:		\(groupType.subgroups.flatMap { $0.values }.count)
		# \(groupType.name) subtotal:		\(groupType.subgroups.flatMap { $0.emojis }.count) w/o modifiers
		"""
	}

	static func mockSource(for subgroupType: any EmojiSubgroupMockProtocol.Type) -> String {
		"""
		# subgroup: \(subgroupType.name)
		\(subgroupType.values.map(mockSource(for:)).joined(separator: "\n"))
		"""
	}

	static func mockSource(for emojiValue: Emoji.Value) -> String {
		let scalars = emojiValue.unicodeScalars.map { String(format: "%X", $0.value) }.joined(separator: " ")
		let status = emojiValue.status.rawValue
		let emojiString = emojiValue.emojiString()
		let version = emojiValue.version.versionString(.dropUpToMinor(keepIfNotZero: true))
		let attributedName = emojiValue.attributedName
		return "\(scalars)  ; \(status)  # \(emojiString) E\(version) \(attributedName)"
	}

	enum EmojiGroups {
		enum PeopleAndBody: EmojiGroupMockProtocol {
			static var name: String { "People & Body" }
			static var subgroups: [any EmojiSubgroupMockProtocol.Type] {
				[Subgroups.HandProp.self, Subgroups.Person.self]
			}

			enum Subgroups {
				enum HandProp: EmojiSubgroupMockProtocol {
					static var name: String { "hand-prop" }

					static var values: [Emoji.Value] {
						[
							EmojiValues.WritingHand.basic,
							EmojiValues.WritingHand.unqualified,
							EmojiValues.WritingHand.lightSkinTone,
						]
					}

					static var emojis: [Emoji] {
						[
							Emoji(
								value: EmojiValues.WritingHand.basic,
								skinTones: [
									EmojiValues.WritingHand.lightSkinTone,
								]
							),
							Emoji(
								value: EmojiValues.WritingHand.unqualified,
								skinTones: [
									EmojiValues.WritingHand.lightSkinTone,
								]
							),
						]
					}
				}

				enum Person: EmojiSubgroupMockProtocol {
					static var name: String { "person" }

					static var values: [Emoji.Value] {
						[
							EmojiValues.Baby.basic,
							EmojiValues.Baby.lightSkinTone,
							EmojiValues.Baby.mediumLightSkinTone,
						]
					}

					static var emojis: [Emoji] {
						[
							Emoji(
								value: EmojiValues.Baby.basic,
								skinTones: [
									EmojiValues.Baby.lightSkinTone,
									EmojiValues.Baby.mediumLightSkinTone,
								]
							),
						]
					}
				}
			}
		}
		enum Flags: EmojiGroupMockProtocol {
			static var name: String { "Flags" }
			static var subgroups: [any EmojiSubgroupMockProtocol.Type] {
				[Subgroups.Flag.self]
			}

			enum Subgroups {
				enum Flag: EmojiSubgroupMockProtocol {
					static var name: String { "flag "}

					static var values: [Emoji.Value] {
						[
							EmojiValues.Flag.chequered,
							EmojiValues.Flag.triangular,
						]
					}

					static var emojis: [Emoji] {
						[
							Emoji(
								value: EmojiValues.Flag.chequered,
								skinTones: []
							),
							Emoji(
								value: EmojiValues.Flag.triangular,
								skinTones: []
							),
						]
					}
				}
			}
		}
	}

	enum EmojiValues {
		enum WritingHand {
			static var basic: Emoji.Value {
				Emoji.Value(
					unicodeScalars: [0x270D, 0xFE0F],
					version: .init(major: 0, minor: 7),
					status: .fullyQualified,
					name: "writing hand",
					attributes: []
				)!
			}

			static var unqualified: Emoji.Value {
				Emoji.Value(
					unicodeScalars: [0x270D],
					version: .init(major: 0, minor: 7),
					status: .unqualified,
					name: "writing hand",
					attributes: []
				)!
			}

			static var lightSkinTone: Emoji.Value {
				Emoji.Value(
					unicodeScalars: [0x270D, 0x1F3FB],
					version: .init(major: 1, minor: 0),
					status: .fullyQualified,
					name: "writing hand",
					attributes: ["light skin tone"]
				)!
			}
		}

		enum Baby {
			static var basic: Emoji.Value {
				Emoji.Value(
					unicodeScalars: [0x1F476],
					version: .init(major: 0, minor: 6),
					status: .fullyQualified,
					name: "baby",
					attributes: []
				)!
			}

			static var lightSkinTone: Emoji.Value {
				Emoji.Value(
					unicodeScalars: [0x1F476, 0x1F3FB],
					version: .init(major: 1, minor: 0),
					status: .fullyQualified,
					name: "baby",
					attributes: ["light skin tone"]
				)!
			}

			static var mediumLightSkinTone: Emoji.Value {
				Emoji.Value(
					unicodeScalars: [0x1F476, 0x1F3FC],
					version: .init(major: 1, minor: 0),
					status: .fullyQualified,
					name: "baby",
					attributes: ["medium-light skin tone"]
				)!
			}
		}

		enum Flag {
			static var chequered: Emoji.Value {
				Emoji.Value(
					unicodeScalars: [0x1F3C1],
					version: .init(major: 0, minor: 6),
					status: .fullyQualified,
					name: "chequered flag",
					attributes: []
				)!
			}

			static var triangular: Emoji.Value {
				Emoji.Value(
					unicodeScalars: [0x1F6A9],
					version: .init(major: 0, minor: 6),
					status: .fullyQualified,
					name: "triangular flag",
					attributes: []
				)!
			}
		}
	}
}
