import 'package:portfolio/domain/dispatch_outcome.dart';
import 'package:portfolio/ui/contact/view_model/contact_state.dart';
import 'package:test/test.dart';

void main() {
  group(DispatchFailure, () {
    group('of', () {
      test('reads a request that never left as a lost connection', () {
        expect(DispatchFailure.of(const NetworkDispatchException()), DispatchFailure.network);
      });

      test('reads a refused body as rejected', () {
        expect(DispatchFailure.of(const RejectedDispatchException()), DispatchFailure.rejected);
      });

      test('reads a rate limit as itself', () {
        expect(DispatchFailure.of(const RateLimitedDispatchException()), DispatchFailure.rateLimited);
      });

      test('reads a refusal from the mailer as delivery being down', () {
        expect(DispatchFailure.of(const MailerDispatchException()), DispatchFailure.mailer);
      });

      test('reads anything the dispatcher did not name as delivery being down', () {
        expect(DispatchFailure.of(const FormatException()), DispatchFailure.mailer);
      });
    });
  });
}
