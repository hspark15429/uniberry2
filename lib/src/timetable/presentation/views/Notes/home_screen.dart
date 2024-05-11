 import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uniberry2/src/timetable/presentation/views/Notes/database.dart';
import 'package:uniberry2/src/timetable/presentation/views/Notes/noteDetailPage.dart';
import 'package:uniberry2/src/timetable/presentation/views/Notes/note_search_page.dart';

import 'add_note_screen.dart';
import 'note_model.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<NoteModel> _notes = [];
  List<NoteModel> _deletedNotes = []; // 삭제된 노트를 임시로 저장할 리스트
  bool isSelectMode = false;

  String formatDateTime(String dateTimeStr) {
    final dateTime = DateTime.parse(dateTimeStr);
    final formatter = DateFormat('yyyy년 MM월 dd일 HH시 mm분');
    return formatter.format(dateTime);
  }

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  void _loadNotes() async {
  List<NoteModel> loadedNotes = await DatabaseProvider.dbProvider.getNotes();
  // 메모를 생성 날짜 기준으로 내림차순 정렬
  loadedNotes.sort((a, b) => b.creationDate.compareTo(a.creationDate));
  setState(() {
    _notes = loadedNotes;
  });
}

  void _toggleSelectMode(NoteModel note) {
    setState(() {
      note.isSelected = !note.isSelected;
      isSelectMode = _notes.any((n) => n.isSelected);
    });
  }

   void _deleteSelectedNotes() async {
    // 삭제 로직을 수정하여 삭제된 노트들을 _deletedNotes에 저장
    final List<NoteModel> deletedNotes = _notes.where((note) => note.isSelected).toList();
    setState(() {
      _notes.removeWhere((note) => note.isSelected);
      isSelectMode = false;
    });

     // 데이터베이스에서 노트 삭제 로직 추가 필요
    // 예: deletedNotes.forEach((note) => DatabaseProvider.dbProvider.deleteNote(note.id));

    _deletedNotes = deletedNotes; // 삭제된 노트를 _deletedNotes에 저장

     // 삭제 알림을 표시하고, "복원" 액션을 제공
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${deletedNotes.length}개의 노트가 삭제되었습니다.'),
        action: SnackBarAction(
          label: '복원',
          onPressed: _restoreDeletedNotes, // 복원 메서드 호출
        ),
        duration: const Duration(seconds: 5), // Snackbar 지속 시간을 5초로 설정
      ),
    );
  }

  void _restoreDeletedNotes() {
    setState(() {
      // _deletedNotes에 저장된 노트들을 다시 _notes에 추가
      _notes.addAll(_deletedNotes);
      _deletedNotes.clear(); // 복원 후 _deletedNotes는 비움
    });

    // 데이터베이스에 노트 추가 로직 추가 필요
    // 예: _deletedNotes.forEach((note) => DatabaseProvider.dbProvider.insertNote(note));


    _loadNotes(); // 노트 목록 새로고침
    setState(() {
      isSelectMode = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('선택된 노트가 삭제되었습니다.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('My Notes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: NoteSearch(_notes),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddNoteScreen()),
            ).then((_) => _loadNotes()),
          ),
          if (isSelectMode)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteSelectedNotes,
            ),
        ],
      ),
      body: GridView.builder(
  padding: const EdgeInsets.all(8),
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: 10,
    mainAxisSpacing: 10,
    childAspectRatio: 1.0,
  ),
  itemCount: _notes.length,
  itemBuilder: (context, index) {
    final note = _notes[index];
    final creationDateFormatted = formatDateTime(note.creationDate);
    // 노트 설명의 미리보기 길이를 제한합니다.
    String previewDescription = note.description.length > 50
        ? '${note.description.substring(0, 50)}...'
        : note.description;

    return GestureDetector(
      onLongPress: () => _toggleSelectMode(note),
      onTap: () {
        if (isSelectMode) {
          _toggleSelectMode(note);
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NoteDetailPage(note: note)),
          ).then((_) => _loadNotes());
        }
      },
      child: Card(
        color: note.isSelected ? Colors.blue[100] : null,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note.title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4), // 제목과 내용 사이에 조금의 간격을 추가합니다.
              Text(
                previewDescription,
                style: const TextStyle(fontSize: 14),
                overflow: TextOverflow.ellipsis,
                maxLines: 2, // 최대 2줄까지 표시합니다.
              ),
              const Spacer(),
              Text(
                'Created: $creationDateFormatted',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  },
),
      floatingActionButton: isSelectMode
          ? null
          : FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddNoteScreen()),
                ).then((_) => _loadNotes());
              },
              child: const Icon(Icons.add),
            ),
    );
  }
}
