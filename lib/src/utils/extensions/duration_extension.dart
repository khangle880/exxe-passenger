extension DurationExt on Duration {
  // Add over top
  Duration operator +(Duration other) {
    return Duration(milliseconds: inMilliseconds + other.inMilliseconds);
  }

  Duration operator -(Duration other) {
    return Duration(milliseconds: inMilliseconds - other.inMilliseconds);
  }
}
