import 'package:intl/intl.dart';

class DateFormatter {
  // Format as standard date: 2023-07-15
  static String formatDate(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  // Format as standard date and time: 2023-07-15 14:30
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }

  // Format as friendly date and time: Today 14:30, Yesterday 14:30, 2023-07-15 14:30
  static String formatFriendlyDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (date == today) {
      return 'Today ${DateFormat('HH:mm').format(dateTime)}';
    } else if (date == yesterday) {
      return 'Yesterday ${DateFormat('HH:mm').format(dateTime)}';
    } else {
      return formatDateTime(dateTime);
    }
  }

  // Format as relative time: Just now, 5 minutes ago, 1 hour ago, Yesterday, 3 days ago, 2023-07-15
  static String formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays < 2) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else {
      return formatDate(dateTime);
    }
  }

  // Format as post time: same as formatTimeAgo
  static String formatPostTime(DateTime dateTime) {
    return formatTimeAgo(dateTime);
  }

  // Format as chat time: show time for today, "Yesterday" for yesterday, date for others
  static String formatChatTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (date == today) {
      return DateFormat('HH:mm').format(dateTime);
    } else if (date == yesterday) {
      return 'Yesterday';
    } else {
      return DateFormat('MM-dd').format(dateTime);
    }
  }

  // Format as detailed date and time: Saturday, July 15, 2023 14:30
  static String formatDetailDateTime(DateTime dateTime) {
    return DateFormat('EEEE, MMMM d, yyyy HH:mm').format(dateTime);
  }

  // Format as month and day: July 15
  static String formatMonthDay(DateTime dateTime) {
    return DateFormat('MMMM d').format(dateTime);
  }

  // Format as year and month: July 2023
  static String formatYearMonth(DateTime dateTime) {
    return DateFormat('MMMM yyyy').format(dateTime);
  }

  // Calculate difference between two dates (in days)
  static int daysBetween(DateTime from, DateTime to) {
    final fromDate = DateTime(from.year, from.month, from.day);
    final toDate = DateTime(to.year, to.month, to.day);
    return (toDate.difference(fromDate).inHours / 24).round();
  }

  // Format as duration: 1 hour 30 minutes
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '$hours ${hours == 1 ? 'hour' : 'hours'}${minutes > 0 ? ' $minutes ${minutes == 1 ? 'minute' : 'minutes'}' : ''}';
    } else if (minutes > 0) {
      return '$minutes ${minutes == 1 ? 'minute' : 'minutes'}${seconds > 0 ? ' $seconds ${seconds == 1 ? 'second' : 'seconds'}' : ''}';
    } else {
      return '$seconds ${seconds == 1 ? 'second' : 'seconds'}';
    }
  }

  // Format as audio duration: 01:30
  static String formatAudioDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  // Parse string to date and time
  static DateTime? parseDateTime(String dateTimeString) {
    try {
      return DateFormat('yyyy-MM-dd HH:mm').parse(dateTimeString);
    } catch (e) {
      return null;
    }
  }

  // Parse string to date
  static DateTime? parseDate(String dateString) {
    try {
      return DateFormat('yyyy-MM-dd').parse(dateString);
    } catch (e) {
      return null;
    }
  }
} 