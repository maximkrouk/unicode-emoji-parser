import stdlib_h
import Foundation

//do { // uncomment for debugging
//	// Default currentDirectoryPath for DUBUG should be ./DerivedData/unicode-emoji-parser/Build/Products/Debug
//	let packageDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
//		.deletingLastPathComponent() // Debug
//		.deletingLastPathComponent() // Products
//		.deletingLastPathComponent() // Build
//		.deletingLastPathComponent() // unicode-emoji-parser
//		.deletingLastPathComponent() // DerivedData
//
//	let outputDirectoryURL = packageDirectoryURL.appending(path: "Generated")
//	print("Generating sources in \(outputDirectoryURL.absoluteString)")
//
//	let localInput = true
//	? outputDirectoryURL.appending(path: "test.txt")
//	: nil
//
//	print("• EmojiList...")
//	try await App.Generate(
//		input: localInput?.path(),
//		output: outputDirectoryURL.appending(path: "EmojiList.generated.swift").path(),
//		style: .grouped
//	).run()
//
//	print("• Emojis...")
//	try await App.Generate(
//		input: localInput?.path(),
//		output: outputDirectoryURL.appending(path: "Emojis.generated.swift").path(),
//		style: .emojis
//	).run()
//
//	print("• EmojiValues...")
//	try await App.Generate(
//		input: localInput?.path(),
//		output: outputDirectoryURL.appending(path: "EmojiValues.generated.swift").path(),
//		style: .values
//	).run()
//
//	print("Done ✅")
//	exit(0)
//}

App.main()
