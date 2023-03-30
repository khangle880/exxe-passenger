import 'package:exxe/src/dependencies/widget_dependencies.dart';
import 'package:get_it/get_it.dart';

import '../app/app_state.dart';
import 'network_dependencies.dart';
import 'repo_dependencies.dart';
import 'chat_repo_dependencies.dart';

class AppDependencies {
  static GetIt get injector => GetIt.I;

  static Future<void> init() async {
    injector.registerLazySingleton<AppState>(() => AppState());
    await NetworkDependencies.setup(injector);
    await RepoDependencies.setup(injector);
    await WidgetDependencies.setup(injector);
    await ChatRepoDependencies.setup(injector);
  }
}
