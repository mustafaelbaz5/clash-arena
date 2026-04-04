extension DateTimeExt on DateTime {
  String get formattedDate =>
      '${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$year';

  String get formattedTime =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

  String get formattedDateTime => '$formattedDate $formattedTime';

  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  String get timeAgo {
    final diff = DateTime.now().difference(this);
    if (diff.inDays > 365) return _plural(diff.inDays ~/ 365, 'year');
    if (diff.inDays > 30) return _plural(diff.inDays ~/ 30, 'month');
    if (diff.inDays > 0) return _plural(diff.inDays, 'day');
    if (diff.inHours > 0) return _plural(diff.inHours, 'hour');
    if (diff.inMinutes > 0) return _plural(diff.inMinutes, 'minute');
    return 'Just now';
  }

  String _plural(final int value, final String unit) =>
      '$value $unit${value == 1 ? '' : 's'} ago';
}
