import 'package:intl/intl.dart';

/// Date and time formatting utility for MediRx Patient
class DateFormatter {
  DateFormatter._();

  static final DateFormat _defaultDateFormat = DateFormat('dd MMM yyyy');
  static final DateFormat _timeFormat = DateFormat('hh:mm a');
  static final DateFormat _dateTimeFormat = DateFormat('dd MMM yyyy, hh:mm a');
  static final DateFormat _isoDateFormat = DateFormat('yyyy-MM-dd');

  /// Format as "28 Oct 2026"
  static String formatDate(DateTime? date) {
    if (date == null) return '';
    return _defaultDateFormat.format(date);
  }

  /// Format as "12:30 PM"
  static String formatTime(DateTime? date) {
    if (date == null) return '';
    return _timeFormat.format(date);
  }

  /// Format as "28 Oct 2026, 12:30 PM"
  static String formatDateTime(DateTime? date) {
    if (date == null) return '';
    return _dateTimeFormat.format(date);
  }

  /// Format as "2026-10-28" for API payloads
  static String formatToIsoDate(DateTime? date) {
    if (date == null) return '';
    return _isoDateFormat.format(date);
  }

  /// Parse ISO string or return null
  static DateTime? parseIso(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return null;
    try {
      return DateTime.parse(dateStr);
    } catch (_) {
      return null;
    }
  }

  /// Return human friendly relative time (e.g. "Today", "Yesterday", "2 days ago")
  static String getRelativeTime(DateTime? date) {
    if (date == null) return '';
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return formatDate(date);
    }
  }
}
