import Testing
@testable import UnicodeEmojiParser

typealias parsers = UnicodeEmojiSourceParser

@Suite("UnicodeEmojiSubparsers Tests")
struct UnicodeEmojiSubparsersTests {
	@Test func unicodeScalarsParser() async throws {
		let parser = parsers.unicodeScalarsParser()
		let inputs = [
			"1F636 200D 1F32B FE0F",
			"1F636",
		]
		let expecteds = [
			[0x1F636, 0x200D, 0x1F32B, 0xFE0F].compactMap { Unicode.Scalar($0) },
			[0x1F636].compactMap { Unicode.Scalar($0) }
		]
		#expect(expecteds[0].count == 4, "Mocked values should be convertible to unicode scalars")
		#expect(expecteds[1].count == 1, "Mocked values should be convertible to unicode scalars")

		try zip(expecteds, inputs).forEach { expected, input in
			let actual = try parser.parse(input)
			#expect(actual == expected)
		}
	}

	@Test func unicodeScalarsParserFails() async throws {
		let parser = parsers.versionParser()
		let inputs = [
			"Some random string",
			"",
		]

		inputs.forEach { input in
			#expect(throws: Error.self, "Should throw an error") {
			 _ = try parser.parse(input)
		 }
		}
	}

	@Test func statusParser() async throws {
		let parser = parsers.statusParser()

		let statuses = Emoji.Value.Status.allCases

		try statuses.forEach { status in
			let actual = try parser.parse(status.rawValue)
			#expect(actual == status)
		}
	}

	@Test func statusParserFails() async throws {
		let parser = parsers.statusParser()
		let input = "Some random string"

		#expect(throws: Error.self, "Should throw an error") {
			_ = try parser.parse(input)
		}
	}

	@Test func versionParser() async throws {
		let parser = parsers.versionParser()

		let outputStyles: [SemanticVersion.VersionStringOutputStyle] = [
			.full,
			.dropUpToMinor(keepIfNotZero: true),
			.dropUpToMajor(keepIfNotZero: true),
		]

		let versions: [SemanticVersion] = [
			.init(major: 1, minor: 12, patch: 123),
			.init(major: 1, minor: 12, patch: 0),
			.init(major: 1, minor: 0, patch: 0),
		]

		try versions.forEach { version in
			try outputStyles.forEach { style in
				let input = version.versionString(style)
				let actual = try parser.parse(input)
				#expect(actual == version)
			}
		}
	}

	@Test func versionParserFails() async throws {
		let parser = parsers.versionParser()
		let inputs = [
			"Some random string",
			"1.1.1.1.1",
			"",
		]

		inputs.forEach { input in
			#expect(throws: Error.self, "Should throw an error") {
			 _ = try parser.parse(input)
		 }
		}
	}

	@Test func nameAndAdditionalKeysParser() async throws {
		typealias Expected = (name: String, keys: [String])
		let parser = parsers.nameAndAdditionalKeysParser()
		let expecteds: [Expected] = [
			("woman", []),
			("woman", ["medium-dark skin tone"]),
			("woman", ["medium-dark skin tone", "white hair"]),
		]

		func input(matching expected: Expected) -> String {
			if expected.keys.isEmpty {
				return expected.name
			} else {
				return "\(expected.name): \(expected.keys.joined(separator: ", "))"
			}
		}

		let data: [(Expected, String)] = expecteds.map { expected in
			(expected, input(matching: expected))
		}

		try data.forEach { expected, input in
			let actual = try parser.parse(input)
			#expect(actual == expected)
		}
	}

	@Test func nameAndAdditionalKeysParserFails() async throws {
		typealias Expected = (name: String, keys: [String])
		let parser = parsers.nameAndAdditionalKeysParser()
		let input = """
		some name without attributes
		270D ; fully-qualified  # ✍🏻 E1.0 valid emoji: with attribute
		"""

		#expect(throws: Error.self, "Should throw an error") {
			_ = try parser.parse(input)
		}
	}

	@Test func emojiValueParser() async throws {
		let parser = parsers.emojiValueParser()
		let inputs: [String] = [
			MockSource.mockSource(for: MockSource.EmojiValues.WritingHand.basic),
			MockSource.mockSource(for: MockSource.EmojiValues.WritingHand.unqualified),
			MockSource.mockSource(for: MockSource.EmojiValues.WritingHand.lightSkinTone),
		]

		let expecteds: [Emoji.Value] = [
			MockSource.EmojiValues.WritingHand.basic,
			MockSource.EmojiValues.WritingHand.unqualified,
			MockSource.EmojiValues.WritingHand.lightSkinTone,
		]

		try zip(expecteds, inputs).forEach { expected, input in
			let actual = try parser.parse(input)
			#expect(actual == expected)
		}
	}


	@Test func emojiValueParserFails() async throws {
		let parser = parsers.emojiValueParser()
		let inputs = [
			"Some random string",
			"NonUnicode  ; unqualified      # ✍ E0.7 writing hand",
			"270D FE0F   ; uNkNoWnStAtUs    # ✍️ X0.7 writing hand",
			"270D FE0F   ; fully-qualified  # ✍️ X0.7 writing hand",
			"""
			270D FE0F   ; fully-qualified  # ✍️ E0.7 writing hand
			270D FE0F   ; fully-qualified  # ✍️ E0.7 LONG_INPUT: some attr, another
			""",
			"",
		]

		inputs.forEach { input in
			#expect(throws: Error.self, "Should throw an error") {
			 _ = try parser.parse(input)
		 }
		}
	}

	@Test func subgroupParser() async throws {
		typealias Expected = parsers.RawSubgroup
		let parser = parsers.subgroupParser()

		let input = MockSource.mockSource(for: MockSource.EmojiGroups.PeopleAndBody.Subgroups.HandProp.self)
		let expected: Expected = MockSource.EmojiGroups.PeopleAndBody.Subgroups.HandProp.raw

		let actual = try parser.parse(input)
		#expect(actual.name == expected.name)
		#expect(actual.values.count == expected.values.count)
		#expect(actual.values == expected.values)
	}

	@Test func subgroupParserFails() async throws {
		let parser = parsers.subgroupParser()
		let input = "Some random string"

		#expect(throws: Error.self, "Should throw an error") {
			_ = try parser.parse(input)
		}
	}

	@Test func groupParser() async throws {
		typealias Subgroup = (name: String, values: [Emoji.Value])
		typealias Expected = (name: String, subgroups: [Subgroup])
		let parser = parsers.groupParser()

		let input = MockSource.mockSource(for: MockSource.EmojiGroups.PeopleAndBody.self)

		let expected: Expected = MockSource.EmojiGroups.PeopleAndBody.raw

		let actual = try parser.parse(input)
		#expect(actual.name == expected.name)
		#expect(actual.subgroups.map(\.name) == expected.subgroups.map(\.name))
		#expect(actual.subgroups.map(\.values) == expected.subgroups.map(\.values))
	}

	@Test func groupParserFails() async throws {
		let parser = parsers.groupParser()
		let input = "Some random string"

		#expect(throws: Error.self, "Should throw an error") {
			_ = try parser.parse(input)
		}
	}
}
