
class ConvertUtil {

  static String convertToLatitudeLongitudeFormat(double value,
      {bool isLongitude = false}) {
    int degree = value.toInt();

    double minutesDecimal = (value - degree).abs() * 60;
    int minutes = minutesDecimal.toInt();

    double seconds = (minutesDecimal - minutes).abs() * 60;
    String secondsString = seconds.toStringAsFixed(2);

    if (value >= 0) {
      return isLongitude
          ? "$degree°$minutes'$secondsString\"E"
          : "$degree°$minutes'$secondsString\"N";
    }
    return isLongitude
        ? "${degree.abs()}°$minutes'$secondsString\"W"
        : "${degree.abs()}°$minutes'$secondsString\"S";
  }
}