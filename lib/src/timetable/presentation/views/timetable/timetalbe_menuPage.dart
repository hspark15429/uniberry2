import 'package:flutter/material.dart';

class TimetableMenuPage extends StatefulWidget {
  final Function(String) onTimetableSelected;

  const TimetableMenuPage({super.key, required this.onTimetableSelected});

  @override
  _TimetableMenuPageState createState() => _TimetableMenuPageState();
}

class _TimetableMenuPageState extends State<TimetableMenuPage> {
  late List<String> _timetableList;

  @override
  void initState() {
    super.initState();
    int currentYear = DateTime.now().year;
    _timetableList = List.generate(4, (int index) => currentYear + index)
.expand((year) => ["${year}년봄학기", "${year}년가을학기"])
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('시간표 관리', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: ListView.builder(
        itemCount: _timetableList.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(_timetableList[index]),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              setState(() {
                _timetableList.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${_timetableList[index]}가 삭제되었습니다'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 3,
              child: ListTile(
                title: Text(_timetableList[index], style: const TextStyle(color: Colors.black)),
                onTap: () {
                  Navigator.pop(context);
                  widget.onTimetableSelected(_timetableList[index]);
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayAddDialog(context),
        backgroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _displayAddDialog(BuildContext context) async {
    final TextEditingController _controller = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('새 시간표 추가'),
          content: TextField(
            controller: _controller,
            decoration: const InputDecoration(hintText: '시간표 이름'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('추가', style: TextStyle(color: Colors.black)),
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  setState(() {
                    _timetableList.add(_controller.text);
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
            TextButton(
              child: const Text('취소', style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

