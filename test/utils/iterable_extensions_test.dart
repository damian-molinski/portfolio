import 'package:portfolio/content/site_content.dart';
import 'package:portfolio/utils/iterable_extensions.dart';
import 'package:test/test.dart';

void main() {
  group('IterableSentenceExtension', () {
    group('toSentence', () {
      test('is empty for nothing', () {
        expect(const <String>[].toSentence(), isEmpty);
      });

      test('leaves a single item alone', () {
        expect(['your name'].toSentence(), 'your name');
      });

      test('joins a pair with and, and no comma', () {
        expect(['your name', 'a project brief'].toSentence(), 'your name and a project brief');
      });

      test('separates the rest with commas', () {
        expect(
          ContactField.values.map((field) => field.noun).toSentence(),
          'your name, your email address and a project brief',
        );
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
