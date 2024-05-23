import 'package:cell_calendar/cell_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class TodolistPage extends StatefulWidget {
  final bool openAddDialog;

  const TodolistPage({Key? key, this.openAddDialog = false}) : super(key: key);

  @override
  _TodolistPageState createState() => _TodolistPageState();
}

class _TodolistPageState extends State<TodolistPage> {
  List<TodoItem> todoList = [];
  List<TodoItem> unscheduledTodoList = [];
  DateTime _selectedDay = DateTime.now();
  late Map<DateTime, List<TodoItem>> _groupedEvents = {};
  int _currentIndex = 0;
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    if (widget.openAddDialog) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showAddBottomSheet();
      });
    }
    _groupedEvents = _groupEvents(todoList + unscheduledTodoList);
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
    String formattedDate = DateFormat('MMMM yyyy').format(_selectedDay);

    return Scaffold(
      appBar: AppBar(
        title: const Text('TODOリスト'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                children: [
                  _buildWeeklyCalendar(),
                  _buildMonthlyCalendar(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 4.0,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              onPressed: () => _goToPage(0),
              child: Text(
                '週間',
                style: TextStyle(
                  color: _currentIndex == 0 ? Colors.blue : Colors.black,
                  fontWeight: _currentIndex == 0 ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            FloatingActionButton(
              onPressed: _showAddBottomSheet,
              tooltip: '追加',
              child: const Icon(Icons.add),
              backgroundColor: Colors.blue,
            ),
            TextButton(
              onPressed: () => _goToPage(1),
              child: Text(
                '月間',
                style: TextStyle(
                  color: _currentIndex == 1 ? Colors.blue : Colors.black,
                  fontWeight: _currentIndex == 1 ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void _goToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildWeeklyCalendar() {
    return Column(
      children: [
        Expanded(
          child: SfCalendar(
            view: CalendarView.week,
            dataSource: EventDataSource(todoList),
            onViewChanged: (ViewChangedDetails details) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _selectedDay = details.visibleDates.first;
                });
              });
            },
            onTap: (details) {
              if (details.appointments != null) {
                final TodoItem event = details.appointments!.first;
                _showEventDetailsDialog(event);
              }
            },
            headerStyle: CalendarHeaderStyle(
              textAlign: TextAlign.center,
              textStyle: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            viewHeaderStyle: ViewHeaderStyle(
              dayTextStyle: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              dateTextStyle: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              backgroundColor: Colors.grey[200],
            ),
          ),
        ),
        _buildUnscheduledEvents(),
      ],
    );
  }

  Widget _buildUnscheduledEvents() {
    if (unscheduledTodoList.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(10.0),
      color: Colors.grey[200],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '時間未指定の予定',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: _showAllUnscheduledEventsBottomSheet,
                child: const Text('全体表示'),
              ),
            ],
          ),
          ...unscheduledTodoList.take(2).map((event) {
            return Dismissible(
              key: Key(event.id),
              onDismissed: (direction) {
                setState(() {
                  unscheduledTodoList.remove(event);
                  _showUndoSnackbar(event);
                });
              },
              background: Container(color: Colors.red),
              child: ListTile(
                title: Text(event.title),
                trailing: Text(DateFormat('yyyy-MM-dd').format(event.date)),
                onTap: () => _showEventDetailsDialog(event),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  void _showUndoSnackbar(TodoItem event) {
    final snackBar = SnackBar(
      content: Text('${event.title} 削除されました'),
      action: SnackBarAction(
        label: '元に戻す',
        onPressed: () {
          setState(() {
            unscheduledTodoList.add(event);
          });
        },
      ),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _showAllUnscheduledEventsBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('時間未指定の予定 - 全体表示'),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          body: ListView.builder(
            shrinkWrap: true,
            itemCount: unscheduledTodoList.length,
            itemBuilder: (context, index) {
              final event = unscheduledTodoList[index];
              return ListTile(
                title: Text(event.title),
                trailing: Text(DateFormat('yyyy-MM-dd').format(event.date)),
                onTap: () {
                  Navigator.of(context).pop();
                  _showEventDetailsDialog(event);
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildMonthlyCalendar() {
    final events = _groupedEvents.entries
        .map((entry) => entry.value
            .map((item) => CalendarEvent(
                  eventName: item.title,
                  eventDate: entry.key,
                  eventBackgroundColor: item.tagColor,
                  eventTextStyle: const TextStyle(),
                ))
            .toList())
        .expand((element) => element)
        .toList();

    return CellCalendar(
      events: events,
      onCellTapped: (date) {
        setState(() {
          _selectedDay = date;
        });
      },
      daysOfTheWeekBuilder: (dayIndex) {
        final daysOfWeek = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
        return Center(
          child: Text(
            daysOfWeek[dayIndex],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        );
      },
      monthYearLabelBuilder: (datetime) {
        return Center(
          child: Text(
            DateFormat.MMMM().format(datetime!),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }

  void _showAddBottomSheet() {
    String title = '';
    String description = '';
    DateTime selectedDate = DateTime.now();
    TimeOfDay? startTime;
    TimeOfDay? endTime;
    Color selectedColor = Colors.redAccent;
    bool reminderOneHourBefore = false;
    bool reminderOneDayBefore = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: StatefulBuilder(
            builder: (context, setState) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: const InputDecoration(labelText: 'タイトル'),
                      onChanged: (value) => title = value,
                    ),
                    TextField(
                      decoration: const InputDecoration(labelText: '内容'),
                      onChanged: (value) => description = value,
                    ),
                    ListTile(
                      title: const Text('タグカラー選択'),
                      trailing: Icon(Icons.circle, color: selectedColor),
                      onTap: () async {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('タグカラー選択'),
                              content: SingleChildScrollView(
                                child: BlockPicker(
                                  pickerColor: selectedColor,
                                  availableColors: [
                                    Colors.red[100]!,
                                    Colors.orange[100]!,
                                    Colors.yellow[100]!,
                                    Colors.green[100]!,
                                    Colors.blue[100]!,
                                    Colors.indigo[100]!,
                                    Colors.purple[100]!,
                                    Colors.black,
                                    Colors.pink[100]!,
                                  ],
                                  onColorChanged: (color) {
                                    setState(() {
                                      selectedColor = color;
                                    });
                                  },
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('保存'),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    ListTile(
                      title: const Text('日付選択'),
                      subtitle: Text(DateFormat('yyyy-MM-dd').format(selectedDate)),
                      onTap: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            selectedDate = pickedDate;
                          });
                        }
                      },
                    ),
                    ListTile(
                      title: const Text('開始時間選択（オプション）'),
                      subtitle: Text(startTime != null ? startTime!.format(context) : '時間を選択してください'),
                      onTap: () async {
                        final TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(selectedDate),
                        );
                        if (pickedTime != null) {
                          setState(() {
                            startTime = pickedTime;
                          });
                        }
                      },
                    ),
                    ListTile(
                      title: const Text('終了時間選択（オプション）'),
                      subtitle: Text(endTime != null ? endTime!.format(context) : '時間を選択してください'),
                      onTap: () async {
                        final TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(selectedDate),
                        );
                        if (pickedTime != null) {
                          setState(() {
                            endTime = pickedTime;
                          });
                        }
                      },
                    ),
                    SwitchListTile(
                      title: const Text('1時間前にリマインド'),
                      value: reminderOneHourBefore,
                      onChanged: (value) {
                        setState(() {
                          reminderOneHourBefore = value;
                        });
                      },
                    ),
                    SwitchListTile(
                      title: const Text('1日前にリマインド'),
                      value: reminderOneDayBefore,
                      onChanged: (value) {
                        setState(() {
                          reminderOneDayBefore = value;
                        });
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          child: const Text('キャンセル'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        ElevatedButton(
                          child: const Text('保存'),
                          onPressed: () {
                            if (title.isEmpty) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('エラー'),
                                    content: const Text('必須フィールドを入力してください。'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('確認'),
                                        onPressed: () => Navigator.of(context).pop(),
                                      ),
                                    ],
                                  );
                                },
                              );
                              return;
                            }
                            TodoItem newItem = TodoItem(
                              id: DateTime.now().toString(),
                              title: title,
                              content: description,
                              date: selectedDate,
                              tagColor: selectedColor,
                              startTime: startTime,
                              endTime: endTime,
                              reminderOneHourBefore: reminderOneHourBefore,
                              reminderOneDayBefore: reminderOneDayBefore,
                            );
                            setState(() {
                              if (startTime == null && endTime == null) {
                                unscheduledTodoList.add(newItem);
                              } else {
                                todoList.add(newItem);
                              }
                              _groupedEvents = _groupEvents(todoList + unscheduledTodoList);
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _showEventDetailsDialog(TodoItem event) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('イベント詳細情報'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('タイトル: ${event.title}'),
              Text('日付: ${DateFormat('yyyy-MM-dd').format(event.date)}'),
              Text('開始時間: ${event.startTime != null ? event.startTime!.format(context) : '未指定'}'),
              Text('終了時間: ${event.endTime != null ? event.endTime!.format(context) : '未指定'}'),
              Text('内容: ${event.content}'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('閉じる'),
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
  String id;
  String title;
  DateTime date;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  Color tagColor;
  String content;
  DateTime? endDate;
  bool reminderOneHourBefore;
  bool reminderOneDayBefore;

  TodoItem({
    required this.id,
    required this.title,
    required this.date,
    this.startTime,
    this.endTime,
    required this.tagColor,
    required this.content,
    this.endDate,
    this.reminderOneHourBefore = false,
    this.reminderOneDayBefore = false,
  });
}

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<TodoItem> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    DateTime date = appointments![index].date;
    TimeOfDay? time = appointments![index].startTime;
    return DateTime(date.year, date.month, date.day, time?.hour ?? 0, time?.minute ?? 0);
  }

  @override
  DateTime getEndTime(int index) {
    DateTime date = appointments![index].date;
    TimeOfDay? time = appointments![index].endTime;
    return DateTime(date.year, date.month, date.day, time?.hour ?? 0, time?.minute ?? 0);
  }

  @override
  String getSubject(int index) {
    return appointments![index].title;
  }

  @override
  Color getColor(int index) {
    if (appointments![index].startTime == null) {
      return Colors.grey;
    }
    return appointments![index].tagColor;
  }

  @override
  bool isAllDay(int index) {
    return false;
  }
}
