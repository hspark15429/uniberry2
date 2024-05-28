import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uniberry2/src/timetable/domain/entities/course.dart';
import 'package:uniberry2/src/timetable/presentation/cubit/timetable_cubit.dart';
import 'package:uniberry2/src/timetable/presentation/views/timetable/timetable_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class TimetableDetailPage extends StatefulWidget {
  final Course course;
  final String period;
  final String semester;

  const TimetableDetailPage({super.key, required this.course, required this.period, required this.semester});

  @override
  _TimetableDetailPageState createState() => _TimetableDetailPageState();
}

class _TimetableDetailPageState extends State<TimetableDetailPage> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _deleteCourse(BuildContext context) {
    String currentSemester = widget.semester;
    context.read<TimetableCubit>().removeCourseFromTimetable(widget.period, currentSemester);

  Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (context) => TimetableScreen()),
  (Route<dynamic> route) => false,
);
  }

  void _editCourse(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return EditCourseDialog(course: widget.course, period: widget.period, semester: widget.semester);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.course.titles.join(", "), style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: () => _deleteCourse(context),
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () => _editCourse(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(1),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow("강의 코드", widget.course.codes.join(", ")),
                    _buildInfoRow("수업명", widget.course.titles.join(", ")),
                    _buildInfoRow("교수명", widget.course.professors.join(", ")),
                    _buildInfoRow("학점", widget.course.credit.toString()),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  onPressed: () => _launchURL(widget.course.syllabusUrl),
                  child: const Text("シラバスを見る", style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 16),
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(icon: Icon(Icons.note), text: '메모'),
                  Tab(icon: Icon(Icons.assignment), text: '과제'),
                ],
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.black,
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    MemoPage(course: widget.course),
                    AssignmentPage(course: widget.course),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.grey),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class EditCourseDialog extends StatefulWidget {
  final Course course;
  final String period;
  final String semester;

  const EditCourseDialog({super.key, required this.course, required this.period, required this.semester});

  @override
  _EditCourseDialogState createState() => _EditCourseDialogState();
}

class _EditCourseDialogState extends State<EditCourseDialog> {
  final _titleController = TextEditingController();
  final _professorController = TextEditingController();
  final _codeController = TextEditingController();
  final _creditController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.course.titles.join(", ");
    _professorController.text = widget.course.professors.join(", ");
    _codeController.text = widget.course.codes.join(", ");
    _creditController.text = widget.course.credit.toString();
  }

  void _saveCourse() {
    if (_titleController.text.isEmpty || _professorController.text.isEmpty || _codeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('강의명, 교수명, 강의코드는 필수 입력 항목입니다.')),
      );
      return;
    }

    final updatedCourse = Course(
      courseId: widget.course.courseId,
      titles: [_titleController.text],
      professors: [_professorController.text],
      codes: [_codeController.text],
      campuses: widget.course.campuses,
      syllabusUrl: widget.course.syllabusUrl,
      credit: int.tryParse(_creditController.text) ?? widget.course.credit,
      schools: widget.course.schools,
      term: widget.course.term,
      periods: widget.course.periods,
      languages: widget.course.languages,
    );

    context.read<TimetableCubit>().addCourseToTimetable(updatedCourse, widget.period, widget.semester);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('강의 수정'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: '강의명'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _professorController,
              decoration: const InputDecoration(labelText: '교수명'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(labelText: '강의코드'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _creditController,
              decoration: const InputDecoration(labelText: '학점'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('취소'),
        ),
        ElevatedButton(
          onPressed: _saveCourse,
          child: const Text('저장'),
        ),
      ],
    );
  }
}

class MemoPage extends StatefulWidget {
  final Course course;

  const MemoPage({super.key, required this.course});

  @override
  _MemoPageState createState() => _MemoPageState();
}

