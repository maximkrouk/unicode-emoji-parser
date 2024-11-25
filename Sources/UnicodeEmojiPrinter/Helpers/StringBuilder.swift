@resultBuilder
enum StringBuilder {
	static func buildBlock(_ components: String...) -> String {
		components.joined()
	}

	static func buildEither(first component: String) -> String {
		return component
	}

	static func buildEither(second component: String) -> String {
		return component
	}

	static func buildOptional(_ component: String?) -> String {
		return component ?? ""
	}
}
