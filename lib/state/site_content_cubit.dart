import 'package:bloc/bloc.dart';

import '../data/site_content_repository.dart';
import 'site_content_state.dart';

/// Hands the site's copy to the tree.
///
/// It emits once, in its constructor, and never again. On a `mode: static` build the sections it
/// feeds are rendered during `jaspr build` and frozen into HTML, so there is no second state for
/// them to receive; the cubit exists so that every section reads its copy the same way the two
/// hydrated islands do.
final class SiteContentCubit extends Cubit<SiteContentState> {
  SiteContentCubit(SiteContentRepository repository) : super(SiteContentLoaded(repository.load()));
}
