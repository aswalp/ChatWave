import 'package:flutter/material.dart';

class MyDateTime {
  static String getFormatedTime(
      {required BuildContext context, required String time}) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(date).format(context);
  }

  static String getLastMessageTime(
      {required BuildContext context,
      required String sent,
      bool showyear = false}) {
    final DateTime senttime =
        DateTime.fromMillisecondsSinceEpoch(int.parse(sent));
    final DateTime now = DateTime.now();
    if (now.day == senttime.day &&
        now.month == senttime.month &&
        now.year == senttime.year) {
      return TimeOfDay.fromDateTime(senttime).format(context);
    }

    return showyear
        ? '${senttime.day} ${getmonth(senttime)}  ${senttime.year}'
        : '${senttime.day} ${getmonth(senttime)} ';
  }

  static String getmonth(DateTime data) {
    switch (data.month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
    }
    return "NA";
  }

  static String getactiveTime(
      {required BuildContext context, required String activetime}) {
    final i = int.tryParse(activetime) ?? -1;

    if (i == -1) {
      return 'last Seen not avaible';
    }

    final DateTime time = DateTime.fromMillisecondsSinceEpoch(i);
    final formattedtime = TimeOfDay.fromDateTime(time).format(context);
    final DateTime now = DateTime.now();
    if (now.day == time.day &&
        now.month == time.month &&
        now.year == time.year) {
      return "Last seen today at $formattedtime ";
    }
    if ((now.difference(time).inHours / 24).round() == 1) {
      return "Last seen Yesterday at $formattedtime ";
    }
    String month = getmonth(time);
    return 'Last seen on ${time.day} $month on $formattedtime  ';
  }

  //?to show read and sent time

  static String getmessagetime(
      {required BuildContext context, required String time}) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final now = DateTime.now();
    final formatedtime = TimeOfDay.fromDateTime(date).format(context);

    if (now.day == date.day &&
        now.month == date.month &&
        now.year == date.year) {
      return "$formatedtime ";
    }
    return now.year == date.year
        ? '$formatedtime-${date.day} ${getmonth(date)}'
        : '$formatedtime-${date.day} ${getmonth(date)} ${date.year}';
  }
}
