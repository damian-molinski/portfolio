import 'package:bloc_test/bloc_test.dart';
import 'package:portfolio/content/site_content.dart';
import 'package:portfolio/data/contact_dispatcher.dart';
import 'package:portfolio/state/contact_cubit.dart';
import 'package:portfolio/state/contact_draft.dart';
import 'package:portfolio/state/contact_state.dart';
import 'package:test/test.dart';

final class _FakeContactDispatcher implements ContactDispatcher {
  _FakeContactDispatcher({this.failure});

  final DispatchFailure? failure;
  final List<ContactDraft> sent = [];

  @override
  Future<DispatchFailure?> send(ContactDraft draft) async {
    sent.add(draft);
    return failure;
  }
}

extension on ContactCubit {
  void fillRequiredFields() {
    updateName('Ada Lovelace');
    updateEmail('ada@example.com');
    updateBrief('A note about the engine.');
  }
}

extension on ContactState {
  ContactState reporting(Map<ContactField, FieldProblem> problems) {
    return ContactState(
      name: name,
      email: email,
      brief: brief,
      scope: scope,
      status: status,
      problems: problems,
    );
  }
}

final _everyFieldMissing = {
  for (final field in ContactField.values) field: FieldProblem.missing,
};

ContactState filledState({required DispatchStatus status, DispatchFailure? failure}) {
  return ContactState(
    name: 'Ada Lovelace',
    email: 'ada@example.com',
    brief: 'A note about the engine.',
    scope: ScopeOption.initial,
    status: status,
    problems: const {},
    failure: failure,
  );
}

ContactState clearedState({required DispatchStatus status}) {
  return ContactState(
    name: null,
    email: null,
    brief: null,
    scope: ScopeOption.initial,
    status: status,
    problems: const {},
  );
}

