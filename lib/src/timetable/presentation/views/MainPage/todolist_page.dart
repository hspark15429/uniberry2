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
  DateTime _selectedDay = DateTime.now();
  late Map<DateTime, List<TodoItem>> _groupedEvents = {};
  CalendarView _currentView = CalendarView.month;
  final CalendarController _calendarController = CalendarController();

  @override
  void initState() {
    super.initState();
    if (widget.openAddDialog) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showAddBottomSheet();
      });
    }
    _groupedEvents = _groupEvents(todoList);
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

  List<DateTime> _getWeekendDates(int year, int month) {
    List<DateTime> weekends = [];
    DateTime firstDayOfMonth = DateTime(year, month, 1);
    DateTime lastDayOfMonth = DateTime(year, month + 1, 0);

    for (DateTime date = firstDayOfMonth; date.isBefore(lastDayOfMonth) || date.isAtSameMomentAs(lastDayOfMonth); date = date.add(Duration(days: 1))) {
      if (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday) {
        weekends.add(date);
      }
    }

    return weekends;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: DropdownButton<CalendarView>(
          value: _currentView,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
          onChanged: (CalendarView? newValue) {
            setState(() {
              _currentView = newValue!;
              _calendarController.view = _currentView;
            });
          },
          items: <DropdownMenuItem<CalendarView>>[
            DropdownMenuItem<CalendarView>(
              value: CalendarView.month,
              child: Text('月間', style: TextStyle(color: Colors.black)),
            ),
            DropdownMenuItem<CalendarView>(
              value: CalendarView.week,
              child: Text('週間', style: TextStyle(color: Colors.black)),
            ),
            DropdownMenuItem<CalendarView>(
              value: CalendarView.day,
              child: Text('日間', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today, color: Colors.black),
            onPressed: _showDatePicker,
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black),
            onPressed: _showAddBottomSheet,
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: _buildCalendar(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return SfCalendar(
      view: _currentView,
      controller: _calendarController,
      dataSource: EventDataSource(todoList),
      initialSelectedDate: _selectedDay,
      onViewChanged: (ViewChangedDetails details) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            _selectedDay = details.visibleDates.first;
          });
        });
      },
      onTap: (CalendarTapDetails details) {
        if (details.targetElement == CalendarElement.calendarCell) {
          _showEventsOnDate(details.date!);
        } else if (details.appointments != null && details.appointments!.isNotEmpty) {
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
        backgroundColor: Colors.white,
      ),
      monthViewSettings: MonthViewSettings(
        showAgenda: false,
        appointmentDisplayCount: 4,
        appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
        dayFormat: 'EEE',
        showTrailingAndLeadingDates: false,
        monthCellStyle: MonthCellStyle(
          todayTextStyle: TextStyle(color: Colors.black),
          trailingDatesTextStyle: TextStyle(color: Colors.grey),
          leadingDatesTextStyle: TextStyle(color: Colors.grey),
          textStyle: TextStyle(color: Colors.black),
        ),
      ),
      timeSlotViewSettings: TimeSlotViewSettings(
        startHour: 0,
        endHour: 24,
        timeFormat: 'h:mm a',
        timeIntervalHeight: 50,
        timelineAppointmentHeight: 30,
      ),
      appointmentBuilder: (BuildContext context, CalendarAppointmentDetails details) {
        final TodoItem event = details.appointments.first;
        return Container(
          decoration: BoxDecoration(
            color: event.tagColor,
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.all(4),
          margin: const EdgeInsets.symmetric(vertical: 2),
          child: Text(
            event.title.length > 6 ? event.title.substring(0, 6) : event.title,
            style: TextStyle(color: Colors.white),
            overflow: TextOverflow.ellipsis,
          ),
        );
      },
    );
  }

  void _showEventsOnDate(DateTime date) {
    final eventsOnDate = todoList.where((event) => isSameDay(event.date, date)).toList();
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: Text(DateFormat('yyyy-MM-dd').format(date)),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  Navigator.of(context).pop();
                  _showAddBottomSheet();
                },
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          body: ListView.builder(
            itemCount: eventsOnDate.length,
            itemBuilder: (context, index) {
              final event = eventsOnDate[index];
              return ListTile(
                title: Text(event.title),
                subtitle: Text(event.isAllDay ? '終日' : '${event.startTime?.format(context)} - ${event.endTime?.format(context)}'),
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

  void _showAddBottomSheet() {
    String title = '';
    String description = '';
    DateTime selectedDate = DateTime.now();
    TimeOfDay? startTime;
    TimeOfDay? endTime;
    Color selectedColor = Colors.redAccent;
    bool reminderOneHourBefore = false;
    bool reminderOneDayBefore = false;
    bool isAllDay = false;

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
                      title: const Text('終日'),
                      value: isAllDay,
                      onChanged: (value) {
                        setState(() {
                          isAllDay = value;
                          if (isAllDay) {
                            startTime = null;
                            endTime = null;
                          }
                        });
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
                              isAllDay: isAllDay,
                              startTime: isAllDay ? null : startTime,
                              endTime: isAllDay ? null : endTime,
                              reminderOneHourBefore: reminderOneHourBefore,
                              reminderOneDayBefore: reminderOneDayBefore,
                            );
                            setState(() {
                              todoList.add(newItem);
                              _groupedEvents = _groupEvents(todoList);
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

  void _showDatePicker() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDay,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDay = pickedDate;
        _calendarController.displayDate = _selectedDay;
      });
    }
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
              if (!event.isAllDay) ...[
                Text('開始時間: ${event.startTime?.format(context) ?? '未指定'}'),
                Text('終了時間: ${event.endTime?.format(context) ?? '未指定'}'),
              ],
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
            TextButton(
              child: const Text('削除'),
              onPressed: () {
                setState(() {
                  todoList.removeWhere((item) => item.id == event.id);
                  _groupedEvents = _groupEvents(todoList);
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('編集'),
              onPressed: () {
                Navigator.of(context).pop();
                _showEditBottomSheet(event);
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditBottomSheet(TodoItem event) {
    String title = event.title;
    String description = event.content;
    DateTime selectedDate = event.date;
    TimeOfDay? startTime = event.startTime;
    TimeOfDay? endTime = event.endTime;
    Color selectedColor = event.tagColor;
    bool reminderOneHourBefore = event.reminderOneHourBefore;
    bool reminderOneDayBefore = event.reminderOneDayBefore;
    bool isAllDay = event.isAllDay;

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
                      controller: TextEditingController(text: title),
                    ),
                    TextField(
                      decoration: const InputDecoration(labelText: '内容'),
                      onChanged: (value) => description = value,
                      controller: TextEditingController(text: description),
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
                          initialTime: startTime ?? TimeOfDay.fromDateTime(selectedDate),
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
                          initialTime: endTime ?? TimeOfDay.fromDateTime(selectedDate),
                        );
                        if (pickedTime != null) {
                          setState(() {
                            endTime = pickedTime;
                          });
                        }
                      },
                    ),
                    SwitchListTile(
                      title: const Text('終日'),
                      value: isAllDay,
                      onChanged: (value) {
                        setState(() {
                          isAllDay = value;
                          if (isAllDay) {
                            startTime = null;
                            endTime = null;
                          }
                        });
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
                            setState(() {
                              todoList.removeWhere((item) => item.id == event.id);
                              todoList.add(TodoItem(
                                id: event.id,
                                title: title,
                                content: description,
                                date: selectedDate,
                                tagColor: selectedColor,
                                isAllDay: isAllDay,
                                startTime: isAllDay ? null : startTime,
                                endTime: isAllDay ? null : endTime,
                                reminderOneHourBefore: reminderOneHourBefore,
                                reminderOneDayBefore: reminderOneDayBefore,
                              ));
                              _groupedEvents = _groupEvents(todoList);
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

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}

class TodoItem {
  String id;
  String title;
  DateTime date;
  bool isAllDay;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  Color tagColor;
  String content;
  bool reminderOneHourBefore;
  bool reminderOneDayBefore;

  TodoItem({
    required this.id,
    required this.title,
    required this.date,
    this.isAllDay = false,
    this.startTime,
    this.endTime,
    required this.tagColor,
    required this.content,
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
    if (appointments![index].isAllDay) {
      return DateTime(date.year, date.month, date.day, 0, 0);
    }
    TimeOfDay? time = appointments![index].startTime;
    return DateTime(date.year, date.month, date.day, time?.hour ?? 0, time?.minute ?? 0);
  }

  @override
  DateTime getEndTime(int index) {
    DateTime date = appointments![index].date;
    if (appointments![index].isAllDay) {
      return DateTime(date.year, date.month, date.day, 23, 59);
    }
    TimeOfDay? time = appointments![index].endTime;
    return DateTime(date.year, date.month, date.day, time?.hour ?? 0, time?.minute ?? 0);
  }

  @override
  String getSubject(int index) {
    return appointments![index].title;
  }

  @override
  Color getColor(int index) {
    return appointments![index].tagColor;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}
