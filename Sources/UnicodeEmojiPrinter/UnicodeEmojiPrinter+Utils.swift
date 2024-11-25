extension UnicodeEmojiPrinter {
	static let _indent = makeIndentor("\t", tabSize: 1)
	static func indent(
		_ level: Int = 1,
		@StringBuilder _ source: @Sendable () -> String
	) -> String {
		_indent(level)(source())
	}

	@StringBuilder
	static func comment(
		@StringBuilder _ input: () -> String
	) -> String {
		input()
			.components(separatedBy: "\n")
			.map { "// \($0)" }
			.joined(separator: "\n")
	}

	@StringBuilder
	static func escapedString(_ input: String) -> String {
		"\""
		input
		"\""
	}

	@StringBuilder
	static func initializer(
		_ type: String,
	forceUnwrap: Bool = false,
		@StringBuilder _ args: @Sendable () -> String
	) -> String {
		"\(type)(\n"
		indent {
			args()
		}
		"\n)"
		if forceUnwrap {
			"!"
		}
	}

	@StringBuilder
	static func array<C: Collection & Sendable>(
		_ input: C,
		indent level: Int = 1,
		indentClosingBrace: Bool = false,
		@StringBuilder printer: @Sendable (C.Element) -> String
	) -> String {
		if input.isEmpty {
			"[]"
		} else {
			"[\n"
			indent(level) {
				input.map(printer).joined(separator: ",\n")
			}
			"\n"
			if indentClosingBrace {
				"\t"
			}
			"]"
		}
	}
}
