import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<Notification> notifications = dummyNotifications;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('알림'),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Dismissible(
            key: Key(notification.message),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              setState(() {
                notifications.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('알림이 삭제되었습니다.')),
              );
            },
            background: Container(
              alignment: Alignment.centerRight,
              color: Colors.red,
              child: Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Icon(Icons.delete, color: Colors.white),
              ),
            ),
            child: ListTile(
              title: Text(
                notification.message,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Text(
                notification.time,
                style: TextStyle(fontSize: 12.0),
              ),
            ),
          );
        },
      ),
    );
  }
}

class Notification {
  final String message;
  final String time;

  Notification({
    required this.message,
    required this.time,
  });
}

final List<Notification> dummyNotifications = [
  Notification(
    message: '[system] Uniberry 2.0 안내',
    time: '2024.03.25',
  ),
  Notification(
    message: '[学生支援] 댓글이 달렸습니다.',
    time: '2024.03.11',
  ),
  Notification(
    message: '[개학 시기 안내] 4월 7일에 개학 예정입니다.',
    time: '2024.04.07',
  ),
  Notification(
    message: '[기숙사 안내] 기숙사 입사일이 변경되었습니다.',
    time: '2024.04.15',
  ),
  Notification(
    message: '[식당 운영 안내] 식당 영업 시간이 변경되었습니다.',
    time: '2024.04.01',
  ),
];
