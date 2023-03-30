import 'package:change_case/change_case.dart';
import 'package:intl/intl.dart';

extension ServerMapExt<K, V> on Map<K, V> {
  Map<K, V> get getCleanNull =>
      this..removeWhere((key, value) => value == null);
}

extension ServerEnumExt on Enum {
  String get shortString {
    return toString().split('.').last;
  }

  String get serverString => shortString.toSnakeCase();
}

extension ServerDateTimeExt on DateTime {
  String get serverFormat => DateFormat("yyyy-MM-dd HH:mm:ss").format(toUtc());

  String get serverFormatOnlyDate => DateFormat("yyyy-MM-dd").format(this);
}

extension ServerNumExt on num {
  String get getWaitHour => "${ceil().toString().padLeft(2, '0')}_hour";
}