class _MemoPageState extends State<MemoPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final List<Memo> _memos = [];
  Memo? _selectedMemo;

  @override
  Widget build(BuildContext context) {
    _memos.sort((a, b) => b.dateTime.compareTo(a.dateTime)); // 최신 메모가 상단에 위치하도록 정렬

    return Scaffold(
      appBar: AppBar(
        title: const Text('메모', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => _showMemoDialog(),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _memos.length,
        itemBuilder: (context, index) {
          final memo = _memos[index];
          return Dismissible(
            key: Key(memo.id.toString()),
            onDismissed: (direction) => _deleteMemo(index),
            background: Container(color: Colors.red),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: ListTile(
                title: Text(
                  memo.title,
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  DateFormat('yyyy-MM-dd HH:mm').format(memo.dateTime),
                  style: const TextStyle(color: Colors.grey),
                ),
                onTap: () => _showMemoDetails(memo),
                trailing: IconButton(
                  icon: const Icon(Icons.edit, color: Colors.black),
                  onPressed: () => _editMemo(memo),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showMemoDialog({Memo? memo}) {
    _selectedMemo = memo;
    _titleController.text = _selectedMemo?.title ?? '';
    _contentController.text = _selectedMemo?.content ?? '';

    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(_selectedMemo == null ? '새 메모 추가' : '메모 수정'),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                CupertinoTextField(
                  controller: _titleController,
                  placeholder: '제목',
                ),
                const SizedBox(height: 12.0),
                CupertinoTextField(
                  controller: _contentController,
                  placeholder: '내용',
                  minLines: 3,
                  maxLines: null,
                ),
              ],
            ),
          ),
          actions: [
            CupertinoDialogAction(
              child: const Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: const Text('저장'),
              onPressed: () {
                _saveMemo();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _saveMemo() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    if (title.isNotEmpty || content.isNotEmpty) {
      setState(() {
        if (_selectedMemo == null) {
          final memo = Memo(
            id: _memos.length + 1,
            title: title,
            content: content,
            dateTime: DateTime.now(),
          );
          _memos.insert(0, memo);
        } else {
          _selectedMemo!.title = title;
          _selectedMemo!.content = content;
          _selectedMemo!.dateTime = DateTime.now();
        }
      });
      _titleController.clear();
      _contentController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('제목과 내용을 입력하세요.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _showMemoDetails(Memo memo) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(memo.title),
          content: SingleChildScrollView(
            child: MarkdownBody(data: memo.content),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _editMemo(memo);
              },
              child: const Text('수정'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('닫기'),
            ),
          ],
        );
      },
    );
  }

  void _editMemo(Memo memo) {
    _showMemoDialog(memo: memo);
  }

  void _deleteMemo(int index) {
    setState(() {
      final deletedMemo = _memos.removeAt(index);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('메모가 삭제되었습니다.'),
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: '복원',
            textColor: Colors.blue,
            onPressed: () => _restoreMemo(deletedMemo, index),
          ),
        ),
      );
    });
  }

  void _restoreMemo(Memo memo, int index) {
    setState(() {
      _memos.insert(index, memo);
    });
  }
}

class Memo {
  int id;
  String title;
  String content;
  DateTime dateTime;

  Memo({
    required this.id,
    required this.title,
    required this.content,
    required this.dateTime,
  });
}

class AssignmentPage extends StatefulWidget {
  final Course course;

  const AssignmentPage({super.key, required this.course});

  @override
  _AssignmentPageState createState() => _AssignmentPageState();
}

class _AssignmentPageState extends State<AssignmentPage> {
  final List<Assignment> _assignments = [];

  @override
  void initState() {
    super.initState();
    _loadAssignments();
  }

  Future<void> _loadAssignments() async {
    final prefs = await SharedPreferences.getInstance();
    final String? assignmentsJson = prefs.getString('assignments');
    if (assignmentsJson != null) {
      final List<dynamic> assignmentsList = json.decode(assignmentsJson) as List<dynamic>;
      setState(() {
        _assignments.addAll(assignmentsList.map((json) => Assignment.fromJson(json as Map<String, dynamic>)).toList());
      });
    }
  }

  Future<void> _saveAssignments() async {
    final prefs = await SharedPreferences.getInstance();
    final String assignmentsJson = json.encode(_assignments.map((a) => a.toJson()).toList());
    await prefs.setString('assignments', assignmentsJson);
  }

  void _addAssignment(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _AssignmentDialog(
        onSave: (assignment) {
          setState(() {
            _assignments.add(assignment);
          });
          _saveAssignments();
        },
      ),
    );
  }

  void _toggleComplete(Assignment assignment) {
    setState(() {
      assignment.isComplete = !assignment.isComplete;
    });
    _saveAssignments();
  }

  void _editAssignment(Assignment assignment) {
    showDialog(
      context: context,
      builder: (context) => _AssignmentDialog(
        assignment: assignment,
        onSave: (updatedAssignment) {
          setState(() {
            final index = _assignments.indexOf(assignment);
            _assignments[index] = updatedAssignment;
          });
          _saveAssignments();
        },
      ),
    );
  }

  void _deleteAssignment(int index) {
    final deletedAssignment = _assignments[index];
    setState(() {
      _assignments.removeAt(index);
    });
    _saveAssignments();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('과제가 삭제되었습니다.'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: '복원',
          textColor: Colors.blue,
          onPressed: () {
            setState(() {
              _assignments.insert(index, deletedAssignment);
            });
            _saveAssignments();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('과제', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _addAssignment(context),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _assignments.length,
        itemBuilder: (context, index) {
          final assignment = _assignments[index];
          return Dismissible(
            key: Key(assignment.title),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              _deleteAssignment(index);
            },
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              color: Colors.red,
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: ListTile(
                title: Row(
                  children: [
                    Text(
                      assignment.title,
                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      assignment.type == 'Exam' ? 'Test' : 'Assignment',
                      style: TextStyle(color: assignment.type == 'Exam' ? Colors.red : Colors.green),
                    ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Due: ${DateFormat('yyyy-MM-dd').format(assignment.dueDate)}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    if (assignment.description.isNotEmpty)
                      Text(
                        assignment.description,
                        style: const TextStyle(color: Colors.grey),
                      ),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(
                    assignment.isComplete ? Icons.check_circle : Icons.check_circle_outline,
                    color: assignment.isComplete ? Colors.blue : Colors.grey,
                  ),
                  onPressed: () {
                    _toggleComplete(assignment);
                  },
                ),
                onTap: () {
                  _editAssignment(assignment);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class _AssignmentDialog extends StatefulWidget {
  final Assignment? assignment;
  final Function(Assignment) onSave;

  _AssignmentDialog({this.assignment, required this.onSave});

  @override
  __AssignmentDialogState createState() => __AssignmentDialogState();
}

class __AssignmentDialogState extends State<_AssignmentDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _type;
  DateTime? _dueDate;
  late String _title;
  late String _description;
  late int _reminder;

  @override
  void initState() {
    super.initState();
    _type = widget.assignment?.type ?? 'Assignment';
    _dueDate = widget.assignment?.dueDate;
    _title = widget.assignment?.title ?? '';
    _description = widget.assignment?.description ?? '';
    _reminder = widget.assignment?.reminder ?? 24;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('과제/시험 추가'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _type,
                items: ['Assignment', 'Exam'].map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _type = value!;
                  });
                },
                decoration: InputDecoration(labelText: 'Type'),
                validator: (value) => value == null ? '유형을 선택하세요' : null,
              ),
              const SizedBox(height: 8),
              ListTile(
                title: Text(
                    _dueDate == null ? '기한 선택' : '기한: ${DateFormat('yyyy-MM-dd').format(_dueDate!)}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now().subtract(const Duration(days: 30)),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null && picked != _dueDate) {
                    setState(() {
                      _dueDate = picked;
                    });
                  }
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(labelText: '제목'),
                onChanged: (value) {
                  setState(() {
                    _title = value;
                  });
                },
                validator: (value) => value == null || value.isEmpty ? '제목을 입력하세요' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: '설명'),
                onChanged: (value) {
                  setState(() {
                    _description = value;
                  });
                },
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                value: _reminder,
                items: const [
                  DropdownMenuItem(value: 24, child: Text('1일 전')),
                  DropdownMenuItem(value: 1, child: Text('1시간 전')),
                ],
                onChanged: (value) {
                  setState(() {
                    _reminder = value!;
                  });
                },
                decoration: InputDecoration(labelText: '리마인더'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('취소'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate() && _dueDate != null) {
              final assignment = Assignment(
                type: _type,
                title: _title,
                dueDate: _dueDate!,
                description: _description,
                reminder: _reminder,
                isComplete: widget.assignment?.isComplete ?? false,
              );
              widget.onSave(assignment);
              Navigator.of(context).pop();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('유형, 기한 및 제목을 입력하세요.'),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          },
          child: const Text('저장'),
        ),
      ],
    );
  }
}

class Assignment {
  String type;
  String title;
  DateTime dueDate;
  String description;
  int reminder;
  bool isComplete;

  Assignment({
    required this.type,
    required this.title,
    required this.dueDate,
    required this.description,
    required this.reminder,
    this.isComplete = false,
  });

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      type: json['type'] as String,
      title: json['title'] as String,
      dueDate: DateTime.parse(json['dueDate'] as String),
      description: json['description'] as String,
      reminder: json['reminder'] as int,
      isComplete: json['isComplete'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'title': title,
      'dueDate': dueDate.toIso8601String(),
      'description': description,
      'reminder': reminder,
      'isComplete': isComplete,
    };
  }
}
