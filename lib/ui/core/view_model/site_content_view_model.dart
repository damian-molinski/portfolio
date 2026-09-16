import 'package:bloc/bloc.dart';

import '../../../data/repositories/site_content_repository.dart';
import 'site_content_state.dart';

final class SiteContentViewModel extends Cubit<SiteContentState> {
  SiteContentViewModel(SiteContentRepository repository) : super(SiteContentState(repository.load()));
}
