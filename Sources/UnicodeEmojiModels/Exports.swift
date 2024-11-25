import OrderedCollections

public typealias EmojiGroup = OrderedDictionary<String, OrderedSet<Emoji>>
public typealias EmojiList = OrderedDictionary<String, EmojiGroup>
