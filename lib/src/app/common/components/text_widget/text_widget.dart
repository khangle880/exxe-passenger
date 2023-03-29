import 'package:exxe/src/config/colors.dart';
import 'package:exxe/src/config/diments.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class TextWidget extends Text {
  TextWidget({
    Key? key,
    required String text,
    Color colorText = AppColors.primaryText,
    int maxLine = 1,
    TextAlign textAlign = TextAlign.left,
    FontWeight weight = FontWeight.w400,
    TextDecoration textDecoration = TextDecoration.none,
    FontStyle fontStyle = FontStyle.normal,
    double fontSize = AppDimens.text14,
  }) : super(
          text,
          key: key,
          style: GoogleFonts.nunitoSans(
            color: colorText,
            fontSize: fontSize,
            fontWeight: weight,
            decoration: textDecoration,
            fontStyle: fontStyle,
          ),
          maxLines: maxLine,
          textAlign: textAlign,
          overflow: TextOverflow.ellipsis,
        );
}
