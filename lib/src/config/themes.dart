import 'package:exxe/src/utils/export/ui_export.dart';

class AppThemes {
  static ThemeData themeLights = ThemeData(
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      backgroundColor: AppColors.greyLight,
    ),
    fontFamily: "NunitoSans",
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    primaryColor: AppColors.primaryText,
    primaryColorLight: AppColors.textLight,
    scaffoldBackgroundColor: AppColors.greyLight,
    splashColor: Colors.transparent,
    disabledColor: AppColors.gray60x9d,
    indicatorColor: AppColors.primaryMain,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    primaryColorDark: AppColors.primaryMain,
    canvasColor: Colors.transparent,
  );
}
