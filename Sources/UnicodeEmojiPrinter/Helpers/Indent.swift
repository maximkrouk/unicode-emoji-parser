func makeIndentor(_ indentor: String, tabSize: Int) -> @Sendable (Int) -> @Sendable (String) -> String {
	let _indentor = String(repeating: indentor, count: tabSize)
	return { level in
		return { source in
			source.components(separatedBy: .newlines)
				.map { String(repeating: _indentor, count: level) + $0 }
				.joined(separator: "\n")
		}
	}
}