void main() {
  group(ContactCubit, () {
    late _FakeContactDispatcher dispatcher;

    setUp(() => dispatcher = _FakeContactDispatcher());

    ContactCubit buildCubit() => ContactCubit(dispatcher: dispatcher, confirmationDuration: Duration.zero);

    ContactCubit buildRefusingCubit({DispatchFailure failure = DispatchFailure.mailer}) => ContactCubit(
      dispatcher: _FakeContactDispatcher(failure: failure),
      confirmationDuration: Duration.zero,
    );

    final fillEmits = ContactField.values.length;
    const settle = Duration(milliseconds: 10);

    test('starts empty, on the first scope, with nothing to report', () {
      final cubit = buildCubit();
      addTearDown(cubit.close);

      expect(cubit.state, ContactState.initial());
    });

    group('submit', () {
      blocTest<ContactCubit, ContactState>(
        'is rejected while a required field is empty, and sends nothing',
        build: buildCubit,
        act: (cubit) => cubit.submit(),
        wait: settle,
        expect: () => [clearedState(status: DispatchStatus.idle).reporting(_everyFieldMissing)],
        verify: (cubit) {
          expect(cubit.state.status, DispatchStatus.idle);
          expect(dispatcher.sent, isEmpty);
        },
      );

      blocTest<ContactCubit, ContactState>(
        'runs idle → transmitting → sent → idle and clears the form on the way',
        build: buildCubit,
        act: (cubit) async {
          cubit.fillRequiredFields();
          await cubit.submit();
        },
        skip: fillEmits,
        wait: settle,
        expect: () => [
          filledState(status: DispatchStatus.transmitting),
          clearedState(status: DispatchStatus.sent),
          clearedState(status: DispatchStatus.idle),
        ],
      );

      blocTest<ContactCubit, ContactState>(
        'reports no problems after a send that followed a rejected press',
        build: buildCubit,
        act: (cubit) async {
          await cubit.submit();
          cubit.fillRequiredFields();
          await cubit.submit();
        },
        wait: settle,
        verify: (cubit) {
          expect(cubit.state.status, DispatchStatus.idle);
          expect(cubit.state.problems, isEmpty);
          expect(dispatcher.sent, hasLength(1));
        },
      );

      blocTest<ContactCubit, ContactState>(
        'posts what the visitor typed',
        build: buildCubit,
        act: (cubit) async {
          cubit.fillRequiredFields();
          cubit.updateScope(ScopeOption.values.last);
          cubit.updateHoneypot('Acme Corp');
          await cubit.submit();
        },
        wait: settle,
        verify: (_) {
          expect(dispatcher.sent, hasLength(1));

          final draft = dispatcher.sent.single;
          expect(draft.name, 'Ada Lovelace');
          expect(draft.email, 'ada@example.com');
          expect(draft.brief, 'A note about the engine.');
          expect(draft.scope, ScopeOption.values.last);
          expect(draft.honeypot, 'Acme Corp');
        },
      );

      blocTest<ContactCubit, ContactState>(
        'reports a refused send and keeps every word of it',
        build: buildRefusingCubit,
        act: (cubit) async {
          cubit.fillRequiredFields();
          await cubit.submit();
        },
        skip: fillEmits,
        wait: settle,
        expect: () => [
          filledState(status: DispatchStatus.transmitting),
          filledState(status: DispatchStatus.failed, failure: DispatchFailure.mailer),
        ],
        verify: (cubit) {
          expect(cubit.state.brief, 'A note about the engine.');
          expect(cubit.state.status.blocksSubmit, isFalse);
        },
      );

      blocTest<ContactCubit, ContactState>(
        "carries the dispatcher's reason through, so the form can say which one it was",
        build: () => buildRefusingCubit(failure: DispatchFailure.rateLimited),
        act: (cubit) async {
          cubit.fillRequiredFields();
          await cubit.submit();
        },
        skip: fillEmits + 1,
        wait: settle,
        expect: () => [filledState(status: DispatchStatus.failed, failure: DispatchFailure.rateLimited)],
      );

      blocTest<ContactCubit, ContactState>(
        'drops the reason once the next attempt starts, rather than showing it under the spinner',
        build: () => buildRefusingCubit(failure: DispatchFailure.network),
        act: (cubit) async {
          cubit.fillRequiredFields();
          await cubit.submit();
          await cubit.submit();
        },
        skip: fillEmits + 2,
        wait: settle,
        expect: () => [
          filledState(status: DispatchStatus.transmitting),
          filledState(status: DispatchStatus.failed, failure: DispatchFailure.network),
        ],
      );

      blocTest<ContactCubit, ContactState>(
        'narrows the report as the visitor fills the fields it named',
        build: buildCubit,
        act: (cubit) async {
          await cubit.submit();
          cubit.updateName('Ada Lovelace');
          cubit.updateEmail('ada@example.com');
        },
        wait: settle,
        expect: () => [
          clearedState(status: DispatchStatus.idle).reporting(_everyFieldMissing),
          isA<ContactState>().having(
            (state) => state.problems.keys,
            'problems',
            [ContactField.email, ContactField.brief],
          ),
          isA<ContactState>().having(
            (state) => state.problems.keys,
            'problems',
            [ContactField.brief],
          ),
        ],
      );

      blocTest<ContactCubit, ContactState>(
        'a second press during the sequence does nothing',
        build: buildCubit,
        act: (cubit) async {
          cubit.fillRequiredFields();
          final first = cubit.submit();
          final second = cubit.submit();
          await Future.wait([first, second]);
        },
        skip: fillEmits + 1,
        wait: settle,
        expect: () => [
          clearedState(status: DispatchStatus.sent),
          clearedState(status: DispatchStatus.idle),
        ],
        verify: (_) => expect(dispatcher.sent, hasLength(1)),
      );
    });

    group('updateName', () {
      blocTest<ContactCubit, ContactState>(
        'suppresses the emit when the field is set to what it already held',
        build: buildCubit,
        act: (cubit) {
          cubit.updateName('Ada');
          cubit.updateName('Ada');
        },
        expect: () => [
          isA<ContactState>().having((state) => state.name, 'name', 'Ada'),
        ],
      );
    });

    group('updateScope', () {
      blocTest<ContactCubit, ContactState>(
        'emits the new selection',
        build: buildCubit,
        act: (cubit) => cubit.updateScope(ScopeOption.values.last),
        expect: () => [
          isA<ContactState>().having((state) => state.scope, 'scope', ScopeOption.values.last),
        ],
      );
    });

    group('updateHoneypot', () {
      blocTest<ContactCubit, ContactState>(
        'emits nothing — no one is looking at the trap',
        build: buildCubit,
        act: (cubit) => cubit.updateHoneypot('Acme Corp'),
        expect: () => const <ContactState>[],
      );
    });
  });
}
