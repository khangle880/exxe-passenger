class DateTimeFormat {
  static String getDayOfWeek(DateTime date) {
    int day = date.day;
    int month = date.month;
    int year = date.year;

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

  
}
