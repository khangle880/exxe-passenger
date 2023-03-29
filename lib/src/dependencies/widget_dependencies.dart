import 'package:get_it/get_it.dart';

import '../app/common/widgets/support_button.dart';

class WidgetDependencies {
  static Future setup(GetIt injector) async {
    injector.registerSingleton<SupportButton>(const SupportButton());
  }
}
