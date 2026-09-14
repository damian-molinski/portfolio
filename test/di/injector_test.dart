import 'package:portfolio/data/clipboard.dart';
import 'package:portfolio/data/site_content_repository.dart';
import 'package:portfolio/di/injector.dart';
import 'package:portfolio/state/contact_cubit.dart';
import 'package:portfolio/state/copy_cubit.dart';
import 'package:portfolio/state/site_content_cubit.dart';
import 'package:test/test.dart';

void main() {
  group('configureDependencies', () {
    setUp(configureDependencies);
    tearDown(getIt.reset);

    test('is idempotent, so a hot reload cannot throw on a duplicate registration', () {
      expect(configureDependencies, returnsNormally);
    });

    test('registers the stateless collaborators as singletons', () {
      expect(getIt<SiteContentRepository>(), same(getIt<SiteContentRepository>()));
      expect(getIt<Clipboard>(), same(getIt<Clipboard>()));
      expect(getIt<SiteContentCubit>(), same(getIt<SiteContentCubit>()));
    });

    test('hands each copy button its own cubit', () {
      final heroCubit = getIt<CopyCubit>();
      final contactCardCubit = getIt<CopyCubit>();
      addTearDown(heroCubit.close);
      addTearDown(contactCardCubit.close);

      // A singleton here would make both buttons confirm on a single click.
      expect(heroCubit, isNot(same(contactCardCubit)));
    });

    test('hands each form its own cubit', () {
      final first = getIt<ContactCubit>();
      final second = getIt<ContactCubit>();
      addTearDown(first.close);
      addTearDown(second.close);

      expect(first, isNot(same(second)));
    });
  });
}
