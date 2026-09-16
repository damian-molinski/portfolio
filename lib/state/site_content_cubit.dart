import 'package:bloc/bloc.dart';

import '../data/site_content_repository.dart';
import 'site_content_state.dart';

final class SiteContentCubit extends Cubit<SiteContentState> {
  SiteContentCubit(SiteContentRepository repository) : super(SiteContentState(repository.load()));
}
