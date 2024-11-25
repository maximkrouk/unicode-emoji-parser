import Testing
@testable import UnicodeEmojiPrinter
import OrderedCollections

@Suite("UnicodeEmojiPrinter+Utils Tests")
struct UnicodeEmojiPrinterUtilsTests {
	@Test func indent() async throws {
		let input = """
		Each
		Line
		Is
		Indented
		"""

		let expected_level_1 = """
			Each
			Line
			Is
			Indented
		"""

		let actual_level_1 = UnicodeEmojiPrinter.indent(1) {
			input
		}

		#expect(actual_level_1 == expected_level_1)

		let expected_level_2 = """
				Each
				Line
				Is
				Indented
		"""

		let actual_level_2 = UnicodeEmojiPrinter.indent(2) {
			input
		}

		#expect(actual_level_2 == expected_level_2)
	}

	@Test func comment() async throws {
		let input = """
		Each
		Line
		Is
		Commented
		"""

		let expected = """
		// Each
		// Line
		// Is
		// Commented
		"""

		let actual = UnicodeEmojiPrinter.comment {
			input
		}

		#expect(actual == expected)
	}

	@Test func escapedString() async throws {
		let input = "Hello, World!"
		
		let expected = "\"Hello, World!\""
		
		let actual = UnicodeEmojiPrinter.escapedString(input)

		#expect(actual == expected)
	}

	@Test func initializer() async throws {
		let inputName = "MyType"
		let inputArgs = """
		arg1: "",
		arg2: true
		"""

		let expected = """
		MyType(
			arg1: "",
			arg2: true
		)
		"""

		let actual = UnicodeEmojiPrinter.initializer(inputName) {
			inputArgs
		}

		#expect(actual == expected)
	}

	@Test func array() async throws {
		let input = ["Hello", "World"]

		let expected = """
		[
			"Hello",
			"World"
		]
		"""

		let actual = UnicodeEmojiPrinter.array(input, printer: { UnicodeEmojiPrinter.escapedString($0) })

		#expect(actual == expected)

		let actualEmpty = UnicodeEmojiPrinter.array(input.drop(while: { _ in true }), printer: { UnicodeEmojiPrinter.escapedString($0) })

		#expect(actualEmpty == "[]")
	}
}

