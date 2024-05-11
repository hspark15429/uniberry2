import 'package:flutter/material.dart';

class TimetableMenuPage extends StatefulWidget {
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
        .expand((year) => ["${year}年春学期", "${year}年秋学期"])
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('시간표 관리'),
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
            child: ListTile(
              title: Text(_timetableList[index]),
              onTap: () => _displayEditDialog(context, index),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayAddDialog(context),
        child: const Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Future<void> _displayEditDialog(BuildContext context, int index) async {
    TextEditingController _controller = TextEditingController(text: _timetableList[index]);
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('시간표 이름 변경'),
          content: TextField(
            controller: _controller,
            decoration: const InputDecoration(hintText: '새로운 시간표 이름을 입력하세요'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('저장'),
              onPressed: () {
                setState(() {
                  _timetableList[index] = _controller.text;
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _displayAddDialog(BuildContext context) async {
    TextEditingController _controller = TextEditingController();
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
              child: const Text('추가'),
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
              child: const Text('취소'),
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
