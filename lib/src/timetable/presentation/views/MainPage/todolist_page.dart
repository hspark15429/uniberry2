import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';


class TodolistPage extends StatefulWidget {
  final bool openAddDialog;

  const TodolistPage({Key? key, this.openAddDialog = false}) : super(key: key);

  @override
  _TodolistPageState createState() => _TodolistPageState();
}

class _TodolistPageState extends State<TodolistPage> {
  List<TodoItem> todoList = [];
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  Color appBarColor = const Color.fromARGB(255, 7, 173, 135);
  late Map<DateTime, List<TodoItem>> _groupedEvents = {};
  int _currentPageIndex = 0; // Add this line
  
  @override
  void initState() {
    super.initState();
    // 초기 데이터를 DateTime 객체를 사용하여 추가합니다.
    if (widget.openAddDialog) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        _showAddDialog();
      });
    }
    todoList.add(TodoItem(
        title: '내생일', date: DateTime.now(), tagColor: Colors.green, content: ''));
    todoList.add(TodoItem(
        title: '프로젝트 마감일',
        date: DateTime.now().add(const Duration(days: 7)),
        tagColor: Colors.red,
        content: ''));
    _groupedEvents = _groupEvents(todoList); // Initialize grouped events
  }

    Map<DateTime, List<TodoItem>> _groupEvents(List<TodoItem> events) {
  Map<DateTime, List<TodoItem>> data = {};
  for (var event in events) {
    DateTime date = DateTime(event.date.year, event.date.month, event.date.day);
    if (!data.containsKey(date)) {
      data[date] = [];
    }
    data[date]!.add(event);
  }
  return data;
}


   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('오늘의 할일'),
        backgroundColor: appBarColor,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.color_lens),
            onPressed: _showColorPickerDialog,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddDialog,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildCalendar(),
          Expanded(
            child: _buildTodoList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return TableCalendar(
      locale: 'ja_JP',
      firstDay: DateTime.utc(2000, 1, 1),
      lastDay: DateTime.utc(2100, 12, 31),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      eventLoader: (day) {
        return _groupedEvents[day] ?? [];
      },
      calendarFormat: CalendarFormat.month,
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, date, events) {
          if (events.isNotEmpty) {
            return Positioned(
              bottom: 1,
              child: Row(
                children: events.map((event) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 1.0),
                    width: 6.0,
                    height: 6.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (event as TodoItem).tagColor,
                    ),
                  );
                }).toList(),
              ),
            );
          }
          return null;
        },
      ),
    );
  }

  Widget _buildTodoList() {
    List <TodoItem> filteredList = todoList.where((item) {
    return item.date.month == _focusedDay.month && item.date.year == _focusedDay.year;
  }).toList();
  
  return ListView.builder(
    itemCount: filteredList.length,
    itemBuilder: (context, index) {
      TodoItem todo = filteredList[index];
        return Dismissible(
          key: Key(todo.title + index.toString()),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            setState(() {
              todoList.removeAt(index);
              _groupedEvents = _groupEvents(todoList);
            });
          },
          background: Container(color: Colors.red),
          child: ListTile(
            title: Text(todo.title),
            subtitle: Text(todo.endDate != null
                ? '${DateFormat('yyyy-MM-dd').format(todo.date)} - ${DateFormat('yyyy-MM-dd').format(todo.endDate!)}'
                : DateFormat('yyyy-MM-dd').format(todo.date)),
            leading: CircleAvatar(
              backgroundColor: todo.tagColor,
            ),
            onTap: () => _showEventDetailsDialog(todo),
          ),
        );
      },
    );
  }
  void _showColorPickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('앱바 색상 선택'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: appBarColor,
              onColorChanged: changeAppBarColor,
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('저장'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void changeAppBarColor(Color color) {
    setState(() {
      appBarColor = color;
    });
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
  setState(() {
    _selectedDay = selectedDay;
    _focusedDay = focusedDay;
    // 필요한 경우 여기에 추가 로직을 구현할 수 있습니다.
  });
}

void _addOrUpdateEvent(TodoItem event) {
  setState(() {
    todoList.add(event); // 이벤트 리스트에 추가
    _groupedEvents = _groupEvents(todoList); // 이벤트 그룹 업데이트
  });
}

void _deleteEvent(int index) {
  setState(() {
    todoList.removeAt(index); // 이벤트 리스트에서 삭제
    _groupedEvents = _groupEvents(todoList); // 이벤트 그룹 업데이트
  });
}



  void _showAddDialog() {
  String title = '';
  String content = '';
  DateTime? selectedDate;
  DateTimeRange? selectedDateRange;
  Color selectedColor = Colors.redAccent; // 기본 색상 설정

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('이벤트 추가'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(labelText: '제목'),
                    onChanged: (value) => title = value,
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: '내용 (선택 사항)'),
                    onChanged: (value) => content = value,
                  ),
                  ListTile(
                    title: const Text('태그 색상 선택'),
                    trailing: Icon(Icons.circle, color: selectedColor),
                    onTap: () async {
                      // 색상 선택 다이얼로그 표시
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('태그 색상 선택'),
                            content: SingleChildScrollView(
                              child: ColorPicker(
                                pickerColor: selectedColor,
                                onColorChanged: (color) {
                                  setState(() {
                                    selectedColor = color;
                                  });
                                },
                                showLabel: true,
                                pickerAreaHeightPercent: 0.8,
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('저장'),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('날짜 범위 선택'),
                    subtitle: Text(
                      selectedDateRange != null
                          ? '선택된 범위: ${DateFormat('yyyy-MM-dd').format(selectedDateRange!.start)} - ${DateFormat('yyyy-MM-dd').format(selectedDateRange!.end)}'
                          : '날짜 범위를 선택해주세요',
                    ),
                    onTap: () async {
                      final DateTimeRange? pickedRange = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedRange != null) {
                        setState(() {
                          selectedDateRange = pickedRange;
                          selectedDate = null; // 범위 선택 시 단일 날짜 선택 초기화
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            actions: <Widget>[
                TextButton(
                  child: const Text('저장'),
                  onPressed: () {
                    if (title.isEmpty ||  (selectedDate == null && selectedDateRange == null)) {
                      // 필수 필드가 누락된 경우 사용자에게 알림
                      // 날짜나 날짜 범위 선택이 필수입니다.
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('오류'),
                            content: const Text('필수 필드를 입력하세요.'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('확인'),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ],
                          );
                        },
                      );
                      return;
                    }
                    TodoItem newItem;
                    if (selectedDate != null) {
                      // 단일 날짜 선택한 경우
                      newItem = TodoItem(
                        title: title,
                        content: content,
                        date: selectedDate!,
                        tagColor: selectedColor,
                      );
                    } else {
                      // 날짜 범위 선택한 경우
                      newItem = TodoItem(
                        title: title,
                        content: content,
                        date: selectedDateRange!.start,
                        endDate: selectedDateRange!.end,
                        tagColor: selectedColor,
                      );
                    }
                    setState(() {
                      todoList.add(newItem);
                      _groupedEvents = _groupEvents(todoList);
                    });
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('취소'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditEventDialog(TodoItem event) {
    TextEditingController titleController = TextEditingController(text: event.title);
    TextEditingController contentController = TextEditingController(text: event.content);
    Color currentColor = event.tagColor;
    DateTime selectedDate = event.date;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('이벤트 수정'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: '제목'),
                ),
                TextField(
                  controller: contentController,
                  decoration: const InputDecoration(labelText: '내용'),
                ),
                ListTile(
                  title: const Text('태그 색상 선택'),
                  trailing: Icon(Icons.circle, color: currentColor), // 현재 색상 표시
                  onTap: () async {
                    // 색상 선택 다이얼로그 표시
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('태그 색상 선택'),
                          content: SingleChildScrollView(
                            child: ColorPicker(
                              pickerColor: currentColor,
                              onColorChanged: (Color color) {
                                setState(() {
                                  currentColor = color;
                                });
                              },
                              showLabel: true,
                              pickerAreaHeightPercent: 0.8,
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('저장'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('저장'),
              onPressed: () {
                setState(() {
                  event.title = titleController.text;
                  event.content = contentController.text;
                  event.tagColor = currentColor;
                  _groupedEvents = _groupEvents(todoList);
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('취소'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _showEventDetailsDialog(TodoItem event) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('이벤트 상세 정보'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('제목: ${event.title}'),
              Text('날짜: ${DateFormat('yyyy-MM-dd').format(event.date)}'),
              Text('내용: ${event.content}'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('닫기'),
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

class TodoItem {
  String title;
  DateTime date;
  Color tagColor;
  String content;
  DateTime? endDate; // 추가된 필드

  TodoItem({
    required this.title,
    required this.date,
    required this.tagColor,
    required this.content,
    this.endDate,
  });
}