import './num_extension.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension DateTimeExt on DateTime {
  String toFormat(String format, {String? locale}) =>
      DateFormat(format, locale).format(toLocal());

  String get getDateString => toFormat('dd.MM.yyyy');

  String get getDateTimeString => toFormat('HH:mm - dd.MM.yyyy');

  String get dayOfWeek {
    int day = this.day;
    int month = this.month;
    int year = this.year;

    int a = (14 - month) ~/ 12;
    int y = year - a;
    int m = month + 12 * a - 2;
    int dateOfWeek =
        (day + y + y ~/ 4 - y ~/ 100 + y ~/ 400 + (31 * m) ~/ 12) % 7;
    if (dateOfWeek == 0) {
      return 'Chủ nhật';
    }
    if (dateOfWeek == 1) {
      return 'Thứ 2';
    }
    if (dateOfWeek == 2) {
      return 'Thứ 3';
    }
    if (dateOfWeek == 3) {
      return 'Thứ 4';
    }
    if (dateOfWeek == 4) {
      return 'Thứ 5';
    }
    if (dateOfWeek == 5) {
      return 'Thứ 6';
    }

    return 'Thứ 7';
  }

  DateTime get date {
    return DateUtils.dateOnly(this);
  }

  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  Duration get time {
    return Duration(
        hours: hour,
        minutes: minute,
        seconds: second,
        milliseconds: millisecond,
        microseconds: microsecond);
  }

  String get logFbFormat => toFormat('HH dd mm yyyy');

  DateTime getCanReturnMin(
      {required num distance, required num maxDistanceInDay}) {
    final days = distance / maxDistanceInDay;
    final hours = days.roundUp(0.5) * 24;
    return add(Duration(hours: hours.ceil()));
  }
}
