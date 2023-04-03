import 'package:exxe/src/utils/export/ui_export.dart';
import 'package:google_fonts/google_fonts.dart';

class AppStyles {
  //Text Family
  /// if color wrong => recheck
  static final TextStyle _kNunitoSans =
      GoogleFonts.nunitoSans(color: AppColors.gray95x14);
  static final TextStyle _kNunito =
      GoogleFonts.nunito(color: AppColors.gray95x14);

  //Text Weight
  //NunitoSans
  static final TextStyle _kNunitoSansw700 =
      _kNunitoSans.copyWith(fontWeight: FontWeight.w700);
  static final TextStyle _kNunitoSansw600 =
      _kNunitoSans.copyWith(fontWeight: FontWeight.w600);
  static final TextStyle _kNunitoSansw500 =
      _kNunitoSans.copyWith(fontWeight: FontWeight.w500);
  static final TextStyle _kNunitoSansw400 =
      _kNunitoSans.copyWith(fontWeight: FontWeight.w400);

  //Nunito
  static final TextStyle _kNunitosw600 =
      _kNunito.copyWith(fontWeight: FontWeight.w600);
  static final TextStyle _kNunitosw700 =
      _kNunito.copyWith(fontWeight: FontWeight.w600);
  static final TextStyle _kNunitosw500 =
      _kNunito.copyWith(fontWeight: FontWeight.w500);
  static final TextStyle _kNunitosw400 =
      _kNunito.copyWith(fontWeight: FontWeight.w400);

  //Text size
  static final TextStyle s28w7 =
      _kNunitoSansw700.copyWith(fontSize: AppDimens.text28);
  static final TextStyle s24w7 =
      _kNunitoSansw700.copyWith(fontSize: AppDimens.text24);
  static final TextStyle s20w6 =
      _kNunitoSansw600.copyWith(fontSize: AppDimens.text20);
  static final TextStyle s21w7 =
      _kNunitoSansw700.copyWith(fontSize: AppDimens.text21);
  static final TextStyle s21w6 =
      _kNunitoSansw600.copyWith(fontSize: AppDimens.text21);
  static final TextStyle s24w6 =
      _kNunitoSansw600.copyWith(fontSize: AppDimens.text24);
  static final TextStyle s18w7 =
      _kNunitosw700.copyWith(fontSize: AppDimens.text18);
  static final TextStyle s18w6 =
      _kNunitosw600.copyWith(fontSize: AppDimens.text18);
  static final TextStyle s18w5 =
  _kNunitosw500.copyWith(fontSize: AppDimens.text18);
  static final TextStyle s18w4 =
      _kNunitosw400.copyWith(fontSize: AppDimens.text18);
  static final TextStyle s17w6 =
      _kNunitoSansw600.copyWith(fontSize: AppDimens.text17);
  static final TextStyle s16w7 =
      _kNunitoSansw700.copyWith(fontSize: AppDimens.text16);
  static final TextStyle s16w6 =
      _kNunitosw600.copyWith(fontSize: AppDimens.text16);
  static final TextStyle s16w5 =
      _kNunitosw500.copyWith(fontSize: AppDimens.text16);
  static final TextStyle s16w4 =
      _kNunitosw400.copyWith(fontSize: AppDimens.text14);
  static final TextStyle s15w7 =
      _kNunitoSansw700.copyWith(fontSize: AppDimens.text15);
  static final TextStyle s15w6 =
      _kNunitoSansw600.copyWith(fontSize: AppDimens.text15);
  static final TextStyle s15w4 =
      _kNunitoSansw400.copyWith(fontSize: AppDimens.text15);
  static final TextStyle s15w5 =
      _kNunitoSansw500.copyWith(fontSize: AppDimens.text15);
  static final TextStyle s14w7 =
      _kNunitoSansw700.copyWith(fontSize: AppDimens.text14);
  static final TextStyle s14w6 =
      _kNunitosw600.copyWith(fontSize: AppDimens.text14);
  static final TextStyle s14w5 =
      _kNunitosw500.copyWith(fontSize: AppDimens.text14);
  static final TextStyle s14w4 =
      _kNunitoSansw400.copyWith(fontSize: AppDimens.text14);
  static final TextStyle s13w6 =
      _kNunitoSansw600.copyWith(fontSize: AppDimens.text13);
  static final TextStyle s12w7 =
      _kNunitoSansw700.copyWith(fontSize: AppDimens.text12);
  static final TextStyle s12w6 =
      _kNunitoSansw600.copyWith(fontSize: AppDimens.text12);
  static final TextStyle s12w5 =
      _kNunitoSansw500.copyWith(fontSize: AppDimens.text12);
  static final TextStyle s12w4 =
      _kNunitoSansw400.copyWith(fontSize: AppDimens.text12);
  static final TextStyle s11w4 =
      _kNunitoSansw400.copyWith(fontSize: AppDimens.text10);
  static final TextStyle s10w6 =
      _kNunitoSansw600.copyWith(fontSize: AppDimens.text10);
  static final TextStyle s10w5 =
      _kNunitoSansw500.copyWith(fontSize: AppDimens.text10);
  static final TextStyle s10w4 =
      _kNunitoSansw400.copyWith(fontSize: AppDimens.text10);

  static BorderRadius border10 = const BorderRadius.all(Radius.circular(10.0));
  static BorderRadius border12 = const BorderRadius.all(Radius.circular(12.0));
  static BorderRadius border8 = const BorderRadius.all(Radius.circular(8.0));
  static BorderRadius border5 = const BorderRadius.all(Radius.circular(5.0));
  static BorderRadius border15 = const BorderRadius.all(Radius.circular(15.0));
  static BorderRadius border20 = const BorderRadius.all(Radius.circular(20.0));
  static BoxDecoration pinputUnderline = BoxDecoration(
    color: AppColors.primaryLight,
    border: Border(
      bottom: BorderSide(
        color: AppColors.primaryButton.withAlpha(100),
      ),
    ),
  );
  static BorderRadius borderBottom30LeftRight = const BorderRadius.only(
    bottomLeft: Radius.circular(30.0),
    bottomRight: Radius.circular(30.0),
  );
  static BorderRadius borderBottom15LeftRight = const BorderRadius.only(
    bottomLeft: Radius.circular(15.0),
    bottomRight: Radius.circular(15.0),
  );
  static BorderRadius borderTop20LeftRight = const BorderRadius.only(
    topLeft: Radius.circular(20.0),
    topRight: Radius.circular(20.0),
  );
  static BorderRadius borderLeft20TopLeftBottomLeft = const BorderRadius.only(
    topLeft: Radius.circular(20.0),
    bottomLeft: Radius.circular(20.0),
  );

  static FontWeight fontWeightW100 = FontWeight.w100;
  static FontWeight fontWeightW200 = FontWeight.w200;
  static FontWeight fontWeightW300 = FontWeight.w300;
  static FontWeight fontWeightW400 = FontWeight.w400;
  static FontWeight fontWeightW500 = FontWeight.w500;
  static FontWeight fontWeightW600 = FontWeight.w600;
  static FontWeight fontWeightW700 = FontWeight.w700;
  static FontWeight fontWeightW800 = FontWeight.w800;
  static FontWeight fontWeightW900 = FontWeight.w900;
  static FontWeight fontWeightBold = FontWeight.bold;
  static FontWeight fontWeightNormal = FontWeight.normal;
}

extension TextStyleExt on TextStyle {
  TextStyle withColor(Color? color) => copyWith(color: color);
}
