import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';


class LectureSchedulePage extends StatefulWidget {
  @override
  _LectureSchedulePageState createState() => _LectureSchedulePageState();
}

class _LectureSchedulePageState extends State<LectureSchedulePage> {
  late Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents = [];
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.utc(2024, 4, 1);
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _events = {
  DateTime.utc(2024, 4, 1): [{ 'event': 'オリテ'}],
  DateTime.utc(2024, 4, 2): [{ 'event': '入学式'}],
  DateTime.utc(2024, 4, 3): [{ 'event': 'オリテ'}],
  DateTime.utc(2024, 4, 4): [{'event': 'オリテ'}],
  DateTime.utc(2024, 4, 5): [{'class': '授業日', 'number': 1}],


  DateTime.utc(2024, 4, 8): [{'class': '授業日', 'number': 1}],
  DateTime.utc(2024, 4, 9): [{'class': '授業日', 'number': 1}],
  DateTime.utc(2024, 4, 10): [{'class': '授業日','number': 1}],
  DateTime.utc(2024, 4, 11): [{'class': '授業日', 'number': 1}],
  DateTime.utc(2024, 4, 12): [{'class': '授業日', 'number': 1}],

  DateTime.utc(2024, 4, 15): [{'class': '授業日', 'number': 2}],
  DateTime.utc(2024, 4, 16): [{'class': '授業日','number': 2}],
  DateTime.utc(2024, 4, 17): [{'class': '授業日', 'number': 2}],
  DateTime.utc(2024, 4, 18): [{'class': '授業日', 'number': 2}],
  DateTime.utc(2024, 4, 19): [{'class': '授業日', 'number': 2}],

  DateTime.utc(2024, 4, 22): [{'class': '授業日', 'number': 3}],
  DateTime.utc(2024, 4, 23): [{'class': '授業日', 'number': 3}],
  DateTime.utc(2024, 4, 24): [{'class': '授業日', 'number': 3}],
  DateTime.utc(2024, 4, 25): [{'class': '授業日', 'number': 3}],
  DateTime.utc(2024, 4, 26): [{'class': '授業日','number': 3}],
  DateTime.utc(2024, 4, 29): [{'class': '授業日', 'number': 4}],
  DateTime.utc(2024, 4, 30): [{'class': '授業日', 'number': 4}],

DateTime.utc(2024, 5, 1): [{'class': '授業日', 'number': 4}],
DateTime.utc(2024, 5, 2): [{'class': '授業日', 'number': 4}],
DateTime.utc(2024, 5, 7): [{'class': '授業日', 'number': 5}],
DateTime.utc(2024, 5, 8): [{'class': '授業日', 'number': 5}],
DateTime.utc(2024, 5, 9): [{'class': '授業日', 'number': 5}],
DateTime.utc(2024, 5, 10): [{'class': '授業日', 'number': 5}],
DateTime.utc(2024, 5, 13): [{'class': '授業日', 'number': 5}],
DateTime.utc(2024, 5, 14): [{'class': '授業日', 'number': 6}],
DateTime.utc(2024, 5, 15): [{'class': '授業日', 'number': 6}],
DateTime.utc(2024, 5, 16): [{'class': '授業日', 'number': 6}],
DateTime.utc(2024, 5, 17): [{'class': '授業日', 'number': 6}],
DateTime.utc(2024, 5, 20): [{'class': '授業日', 'number': 6}],
DateTime.utc(2024, 5, 21): [{'class': '授業日', 'number': 7}],
DateTime.utc(2024, 5, 22): [{'class': '授業日', 'number': 7}],
DateTime.utc(2024, 5, 23): [{'class': '授業日', 'number': 7}],
DateTime.utc(2024, 5, 24): [{'class': '授業日', 'number': 7}],
DateTime.utc(2024, 5, 27): [{'class': '授業日', 'number': 7}],
DateTime.utc(2024, 5, 28): [{'class': '授業日', 'number': 8}],
DateTime.utc(2024, 5, 29): [{'class': '授業日', 'number': 8}],
DateTime.utc(2024, 5, 30): [{'class': '授業日', 'number': 8}],
DateTime.utc(2024, 5, 31): [{'class': '授業日', 'number': 8}],


DateTime.utc(2024, 6, 3): [{'class': '授業日', 'number': 8}],
DateTime.utc(2024, 6, 4): [{'class': '授業日', 'number': 9}],
DateTime.utc(2024, 6, 5): [{'class': '授業日', 'number': 9}],
DateTime.utc(2024, 6, 6): [{'class': '授業日', 'number': 9}],
DateTime.utc(2024, 6, 7): [{'class': '授業日', 'number': 9}],

DateTime.utc(2024, 6, 10): [{'class': '授業日', 'number': 9}],
DateTime.utc(2024, 6, 11): [{'class': '授業日', 'number': 10}],
DateTime.utc(2024, 6, 12): [{'class': '授業日', 'number': 10}],
DateTime.utc(2024, 6, 13): [{'class': '授業日', 'number': 10}],
DateTime.utc(2024, 6, 14): [{'class': '授業日', 'number': 10}],

DateTime.utc(2024, 6, 17): [{'class': '授業日', 'number': 10}],
DateTime.utc(2024, 6, 18): [{'class': '授業日', 'number': 11}],
DateTime.utc(2024, 6, 19): [{'class': '授業日', 'number': 11}],
DateTime.utc(2024, 6, 20): [{'class': '授業日', 'number': 11}],
DateTime.utc(2024, 6, 21): [{'class': '授業日', 'number': 11}],

DateTime.utc(2024, 6, 24): [{'class': '授業日', 'number': 11}],
DateTime.utc(2024, 6, 25): [{'class': '授業日', 'number': 12}],
DateTime.utc(2024, 6, 26): [{'class': '授業日', 'number': 12}],
DateTime.utc(2024, 6, 27): [{'class': '授業日', 'number': 12}],
DateTime.utc(2024, 6, 28): [{'class': '授業日', 'number': 12}],

DateTime.utc(2024, 7, 1): [{'class': '授業日', 'number': 12}],
DateTime.utc(2024, 7, 2): [{'class': '授業日', 'number': 13}],
DateTime.utc(2024, 7, 3): [{'class': '授業日', 'number': 13}],
DateTime.utc(2024, 7, 4): [{'class': '授業日', 'number': 13}],
DateTime.utc(2024, 7, 5): [{'class': '授業日', 'number': 13}],
DateTime.utc(2024, 7, 8): [{'class': '授業日', 'number': 13}],
DateTime.utc(2024, 7, 9): [{'class': '授業日', 'number': 14}],
DateTime.utc(2024, 7, 10): [{'class': '授業日', 'number': 14}],
DateTime.utc(2024, 7, 11): [{'class': '授業日', 'number': 14}],
DateTime.utc(2024, 7, 12): [{'class': '授業日', 'number': 14}],
DateTime.utc(2024, 7, 15): [{'class': '授業日', 'number': 14}, {'holiday': '海の日'}],
DateTime.utc(2024, 7, 16): [{'class': '授業日', 'number': 15}],
DateTime.utc(2024, 7, 17): [{'class': '授業日', 'number': 15}],
DateTime.utc(2024, 7, 18): [{'class': '授業日', 'number': 15}],
DateTime.utc(2024, 7, 19): [{'class': '授業日', 'number': 15}],
DateTime.utc(2024, 7, 22): [{'makeup': '補講日', 'number': 5}],
DateTime.utc(2024, 7, 23): [{'exams': '試験', 'number': 1}],
DateTime.utc(2024, 7, 24): [{'exams': '試験', 'number': 2}],
DateTime.utc(2024, 7, 25): [{'exams': '試験', 'number': 3}],
DateTime.utc(2024, 7, 26): [{'exams': '試験', 'number': 4}],
DateTime.utc(2024, 7, 27): [{'exams': '試験', 'number': 5}],
DateTime.utc(2024, 7, 29): [{'exams': '試験', 'number': 6}],
DateTime.utc(2024, 7, 30): [{'exams': '試験', 'number': 7}],
DateTime.utc(2024, 7, 31): [{'exams': '試験', 'number': 8}],

// 8월 수업 데이터
DateTime.utc(2024, 8, 1): [{ 'event': '予準日'}],
DateTime.utc(2024, 8, 3): [{'exams': '追試', 'number': 1}],
DateTime.utc(2024, 8, 5): [{'exams': '追試', 'number':  2}],
DateTime.utc(2024, 8, 6): [{'exams': '追試'}],
DateTime.utc(2024, 8, 20): [{'exams': '追試', 'number': '薬再試'}],
DateTime.utc(2024, 8, 21): [{'exams': '追試', 'number':'薬再試'}],
DateTime.utc(2024, 8, 22): [{'exams': '追試', 'number': '薬再試'}],
DateTime.utc(2024, 8, 23): [{'exams': '追試', 'number': '薬再試'}],
DateTime.utc(2024, 8, 24): [{'exams': '追試', 'number':'薬再試験（予備日）'}],
DateTime.utc(2024, 8, 26): [{'class2': '夏集中Ⅰ'}],
DateTime.utc(2024, 8, 27): [{'class2': '夏集中Ⅰ'}],
DateTime.utc(2024, 8, 28): [{'class2': '夏集中Ⅰ'}],
DateTime.utc(2024, 8, 29): [{'class2': '夏集中Ⅰ'}],
DateTime.utc(2024, 8, 30): [{'class2': '夏集中Ⅰ'}],
DateTime.utc(2024, 8, 31): [{'class2': '夏集中Ⅰ'}],


};


