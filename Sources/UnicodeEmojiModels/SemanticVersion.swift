public struct SemanticVersion: Hashable, Comparable, Sendable {
	public static func < (lhs: SemanticVersion, rhs: SemanticVersion) -> Bool {
		func compare(
			_ keyPath: KeyPath<SemanticVersion, UInt>,
			ifEqual fallback: () -> Bool = { false }
		) -> Bool {
			let _lhs = lhs[keyPath: keyPath]
			let _rhs = rhs[keyPath: keyPath]
			return _lhs == _rhs ? fallback() : _lhs < _rhs
		}

		return compare(\.major, ifEqual: {
			compare(\.minor, ifEqual: {
				compare(\.patch)
			})
		})
	}

	public let major: UInt
	public let minor: UInt
	public let patch: UInt

	public init(
		_ major: UInt,
		_ minor: UInt,
		_ patch: UInt
	) {
		self.init(
			major: major,
			minor: minor,
			patch: patch)
	}

	public init(
		major: UInt = 0,
		minor: UInt = 0,
		patch: UInt = 0
	) {
		self.major = major
		self.minor = minor
		self.patch = patch
	}

	public static func string(_ string: String) -> Self?  {
		let components = string.split(separator: ".")
		let versionComponents = components.compactMap { UInt($0) }
		guard versionComponents.count == components.count else { return nil }

		switch versionComponents.count {
		case 1:
			return .init(
				major: versionComponents[0]
			)
		case 2:
			return .init(
				major: versionComponents[0],
				minor: versionComponents[1]
			)
		case 3:
			return .init(
				major: versionComponents[0],
				minor: versionComponents[1],
				patch: versionComponents[2]
			)
		default:
			return nil
		}
	}
}

extension SemanticVersion {
	public enum VersionStringOutputStyle: Sendable, CaseIterable {
		case full
		case dropUpToMinor(keepIfNotZero: Bool = false)
		case dropUpToMajor(keepIfNotZero: Bool = false)

		public static var allCases: [VersionStringOutputStyle] {
			[
				.full,
				.dropUpToMinor(),
				.dropUpToMajor(),
				.dropUpToMinor(keepIfNotZero: true),
				.dropUpToMajor(keepIfNotZero: true)
			]
		}
	}

	public func versionString(_ style: VersionStringOutputStyle = .full) -> String {
		switch style {
		case let .dropUpToMajor(keepIfNotZero) where !(keepIfNotZero && (patch != 0 || minor != 0)):
			return "\(major)"
		case let .dropUpToMinor(keepIfNotZero) where !(keepIfNotZero && patch != 0):
			return "\(major).\(minor)"
		default:
			return "\(major).\(minor).\(patch)"
		}
	}
}
