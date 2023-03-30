import 'package:exxe/src/utils/export/ui_export.dart';
import 'package:intl/intl.dart';

extension NumExt on num {
  // String get getTimeFromMinute {
  //   if (this < 60) {
  //     return "${toString()} phút";
  //   } else {
  //     return "${this ~/ 60}h${remainder(60)}";
  //   }
  // }

  int get hourToMilliseconds => (this * 60 * 60 * 1000).ceil();

  String get getTimeFromHours {
    var minute = this * 60;
    if (minute < 60) return "${minute.round()} phút";
    return "${(minute ~/ 60)} giờ ${(minute.remainder(60).round())} phút";
  }

  String get getTimeFromHoursShort {
    var minute = this * 60;
    if (minute < 60) return "${minute.toString().padLeft(2, "0")}m";
    return "${(minute ~/ 60).toString().padLeft(2, "0")}h${(minute.remainder(60).round()).toString().padLeft(2, "0")}";
  }

  String get durationFormat =>
      toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '');

  num roundUp(num multiple) {
    if (multiple == 0) {
      return this;
    }
    return (this / multiple).ceil() * multiple;
  }
}

extension IntExt on int {
  String get currencyFormat {
    return NumberFormat.simpleCurrency(locale: 'vi').format(this);
  }

  String get thousandFormat => toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => "${m[1]}.");

  bool canPay() {
    return this <= PaymentLimit.max && this >= PaymentLimit.min;
  }
}
