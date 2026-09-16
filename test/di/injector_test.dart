import 'package:http/http.dart' as http;
import 'package:portfolio/data/clipboard.dart';
import 'package:portfolio/data/contact_dispatcher.dart';
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
      expect(getIt<http.Client>(), same(getIt<http.Client>()));
      expect(getIt<ContactDispatcher>(), same(getIt<ContactDispatcher>()));
    });

    test('points the dispatcher at the endpoint the content declares', () {
      final expected = Uri.base.resolve('/api/contact');

      expect(getIt<ContactDispatcher>(), isA<HttpContactDispatcher>());
      expect(expected.path, '/api/contact');
    });

    test('hands each copy button its own cubit', () {
      final heroCubit = getIt<CopyCubit>();
      final contactCardCubit = getIt<CopyCubit>();
      addTearDown(heroCubit.close);
      addTearDown(contactCardCubit.close);

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
