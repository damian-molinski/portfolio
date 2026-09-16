import 'package:portfolio/utils/result.dart';
import 'package:test/test.dart';

void main() {
  group(Result, () {
    test('a success holds its value', () {
      expect(const Success<int, String>(204).value, 204);
    });

    test('a failure holds its error', () {
      expect(const Failure<int, String>('offline').error, 'offline');
    });

    test('arms compare by what they carry', () {
      expect(const Success<int, String>(204), const Success<int, String>(204));
      expect(const Success<int, String>(204), isNot(const Success<int, String>(200)));
      expect(const Failure<int, String>('offline'), const Failure<int, String>('offline'));
    });

    test('a success never equals a failure carrying the same payload', () {
      expect(const Success<String, String>('same'), isNot(const Failure<String, String>('same')));
    });
  });
}
