import 'package:intl/intl.dart';

class UpcomingDetailMatchUtils{
  String formatApiTime(String apiTime) {

    // Parse the time
    DateTime parsedTime = DateFormat("HH:mm:ss").parse(apiTime);

    // Format the time
    String formattedTime = DateFormat("h:mm a").format(parsedTime);

    // Append the time zone abbreviation
    String finalTime = formattedTime;

    print(finalTime); // Output: 7:00 PM EST

    return finalTime;
  }

  String _getDaySuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  String formatApiDate(String apiDate) {
    // Parse the date
    DateTime parsedDate = DateTime.parse(apiDate);

    // Format the date
    String formattedDate = DateFormat("d MMM y").format(parsedDate);

    // Add suffix to the day
    String dayWithSuffix = '${parsedDate.day}${_getDaySuffix(parsedDate.day)}';

    // Replace the day in the formatted string
    formattedDate =
        formattedDate.replaceFirst('${parsedDate.day}', dayWithSuffix);

    print(formattedDate); // Output: Friday, 1st September 2022
    return formattedDate;
  }
}