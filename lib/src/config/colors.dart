import 'package:exxe/src/utils/extensions/color_extension.dart';
import 'package:flutter/material.dart';

class AppColors {
  AppColors._internal();

  //color app
  static const Color disable = Color(0xFF9D9D9D);

  //color text
  static const Color textError = Color(0xFFFF3B30);
  static const Color redxDF12 = Color(0xFFDF1212);
  static const Color redxDF3 = Color(0xFFFDF3F3);
  static const Color primaryTextButton = Color(0xFF0167FF);
  static const Color secondaryHintText = Color(0xFFC4C4C4);

  //button color
  static const Color primaryButton = Color(0xFF0167FF);
  static Color buttonDisable = const Color(0xFF0167FF) + primaryLightBlur60;

  //1. Primary Colors
  static Color primaryBlue05 = primaryBlueMain.withAlpha(5);
  static Color primaryBlue10 = primaryBlueMain.withAlpha(10);
  static Color primaryBlue20 = primaryBlueMain.withAlpha(20);
  static Color primaryBlue30 = primaryBlueMain.withAlpha(30);
  static Color primaryBlue40 = primaryBlueMain.withAlpha(40);
  static const Color primaryBlueMain = Color(0xFF573CFF);
  static Color primaryBlue60 = primaryBlueMain.withAlpha(60);
  static Color primaryBlue70 = primaryBlueMain.withAlpha(70);
  static Color primaryBlue80 = primaryBlueMain.withAlpha(80);
  static Color primaryBlue90 = primaryBlueMain.withAlpha(90);
  static Color primaryBlue95 = primaryBlueMain.withAlpha(95);

  //2. Secondary
  static Color primaryRed05 = primaryRedMain.withAlpha(5);
  static Color primaryRed10 = primaryRedMain.withAlpha(10);
  static Color primaryRed20 = primaryRedMain.withAlpha(20);
  static Color primaryRed30 = primaryRedMain.withAlpha(30);
  static Color primaryRed40 = primaryRedMain.withAlpha(40);
  static const Color primaryRedMain = Color(0xFFFF563C);
  static Color primaryRed60 = primaryRedMain.withAlpha(60);
  static Color primaryRed70 = primaryRedMain.withAlpha(70);
  static Color primaryRed80 = primaryRedMain.withAlpha(80);
  static Color primaryRed90 = primaryRedMain.withAlpha(90);
  static Color primaryRed95 = primaryRedMain.withAlpha(95);

  //Accent Colors
  //1. Red
  static Color accRed05 = accRedMain.withAlpha(5);
  static Color accRed10 = accRedMain.withAlpha(10);
  static Color accRed20 = accRedMain.withAlpha(20);
  static Color accRed30 = accRedMain.withAlpha(30);
  static Color accRed40 = accRedMain.withAlpha(40);
  static const Color accRedMain = Color(0xFFFF3B30);
  static Color accRed60 = accRedMain.withAlpha(60);
  static Color accRed70 = accRedMain.withAlpha(70);
  static Color accRed80 = accRedMain.withAlpha(80);
  static Color accRed90 = accRedMain.withAlpha(90);
  static Color accRed95 = accRedMain.withAlpha(95);

  //2. Organge
  static Color accOrgange05 = accOrgangeMain.withAlpha(5);
  static Color accOrgange10 = accOrgangeMain.withAlpha(10);
  static Color accOrgange20 = accOrgangeMain.withAlpha(20);
  static Color accOrgange30 = accOrgangeMain.withAlpha(30);
  static Color accOrgange40 = accOrgangeMain.withAlpha(40);

  static const Color accOrgangeMain = Color(0xFFED9526);
  static Color accOrgange60 = accOrgangeMain.withAlpha(60);
  static Color accOrgange70 = accOrgangeMain.withAlpha(70);
  static Color accOrgange80 = accOrgangeMain.withAlpha(80);
  static Color accOrgange90 = accOrgangeMain.withAlpha(90);
  static Color accOrgange95 = accOrgangeMain.withAlpha(95);

  //3. Secondary Green
  static Color accGreen05 = accGreenMain.withAlpha(5);
  static Color accGreen10 = accGreenMain.withAlpha(10);
  static Color accGreen20 = accGreenMain.withAlpha(20);
  static Color accGreen30 = accGreenMain.withAlpha(30);
  static Color accGreen40 = accGreenMain.withAlpha(40);
  static const Color accGreenMain = Color(0xFF1BB250);
  static Color accGreen60 = accGreenMain.withAlpha(60);
  static Color accGreen70 = accGreenMain.withAlpha(70);
  static Color accGreen80 = accGreenMain.withAlpha(80);
  static Color accGreen90 = accGreenMain.withAlpha(90);
  static Color accGreen95 = accGreenMain.withAlpha(95);

