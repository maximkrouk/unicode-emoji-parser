// swift-tools-version: 6.0

import PackageDescription

let package = Package(
	name: "swift-unicode-emoji-parser",
	platforms: [
		.iOS(.v15),
		.macOS(.v15),
	],
	products: [
		.library(
			name: "UnicodeEmojiParser",
			targets: ["UnicodeEmojiParser"]
		),
		.library(
			name: "UnicodeEmojiModels",
			targets: ["UnicodeEmojiModels"]
		),
	],
	dependencies: [
		.package(
			url: "https://github.com/apple/swift-argument-parser.git",
			.upToNextMajor(from: "1.5.0")
		),
		.package(
			url: "https://github.com/apple/swift-collections.git",
			.upToNextMajor(from: "1.1.4")
		),
		.package(
			url: "https://github.com/pointfreeco/swift-parsing.git",
			.upToNextMinor(from: "0.13.0")
		),
	],
	targets: [
		.target(
			name: "UnicodeEmojiModels",
			dependencies: [
				.product(
					name: "OrderedCollections",
					package: "swift-collections"
				),
			]
		),
		.target(
			name: "UnicodeEmojiParser",
			dependencies: [
				.target(name: "UnicodeEmojiModels"),
				.product(
					name: "Parsing",
					package: "swift-parsing"
				),
			]
		),
		.target(
			name: "UnicodeEmojiPrinter",
			dependencies: [
				.target(name: "UnicodeEmojiModels"),
			]
		),
		.executableTarget(
			name: "unicode-emoji-parser",
			dependencies: [
				.target(name: "UnicodeEmojiParser"),
				.target(name: "UnicodeEmojiPrinter"),
				.product(
					name: "ArgumentParser",
					package: "swift-argument-parser"
				),
			],
			path: "Sources/UnicodeEmojiParserCLI"
		),
		.testTarget(
			name: "UnicodeEmojiModelsTests",
			dependencies: [
				.target(name: "UnicodeEmojiModels"),
			]
		),
		.testTarget(
			name: "UnicodeEmojiParserTests",
			dependencies: [
				.target(name: "UnicodeEmojiParser"),
			]
		),
		.testTarget(
			name: "UnicodeEmojiPrinterTests",
			dependencies: [
				.target(name: "UnicodeEmojiPrinter"),
			]
		),
	]
)
