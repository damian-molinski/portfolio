import 'package:portfolio/domain/models/site_content.dart';
import 'package:portfolio/utils/iterable_extensions.dart';
import 'package:test/test.dart';

void main() {
  group('IterableFirstOrNullExtension', () {
    group('firstOrNull', () {
      test('is null for nothing', () {
        expect(const <String>[].firstOrNull, isNull);
      });

      test('is the only item when there is one', () {
        expect(['your name'].firstOrNull, 'your name');
      });

      test('is the first of many, in iteration order', () {
        expect(ContactField.values.map((field) => field.noun).firstOrNull, 'your name');
      });

      test('keeps a map\'s key order', () {
        final problems = {ContactField.email: 1, ContactField.brief: 2};

        expect(problems.keys.firstOrNull, ContactField.email);
      });
    });
  });

  group('IterableMapEntryExtension', () {
    group('toMap', () {
      test('collects the entries', () {
        expect([const MapEntry('a', 1), const MapEntry('b', 2)].toMap(), {'a': 1, 'b': 2});
      });

      test('keeps the last of a repeated key, as a map literal would', () {
        expect([const MapEntry('a', 1), const MapEntry('a', 2)].toMap(), {'a': 2});
      });
    });
  });
}
