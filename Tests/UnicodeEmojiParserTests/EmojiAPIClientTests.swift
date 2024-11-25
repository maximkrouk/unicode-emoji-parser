import Testing
@testable import UnicodeEmojiParser
import OrderedCollections

@Suite("EmojiAPIClient Tests")
struct EmojiAPIClientTests {
	@Test func fetchEmojis() async throws {
		let client = EmojiAPIClient.default(for: .init(fetchSource: { MockSource.document }))

		let expected: EmojiList = [
			MockSource.EmojiGroups.PeopleAndBody.name: OrderedDictionary(uniqueKeysWithValues: [
				(MockSource.EmojiGroups.PeopleAndBody.Subgroups.HandProp.name, OrderedSet(MockSource.EmojiGroups.PeopleAndBody.Subgroups.HandProp.emojis)),
				(MockSource.EmojiGroups.PeopleAndBody.Subgroups.Person.name, OrderedSet(MockSource.EmojiGroups.PeopleAndBody.Subgroups.Person.emojis)),
			]),
			MockSource.EmojiGroups.Flags.name: [
				MockSource.EmojiGroups.Flags.Subgroups.Flag.name: OrderedSet(MockSource.EmojiGroups.Flags.Subgroups.Flag.emojis),
			],
		]

		let actual = try await client.fetchEmojis()
		#expect(actual == expected)
	}
}
