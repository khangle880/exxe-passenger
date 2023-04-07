import 'package:flutter/material.dart';
import 'dart:developer' show log;

import 'package:intl/intl.dart' show NumberFormat, DateFormat;

extension StringX on String {
  String capitalize() {
    if (length > 0) {
      return '${this[0].toUpperCase()}${substring(1)}';
    }
    return this;
  }

  String convertToCountryPhoneCode() {
    return replaceFirst('0', '+84 ');
  }

  bool isUpperCase() {
    final regExp = RegExp('[A-Z]');
    return regExp.hasMatch(this);
  }

  bool isSpecialCharacters() {
    return contains(RegExp(r'[\-=@,\.;]'));
  }

  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$|^\d{10,11}$')
        .hasMatch(this);
  }

  bool isValidPassword() {
    return RegExp(
            r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$')
        .hasMatch(this);
  }

  String convertPhone() {
    var phone = replaceRange(3, 3, ' ');
    phone = phone.replaceRange(7, 7, ' ');
    phone = phone.replaceRange(10, 10, ' ');
    return phone;
  }

  static String convertToCurrency(int money) {
    return NumberFormat.simpleCurrency(locale: 'vi').format(money);
  }

  static String formatDateTime(String dateTime) {
    DateTime tempDate = DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateTime);
    String date = DateFormat("HH:mm - dd.MM.yyyy").format(tempDate);
    return date;
  }

  static String formatTime(TimeOfDay time) {
    // ignore: prefer_interpolation_to_compose_strings
    String timeFM = (time.hour).toString() + ":" + (time.minute).toString();
    return timeFM;
  }

  static String formatDate(String dateTime) {
    DateTime tempDate = DateFormat("yyyy-MM-dd").parse(dateTime);
    String date = DateFormat("dd.MM.yyyy").format(tempDate);
    return date;
  }

  // static String formatDateAmPm(String dateTime){

  //    DateTime tempDate = DateFormat("yyyy-MM-dd hh:mm:ss").parse(dateTime);
  //    String date = DateFormat("hh:mm dd.MM.yyyy").format(tempDate);
  //    return date;
  // }
  static int getQualityCar(String star) {
    if (star == '1_star') {
      return 1;
    }
    if (star == '2_star') {
      return 2;
    }
    if (star == '3_star') {
      return 3;
    }
    if (star == '4_star') {
      return 4;
    }
    return 5;
  }

  static int convertStringDoubleToInt(String value) {
    return (double.parse(value)).toInt();
  }

  String get clearWhiteSpace => replaceAll(' ', '');

  String get withEllipse => replaceAll('', '\u{200B}');

  String replaceLast(String substring, String replacement) {
    int index = lastIndexOf(substring);
    if (index == -1) {
      return this;
    }
    return this.substring(0, index) +
        replacement +
        this.substring(index + substring.length);
  }

  Size getSize(TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: this, style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

// String get inCaps =>
//     this.isNotEmpty ? '${this[0].toUpperCase()}${this.substring(1)}' : '';
//
// String get capitalizeFirstOfEach =>
//     this.split(" ").map((str) => str.inCaps).join(" ");
//
// String get zipString => this
//     .replaceAll(RegExp(r'[^A-Za-z0-9]'), ' ')
//     .capitalizeFirstOfEach
//     .replaceAll(' ', '');
}

extension StringNullableExt on String? {
  String get safeText {
    if (this == null) {
      log(Exception("data is null").toString());
    }
    return this ?? "";
  }
}
