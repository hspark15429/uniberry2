import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import 'package:uniberry2/src/timetable/domain/entities/course.dart';
import 'package:url_launcher/url_launcher.dart';



class TimetableDetailPage extends StatefulWidget {
  final Course course;

  const TimetableDetailPage({super.key, required this.course});

  @override
  _TimetableDetailPageState createState() => _TimetableDetailPageState();
}

class _TimetableDetailPageState extends State<TimetableDetailPage>
    with SingleTickerProviderStateMixin {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.course.titles.join(", ")),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
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
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: ElevatedButton(
                onPressed: () => _launchURL(widget.course.syllabusUrl),
                child: const Text("시라버스 확인하기"),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(icon: Icon(Icons.note), text: '메모'),
              Tab(icon: Icon(Icons.assignment), text: '과제'),
            ],
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
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
}

//메모페이지
class MemoPage extends StatefulWidget {
  final Course course;

  const MemoPage({Key? key, required this.course}) : super(key: key);

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
        title: const Text('메모'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
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
            child: ListTile(
              title: Text(memo.title),
              subtitle: Text(DateFormat('yyyy-MM-dd HH:mm').format(memo.dateTime)), // 작성일(수정일) 표시
              onTap: () => _showMemoDetails(memo),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _editMemo(memo),
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



//과제 페이지
class Assignment {
  final String title;
  final DateTime dateTime;
  bool isCompleted;

  Assignment({
    required this.title,
    required this.dateTime,
    this.isCompleted = false,
  });
}

class AssignmentPage extends StatelessWidget {
  final Course course;
 AssignmentPage({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignments'),
      ),
      body: const Center(
        child: Text('Here are your assignments.'),
      ),
    );
  }
}


class AssignmentNotifier extends ChangeNotifier {
  List<Assignment> _assignments = [];

  List<Assignment> get assignments => _assignments;

  void addAssignment(Assignment assignment) {
    _assignments.add(assignment);
    notifyListeners();
  }

  void toggleCompletion(int index) {
    _assignments[index].isCompleted = !_assignments[index].isCompleted;
    notifyListeners();
  }
}


// 과목별 QA 게시판

