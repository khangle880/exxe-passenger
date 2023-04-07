import 'dart:developer';

import 'package:change_case/change_case.dart';
import 'extensions/extensions.dart';

T? safeParse<T>(dynamic data, {dynamic payload}) {
  if (T == bool || data == null) {
    return data;
  }
  if (T == DateTime) {
    try {
      return DateTime.parse(data.toString()) as T;
    } catch (e) {
      return null;
    }
  }
  if ((T == num || T == int || T == double) && data is String) {
    var text = data;
    if (data.contains("_hour")) {
      text = text.split('_')[0];
    }
    try {
      return int.parse(text) as T;
    } catch (e) {
      try {
        return double.parse(text) as T;
      } catch (e) {
        log(e.toString());
        return null;
      }
    }
  }

  if (payload is List<Enum>) {
    try {
      return payload.firstWhere((element) =>
          data.toString().toCamelCase().toLowerCase() ==
          element.shortString.toLowerCase()) as T;
    } catch (e) {
      return null;
    }
  }
  if (T == Map && data.runtimeType != Map) return null;

  if (data == false) return null;

  try {
    final result = data as T;
    return result;
  } catch (e, stackTrace) {
    log(e.toString() + stackTrace.toString());
    return null;
  }
}
