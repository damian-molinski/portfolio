/// Collects entries into a map, so a chain can end in one instead of a collection-for literal.
extension IterableMapEntryExtension<K, V> on Iterable<MapEntry<K, V>> {
  Map<K, V> toMap() => Map.fromEntries(this);
}

/// The first element, or null when there is none.
///
/// `package:collection` supplies this, and one getter is not worth a dependency in a graph that
/// compiles twice.
extension IterableFirstOrNullExtension<E> on Iterable<E> {
  E? get firstOrNull => isEmpty ? null : first;
}
