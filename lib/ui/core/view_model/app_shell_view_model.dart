import 'package:bloc/bloc.dart';

import '../../../data/repositories/site_content_repository.dart';
import 'app_shell_state.dart';

final class AppShellViewModel extends Cubit<AppShellState> {
  AppShellViewModel(SiteContentRepository repository)
    : super(
        AppShellState.from(repository.load()),
      );
}
