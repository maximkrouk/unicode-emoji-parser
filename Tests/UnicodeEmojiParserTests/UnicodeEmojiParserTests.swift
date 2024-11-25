import Testing
@testable import UnicodeEmojiParser
import OrderedCollections

@Suite("UnicodeEmojiSourceParser Tests")
struct UnicodeEmojiSourceParserTests {
	@Test func groupParser() async throws {
		let parser = UnicodeEmojiSourceParser()

		let input = MockSource.document

		let expected: EmojiList = [
			MockSource.EmojiGroups.PeopleAndBody.name: OrderedDictionary(uniqueKeysWithValues: [
				(MockSource.EmojiGroups.PeopleAndBody.Subgroups.HandProp.name, OrderedSet(MockSource.EmojiGroups.PeopleAndBody.Subgroups.HandProp.emojis)),
				(MockSource.EmojiGroups.PeopleAndBody.Subgroups.Person.name, OrderedSet(MockSource.EmojiGroups.PeopleAndBody.Subgroups.Person.emojis)),
			]),
			MockSource.EmojiGroups.Flags.name: [
				MockSource.EmojiGroups.Flags.Subgroups.Flag.name: OrderedSet(MockSource.EmojiGroups.Flags.Subgroups.Flag.emojis),
			],
		]

		let actual = try parser.parse(input)
		#expect(actual == expected)
	}
}

