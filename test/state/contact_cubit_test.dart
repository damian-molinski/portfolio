import 'package:bloc_test/bloc_test.dart';
import 'package:portfolio/content/site_content.dart';
import 'package:portfolio/state/contact_cubit.dart';
import 'package:portfolio/state/contact_state.dart';
import 'package:test/test.dart';

extension on ContactCubit {
  /// Fills every required field, which is what the submit sequence needs before it will run.
  void fillRequiredFields() {
    for (final field in ContactField.values.where((field) => field.isRequired)) {
      updateField(field, 'something');
    }
  }
}

void main() {
  group(ContactCubit, () {
    ContactCubit buildCubit() => ContactCubit(
      transmitDuration: Duration.zero,
      confirmationDuration: Duration.zero,
    );

    test('starts empty, on the first scope, with nothing to report', () {
      final cubit = buildCubit();
      addTearDown(cubit.close);

      expect(cubit.state, ContactState.initial());
      expect(cubit.state.emptyRequiredFields, ContactField.values);
    });

    blocTest<ContactCubit, ContactState>(
      'rejects a submit with an empty required field without advancing the status',
      build: buildCubit,
      act: (cubit) => cubit.submit(),
      wait: const Duration(milliseconds: 10),
      expect: () => [ContactState.initial().copyWith(showValidationError: true)],
      verify: (cubit) => expect(cubit.state.status, DispatchStatus.idle),
    );

    blocTest<ContactCubit, ContactState>(
      'runs idle → transmitting → sent → idle and clears the form on the way',
      build: buildCubit,
      act: (cubit) {
        cubit.fillRequiredFields();
        cubit.submit();
      },
      skip: ContactField.values.length,
      wait: const Duration(milliseconds: 10),
      expect: () => [
        isA<ContactState>().having((s) => s.status, 'status', DispatchStatus.transmitting),
        ContactState.initial().copyWith(status: DispatchStatus.sent),
        ContactState.initial().copyWith(status: DispatchStatus.idle),
      ],
    );

    blocTest<ContactCubit, ContactState>(
      'a second submit during the sequence does nothing',
      build: buildCubit,
      act: (cubit) {
        cubit.fillRequiredFields();
        cubit.submit();
        cubit.submit();
      },
      skip: ContactField.values.length + 1,
      wait: const Duration(milliseconds: 10),
      expect: () => [
        ContactState.initial().copyWith(status: DispatchStatus.sent),
        ContactState.initial().copyWith(status: DispatchStatus.idle),
      ],
    );

    blocTest<ContactCubit, ContactState>(
      'value equality suppresses the emit when a field is set to what it already held',
      build: buildCubit,
      act: (cubit) {
        cubit.updateField(ContactField.name, 'Ada');
        cubit.updateField(ContactField.name, 'Ada');
      },
      expect: () => [
        ContactState.initial().copyWith(
          values: {...ContactState.initial().values, ContactField.name: 'Ada'},
        ),
      ],
    );

    blocTest<ContactCubit, ContactState>(
      'changing the scope emits the new selection',
      build: buildCubit,
      act: (cubit) => cubit.updateScope(ScopeOption.values.last),
      expect: () => [ContactState.initial().copyWith(scope: ScopeOption.values.last)],
    );
  });
}
