//App.main()

try await App.Generate(
	output: "/Users/maximkrouk/Developer/CaptureContext/Contribution/unicode-emoji-parser/Generated/EmojiList.generated.swift",
	style: .grouped
).run()

try await App.Generate(
	output: "/Users/maximkrouk/Developer/CaptureContext/Contribution/unicode-emoji-parser/Generated/Emojis.generated.swift",
	style: .emojis
).run()

try await App.Generate(
	output: "/Users/maximkrouk/Developer/CaptureContext/Contribution/unicode-emoji-parser/Generated/EmojiValues.generated.swift",
	style: .values
).run()
