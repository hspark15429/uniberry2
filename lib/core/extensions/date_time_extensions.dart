extension DateTimeExt on DateTime {
  String get timeAgo {
    final nowLocal = DateTime.now().toLocal();
    final timestampLocal = toLocal();
    final difference = nowLocal.difference(timestampLocal);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years年前';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$monthsヶ月前';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}日前';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}時間前';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}分前';
    } else {
      return 'now';
    }
  }
}
