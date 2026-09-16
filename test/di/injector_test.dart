import 'package:http/http.dart' as http;
import 'package:portfolio/data/repositories/site_content_repository.dart';
import 'package:portfolio/data/services/clipboard.dart';
import 'package:portfolio/data/services/contact_dispatcher.dart';
import 'package:portfolio/di/injector.dart';
import 'package:portfolio/ui/contact/view_model/contact_view_model.dart';
import 'package:portfolio/ui/copy_email/view_model/copy_view_model.dart';
import 'package:portfolio/ui/core/view_model/site_content_view_model.dart';
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
      expect(getIt<SiteContentViewModel>(), same(getIt<SiteContentViewModel>()));
      expect(getIt<http.Client>(), same(getIt<http.Client>()));
      expect(getIt<ContactDispatcher>(), same(getIt<ContactDispatcher>()));
    });

    test('points the dispatcher at the endpoint the content declares', () {
      final expected = Uri.base.resolve('/api/contact');

      expect(getIt<ContactDispatcher>(), isA<HttpContactDispatcher>());
      expect(expected.path, '/api/contact');
    });

    test('hands each copy button its own cubit', () {
      final heroCubit = getIt<CopyViewModel>();
      final contactCardCubit = getIt<CopyViewModel>();
      addTearDown(heroCubit.close);
      addTearDown(contactCardCubit.close);

      expect(heroCubit, isNot(same(contactCardCubit)));
    });

    test('hands each form its own cubit', () {
      final first = getIt<ContactViewModel>();
      final second = getIt<ContactViewModel>();
      addTearDown(first.close);
      addTearDown(second.close);

      expect(first, isNot(same(second)));
    });
  });
}
