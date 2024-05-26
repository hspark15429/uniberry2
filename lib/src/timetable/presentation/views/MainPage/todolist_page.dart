import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
      DateTime? endDate = event.endDate ?? event.date;
      while (!date.isAfter(endDate)) {
        if (!data.containsKey(date)) {
          data[date] = [];
        }
        data[date]!.add(event);
        date = date.add(const Duration(days: 1));
      }
    }
    return data;
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
            const DropdownMenuItem<CalendarView>(
              value: CalendarView.month,
              child: Text('月間', style: TextStyle(color: Colors.black)),
            ),
            const DropdownMenuItem<CalendarView>(
              value: CalendarView.week,
              child: Text('週間', style: TextStyle(color: Colors.black)),
            ),
            const DropdownMenuItem<CalendarView>(
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
      body: Column(
        children: [
          Expanded(
            child: _buildCalendar(),
          ),
          if (_currentView == CalendarView.day || _currentView == CalendarView.week)
            _buildAllDayEvents(),
        ],
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
      headerStyle: const CalendarHeaderStyle(
        textAlign: TextAlign.center,
        textStyle: TextStyle(
          color: Colors.black,
fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      viewHeaderStyle: const ViewHeaderStyle(
        dayTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        dateTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Colors.white,
      ),
      monthViewSettings: const MonthViewSettings(
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
      timeSlotViewSettings: const TimeSlotViewSettings(
        startHour: 0,
        endHour: 24,
        timeFormat: 'h:mm a',
        timeIntervalHeight: 50,
        timelineAppointmentHeight: 20,
      ),
      appointmentBuilder: (BuildContext context, CalendarAppointmentDetails details) {
        final TodoItem event = details.appointments.first;
        return Container(
          height: 20,
          width: details.bounds.width,
          decoration: BoxDecoration(
            color: event.tagColor,
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.all(4),
margin: const EdgeInsets.symmetric(vertical: 0.2),
          child: Center(
            child: Text(
              event.title,
style: const TextStyle(color: Colors.white, fontSize: 10),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }

  Widget _buildAllDayEvents() {
    List<TodoItem> allDayEvents = todoList.where((event) => event.isAllDay && (isSameDay(event.date, _selectedDay) || isBetween(_selectedDay, event.date, event.endDate))).toList();
    if (allDayEvents.isEmpty) return Container();

    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.grey[200],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '종일 이벤트',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              if (allDayEvents.length > 3)
                TextButton(
                  onPressed: () => _showAllDayEventsDialog(allDayEvents),
                  child: const Text(
                    '더보기',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          ...allDayEvents.take(3).map((event) => Slidable(
            key: Key(event.id),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) => _deleteEvent(event),
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: '삭제',
                ),
              ],
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              padding: const EdgeInsets.all(8),
              color: event.tagColor,
              child: ListTile(
                title: Text(event.title, style: const TextStyle(fontSize: 14, color: Colors.white)),
                onTap: () => _showEventDetailsDialog(event),
              ),
            ),
          )),
        ],
      ),
    );
  }

  void _showAllDayEventsDialog(List<TodoItem> allDayEvents) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('종일 이벤트'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: allDayEvents.length,
              itemBuilder: (context, index) {
                final event = allDayEvents[index];
                return ListTile(
                  title: Text(event.title),
                  subtitle: Text(event.isAllDay ? '종일' : '${event.startTime?.format(context)} - ${event.endTime?.format(context)}'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _showEventDetailsDialog(event);
                  },
                );
              },
            ),
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

  void _showEventsOnDate(DateTime date) {
    final eventsOnDate = todoList.where((event) => isSameDay(event.date, date) || isBetween(date, event.date, event.endDate)).toList();
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
                subtitle: Text(event.isAllDay
                    ? '종일'
                    : '${event.startTime?.format(context)} - ${event.endTime?.format(context)}'),
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
    String location = '';
    DateTime startDate = DateTime.now();
    DateTime? endDate;
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
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'タイトル (必須)',
                        labelStyle: TextStyle(color: Colors.red),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) => title = value,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      decoration: InputDecoration(
                        labelText: '内容',
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: const OutlineInputBorder(),
                      ),
                      maxLines: 4,
                      onChanged: (value) => description = value,
                    ),
                    const SizedBox(height: 16),
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
                                    Colors.red[700]!,
                                    Colors.orange[700]!,
                                    Colors.yellow[700]!,
                                    Colors.green[700]!,
                                    Colors.blue[700]!,
                                    Colors.indigo[700]!,
                                    Colors.purple[700]!,
                                    Colors.black,
                                    Colors.pink[700]!,
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
                      title: const Text('개시날 선택'),
                      subtitle: Text(
                        DateFormat('yyyy-MM-dd').format(startDate),
                      ),
                      onTap: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: startDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            startDate = pickedDate;
                          });
                        }
                      },
                    ),
                    ListTile(
                      title: const Text('개시 시간 설정'),
                      subtitle: Text(
                        startTime != null ? startTime!.format(context) : '시간을 선택해주세요',
                      ),
                      onTap: () async {
                        final TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: startTime ?? TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          setState(() {
                            startTime = pickedTime;
                          });
                        }
                      },
                    ),
                    ListTile(
                      title: const Text('종료날 선택'),
                      subtitle: Text(
                        endDate != null ? DateFormat('yyyy-MM-dd').format(endDate!) : '날짜를 선택해주세요',
                      ),
                      onTap: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: startDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            endDate = pickedDate;
                          });
                        }
                      },
                    ),
                    ListTile(
                      title: const Text('종료 시간 설정'),
                      subtitle: Text(
                        endTime != null ? endTime!.format(context) : '시간을 선택해주세요',
                      ),
                      onTap: () async {
                        final TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: endTime ?? TimeOfDay.now(),
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
                    TextField(
                      decoration: InputDecoration(
                        labelText: '場所',
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (value) => location = value,
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
                              date: startDate,
                              endDate: endDate,
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

  void _deleteEvent(TodoItem event) {
    setState(() {
      todoList.removeWhere((item) => item.id == event.id);
      _groupedEvents = _groupEvents(todoList);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${event.title} 삭제됨'),
        action: SnackBarAction(
          label: '복원',
          onPressed: () {
            setState(() {
              todoList.add(event);
              _groupedEvents = _groupEvents(todoList);
            });
          },
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showEditBottomSheet(TodoItem event) {
    String title = event.title;
    String description = event.content;
    String location = '';
    DateTime startDate = event.date;
    DateTime? endDate = event.endDate;
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
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'タイトル (必須)',
                        labelStyle: TextStyle(color: Colors.red),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) => title = value,
                      controller: TextEditingController(text: title),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      decoration: InputDecoration(
                        labelText: '内容',
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: const OutlineInputBorder(),
                      ),
                      maxLines: 4,
                      onChanged: (value) => description = value,
                      controller: TextEditingController(text: description),
                    ),
                    const SizedBox(height: 16),
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
                                    Colors.red[700]!,
                                    Colors.orange[700]!,
                                    Colors.yellow[700]!,
                                    Colors.green[700]!,
                                    Colors.blue[700]!,
                                    Colors.indigo[700]!,
                                    Colors.purple[700]!,
                                    Colors.black,
                                    Colors.pink[700]!,
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
                      title: const Text('개시날 선택'),
                      subtitle: Text(
                        DateFormat('yyyy-MM-dd').format(startDate),
                      ),
                      onTap: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: startDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            startDate = pickedDate;
                          });
                        }
                      },
                    ),
                    ListTile(
                      title: const Text('개시 시간 설정'),
                      subtitle: Text(
                        startTime != null ? startTime!.format(context) : '시간을 선택해주세요',
                      ),
                      onTap: () async {
                        final TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: startTime ?? TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          setState(() {
                            startTime = pickedTime;
                          });
                        }
                      },
                    ),
                    ListTile(
                      title: const Text('종료날 선택'),
                      subtitle: Text(
                        endDate != null ? DateFormat('yyyy-MM-dd').format(endDate!) : '날짜를 선택해주세요',
                      ),
                      onTap: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: startDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            endDate = pickedDate;
                          });
                        }
                      },
                    ),
                    ListTile(
                      title: const Text('종료 시간 설정'),
                      subtitle: Text(
                        endTime != null ? endTime!.format(context) : '시간을 선택해주세요',
                      ),
                      onTap: () async {
                        final TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: endTime ?? TimeOfDay.now(),
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
                    TextField(
                      decoration: InputDecoration(
                        labelText: '場所',
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (value) => location = value,
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
                                date: startDate,
                                endDate: endDate,
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

  bool isBetween(DateTime date, DateTime startDate, DateTime? endDate) {
    if (endDate == null) {
      return false;
    }
    return (date.isAfter(startDate) && date.isBefore(endDate)) || date == endDate;
  }
}

class TodoItem {
  String id;
  String title;
  DateTime date;
  DateTime? endDate;
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
    this.endDate,
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
    DateTime date = appointments![index].endDate ?? appointments![index].date;
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