    _selectedEvents = _getEventsForDay(_focusedDay);
  }

  List<dynamic> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

 Widget _buildEventsMarker(DateTime date, List<dynamic> events) {
  Color markerColor = Colors.transparent;
  
  // Check if any events exist for the given date
  if (events.isNotEmpty) {
    // Determine marker color based on event types
    for (var event in events) {
      if (event.containsKey('class')) {
        markerColor = Colors.blue;
        break;
      } else if (event.containsKey('event')) {
        markerColor = Colors.purple;
        break;
      } else if (event.containsKey('holiday')) {
        markerColor = Colors.orange;
        break;
      } else if (event.containsKey('exams')) {
        markerColor = Colors.black;
        break;
         } else if (event.containsKey('class2')) {
        markerColor = Colors.green;
        break;
      }
    }
  }
  
   return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 1.0),
                    width: 10.0,
                    height: 104.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
        color: markerColor,
      ),
    );
}


   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('2024/2025 학사 일정'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TableCalendar(
              firstDay: DateTime.utc(2024, 4, 1),
              lastDay: DateTime.utc(2025, 3, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  _selectedEvents = _getEventsForDay(selectedDay);
                });
              },
              eventLoader: _getEventsForDay,
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  if (events.isNotEmpty) {
                    return _buildEventsMarker(date, events);
                  }
                },
              ),
            ),
            ..._selectedEvents.map((event) {
              Color textColor; // Declaring textColor variable
              String displayText; // Declaring displayText variable

              // Initialize textColor and displayText based on event type
            if (event.containsKey('class')) {
  textColor = Colors.blue;
  displayText = '${event['class']}（${event['number']?.toString() ?? ''}）'; // event['number']가 null인 경우를 처리
} else if (event.containsKey('event')) {
  textColor = Colors.purple;
  displayText = event['event'] ?? 'Unknown event';
} else if (event.containsKey('holiday')) {
  textColor = Colors.orange;
  displayText = event['holiday'];
} else if (event.containsKey('exams')) {
  textColor = Colors.black;
  displayText = '${event['exams']}（${event['number']?.toString() ?? ''}）'; // event['number']가 null인 경우를 처리
} else if (event.containsKey('class2')) {
  textColor = Colors.green;
  displayText = '${event['class2']}'; // 'class2' 이벤트 처리 추가
} else {
  textColor = Colors.grey;
  displayText = 'Unknown Event';
}


              return ListTile(
                title: Text(
                  displayText,
                  style: TextStyle(color: textColor),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}