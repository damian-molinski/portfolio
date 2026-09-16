import 'dart:convert';

extension JsonMapExtension<V> on Map<String, V> {
  /// Throws [JsonUnsupportedObjectError] on a value with neither a JSON form nor a `toJson`.
  String encodeJson() => jsonEncode(this);
}
