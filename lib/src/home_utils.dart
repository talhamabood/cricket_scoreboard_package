import 'package:intl/intl.dart';

class HomeUtils{
  double calculateCurrentRunRate(int runsScored, double oversFaced) {
    if (oversFaced == 0) return 0.0; // Avoid division by zero
    return runsScored / oversFaced;
  }

  double calculateRequiredRunRate(int targetRuns, int runsScored, int totalOvers, double oversFaced) {
    double oversRemaining = totalOvers - oversFaced;
    if (oversRemaining <= 0) return 0.0; // Avoid division by zero
    return (targetRuns - runsScored) / oversRemaining;
  }

  String formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays >= 1) {
      // Extract the day with suffix and format the rest
      String dayWithSuffix = '${dateTime.day}${getDaySuffix(dateTime.day)}';
      String formattedDate = DateFormat('MMMM yyyy').format(dateTime);
      return '$dayWithSuffix $formattedDate';
    } else if (difference.inHours >= 1) {
      // Show hours ago
      return '${difference.inHours} hrs ago';
    } else if (difference.inMinutes >= 1) {
      // Show minutes ago
      return '${difference.inMinutes} mins ago';
    } else {
      // Show seconds ago
      return 'Just now';
    }
  }

  String getDaySuffix(int day) {
    if (day >= 11 && day <= 13) return 'th'; // Special case for 11th-13th
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
  // Helper to extract YouTube video ID
  String? extractYouTubeVideoId(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return null;

    // Check for different URL patterns.
    if (uri.host.contains('youtube.com')) {
      return uri.queryParameters['v'];
    } else if (uri.host.contains('youtu.be')) {
      return uri.pathSegments.isNotEmpty ? uri.pathSegments[0] : null;
    } else if (uri.host.contains('youtube.com') &&
        uri.path.contains('/shorts/')) {
      return uri.pathSegments.length > 1 ? uri.pathSegments[1] : null;
    } else {
      return null;
    }
  }
}