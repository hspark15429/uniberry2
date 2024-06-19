extension DateTimeExt on DateTime {
  String get timeAgo {
    final nowLocal = DateTime.now().toLocal();
    final timestampLocal = toLocal();
    final difference = nowLocal.difference(timestampLocal);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years년 전';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months달 전';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}일 전';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}시간 전';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}분 전';
    } else {
      return 'now';
    }
  }

  String get postCreatedAtFormatted {
    final timestampLocal = toLocal();

    return DateTime.fromMillisecondsSinceEpoch(
            timestampLocal.millisecondsSinceEpoch * 1000 * 1000)
        .toString()
        .substring(0, 16);
  }
}
