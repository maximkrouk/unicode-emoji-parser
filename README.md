# unicode-emoji-parser

A playground project that uses [`swift-parsing`](https://github.com/pointfreeco/swift-parsing) for parsing [`emojis from unicode.org`]("https://unicode.org/public/emoji/latest/emoji-test.txt").

- **`UnicodeEmojiModels`** module provides swift representations for emojis

- **`UnicodeEmojiParser`** module includes

  - `EmojiSourceAPIClient` that can fetch unparsed file
  - `EmojiAPIClient` that can fetch latest emojis and parse them
    - Uses `EmojiSourceAPIClient.default` by default
    - Uses `UnicodeEmojiSourceParser` by default
  - `UnicodeEmojiSourceParser` that can parse contents of file provided by unicode.org

- **`UnicodeEmojiParserCLI`** module produces `unicode-emoji-parser` executable

  - `unicode-emoji-parser version` prints version
  - `unicode-emoji-parser fetch --output="<output_path>"` can fetch file to a local destination
  - `unicode-emoji-parser generate --input="<local_file>" --output="<output_file>"` will generate a swift file with emoji declarations from a local file
    - `--input="<local_file>"` can be omitted, in that case it will fetch latest emojis before generating declarations
    - It supports multiple styles
      - `--style=grouped` is default, generates an ordered dictionary of groupped emojis
      - `--style=emojis` generates an array of emojis with embedded skin tones
      - `--style=values` generates an array of plain emoji values

- **`UnicodeEmojiPrinter`** module is a core of `unicode-emoji-parser` generation, it contains printers that can convert parsed data to strings, it includes

  > Currently it only supports swift



Since it's just a playground, this package doesn't provide much infrastructure/prebuilt executables, maybe in the future it'll provide more configuration for the cli, spm plugins, more formats etc. but no promises from my side 💁‍♂️