  //4. Secondary Blue
  static Color accBlue05 = accBlueMain.withAlpha(5);
  static Color accBlue10 = accBlueMain.withAlpha(10);
  static Color accBlue20 = accBlueMain.withAlpha(20);
  static Color accBlue30 = accBlueMain.withAlpha(30);
  static Color accBlue40 = accBlueMain.withAlpha(40);
  static const Color accBlueMain = Color(0xFF0167FF);
  static Color accBlue60 = accBlueMain.withAlpha(60);
  static Color accBlue70 = accBlueMain.withAlpha(70);
  static Color accBlue80 = accBlueMain.withAlpha(80);
  static Color accBlue90 = accBlueMain.withAlpha(90);
  static Color accBlue95 = accBlueMain.withAlpha(95);

  static const Color gray95 = Color(0xFF141414);
  static const Color gray90 = Color(0xFF0C0C0C);
  static const Color gray60 = Color(0xFF9D9D9D);
  static const Color secondaryMain = Color(0xFFFF563C);

  //color app
  /// 0xFFF8F8F8
  static const Color primaryDark = Color(0xFF272727);

  /// 0xFFFFFFFF
  static const Color white = Color(0xFFFFFFFF);
  static const Color primaryLight = Color(0xFFFFFFFF);

  /// 0xFFFFFFFF 95%
  static Color primaryLightBlur = const Color(0xFFFFFFFF).withOpacity(.95);

  static Color primaryLightBlur60 = const Color(0xFFFFFFFF).withOpacity(.60);

  static Color primaryLightBlur50 = const Color(0xFFFFFFFF).withOpacity(.50);

  static Color primaryLightBlur90 = const Color(0xFFFFFFFF).withOpacity(.90);

  /// 0xFFFAFAFA
  static const Color gray05 = Color(0xFFFAFAFA);

  /// 0xFFFAFAFA
  static const Color greyLight = Color(0xFFFAFAFA);

  static const Color success = Color.fromARGB(255, 87, 243, 56);

  /// 0xFF7963FF
  static const Color backgroundHome = Color(0xFF7963FF);

  //color text
  /// 0xFF272727
  static const Color primaryText = Color(0xFF272727);

  /// 0xFFFFFFFF
  static const Color textLight = Color(0xFFFFFFFF);

  /// 0xFFFF3B30
  static const Color utilRed = Color(0xFFFF3B30);

  /// 0xFFFF6F00
  static const Color secondaryTextButton = Color(0xFFFF563C);

  //4. Secondary Blue

  /// 0xFF573CFF
  static const Color primaryMain = Color(0xFF0167FF);

  /// 0xFF1B9AAA
  static const Color accent = Color(0xFF1B9AAA);

  /// 0xFF573CFF + 0xFFFFFFFF 95%
  static final Color primaryMainBlur =
      const Color(0xFF573CFF) + primaryLightBlur;

  /// 0xFF000000
  static const Color black = Color(0xFF000000);

  /// 0xFF060606
  static const Color gray95x06 = Color(0xFF060606);

  /// 0xFF141414
  static const Color gray95x14 = Color(0xFF141414);

  /// 0xFF0C0C0C
  static const Color gray90x0C = Color(0xFF0C0C0C);

  /// 0xFF272727
  static const Color gray90x27 = Color(0xFF272727);

  /// 0xFF4E4E4E
  static const Color gray80 = Color(0xFF4E4E4E);

  /// 0xFF767676
  static const Color gray70x76 = Color(0xFF2D2D2D);

  /// 0xFF767676
  static const Color gray70x3b = Color(0xFF2D2D2D);

  /// 0xFF525252
  static const Color gray60x52 = Color(0xFF525252);

  /// 0xFF9D9D9D
  static const Color gray60x9d = Color(0xFF2D2D2D);

  /// 0xFFC4C4C4
  static const Color gray50 = Color(0xFFC4C4C4);

  /// 0xFFD0D0D0
  static const Color gray40 = Color(0xFFD0D0D0);

  /// 0xFFDCDCDC
  static const Color gray30 = Color(0xFFDCDCDC);

  /// 0xFFE7E7E7
  static const Color gray20 = Color(0xFFE7E7E7);

  /// 0xFFF3F3F3
  static const Color gray10 = Color(0xFFF3F3F3);

  //5. Green
  static const Color greenMain = Color(0xFF22DF64);

  /// 0xFF1BB250
  static const Color green60 = Color(0xFF1BB250);

  /// 0xFFF4FDF7
  static const Color green05 = Color(0xFFF4FDF7);

  //6. Orange
  /// 0xFFFF6F00
  static const Color orangeMain = Color(0xFFFF6F00);

  /// 0xFFEFB447
  static const Color marigoldd40 = Color(0xFFEFB447);

  /// 0xFFED9526
  static const Color accOrange = Color(0xFFED9526);

  /// 0xFFFDF6E8
  static const Color marigold05 = Color(0xFFFDF6E8);

  /// 0xFFEFB447
  static const Color marigold40 = Color(0xFFEFB447);

  // shadow
  /// 0xFFA3A3A3 .1
  static Color shadowA3 = const Color(0xFFA3A3A3).withOpacity(0.1);

  /// 0xFF9B9B9B .1
  static Color shadow9b = const Color(0xFF9B9B9B).withOpacity(0.1);

  static Color moneyBoldColor =
      AppColors.primaryMain + AppColors.black.withOpacity(.4);
}
