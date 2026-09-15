/// Collects entries into a map, so a chain can end in one instead of a collection-for literal.
extension IterableMapEntryExtension<K, V> on Iterable<MapEntry<K, V>> {
  Map<K, V> toMap() => Map.fromEntries(this);
}

/// Joins the items the way a sentence does.
extension IterableSentenceExtension on Iterable<String> {
  /// `'a'`, `'a and b'`, `'a, b and c'`.
  ///
  /// No serial comma, which matches the rest of the site's copy.
  String toSentence() {
    final items = toList();
    if (items.length < 2) return items.join();

    final lead = items.take(items.length - 1);

    return '${lead.join(', ')} and ${items.last}';
  }
}
