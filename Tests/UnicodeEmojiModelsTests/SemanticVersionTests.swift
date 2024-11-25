import Testing
@testable import UnicodeEmojiModels

@Suite("SemanticVersion Tests")
struct SemanticVersionTests {
	@Test func versionFromString() async throws {
		#expect(SemanticVersion.string("1.0.0") == SemanticVersion(1, 0, 0))
		#expect(SemanticVersion.string("1.12") == SemanticVersion(1, 12, 0))
		#expect(SemanticVersion.string("1.12.123") == SemanticVersion(1, 12, 123))
		#expect(SemanticVersion.string("123") == SemanticVersion(123, 0, 0))
		#expect(SemanticVersion.string("") == nil)
		#expect(SemanticVersion.string("1.1.1.1") == nil)
		#expect(SemanticVersion.string("1.1.x") == nil)
	}

	@Test func stringFromVersion() async throws {
		#expect(SemanticVersion(1, 0, 0).versionString() == "1.0.0")
		#expect(SemanticVersion(1, 0, 0).versionString(.full) == "1.0.0")
		#expect(SemanticVersion(1, 12, 123).versionString(.dropUpToMinor()) == "1.12")
		#expect(SemanticVersion(1, 12, 123).versionString(.dropUpToMajor()) == "1")
		#expect(SemanticVersion(1, 12, 123).versionString(.dropUpToMinor(keepIfNotZero: true)) == "1.12.123")
		#expect(SemanticVersion(1, 12, 123).versionString(.dropUpToMajor(keepIfNotZero: true)) == "1.12.123")
		#expect(SemanticVersion(1, 0, 0).versionString(.dropUpToMinor(keepIfNotZero: true)) == "1.0")
		#expect(SemanticVersion(1, 0, 0).versionString(.dropUpToMajor(keepIfNotZero: true)) == "1")
		#expect(SemanticVersion(1, 0, 1).versionString(.dropUpToMinor(keepIfNotZero: true)) == "1.0.1")
		#expect(SemanticVersion(1, 0, 1).versionString(.dropUpToMajor(keepIfNotZero: true)) == "1.0.1")
		#expect(SemanticVersion(1, 1, 0).versionString(.dropUpToMinor(keepIfNotZero: true)) == "1.1")
		#expect(SemanticVersion(1, 1, 0).versionString(.dropUpToMajor(keepIfNotZero: true)) == "1.1.0")
	}
}
