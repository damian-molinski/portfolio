import 'package:bloc/bloc.dart';

import '../../../data/repositories/site_content_repository.dart';
import 'home_state.dart';

final class HomeViewModel extends Cubit<HomeState> {
  HomeViewModel(SiteContentRepository repository)
    : super(
        HomeState.from(repository.load()),
      );
}
