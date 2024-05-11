import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uniberry2/src/timetable/presentation/views/Notes/database.dart';
import 'package:uniberry2/src/timetable/presentation/views/Notes/note_model.dart';


class AddNoteScreen extends StatefulWidget {
  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}


class _AddNoteScreenState extends State<AddNoteScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedTag;
  Color _selectedColor = Colors.transparent;


  // 임시로 삭제된 노트를 저장하는 리스트
  List<NoteModel> _deletedNotes = [];

  void _saveNote() {
    final String title = _titleController.text.trim();
    final String description = _descriptionController.text.trim();
    final String creationDate = DateTime.now().toString();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title cannot be empty')),
      );
      return;
    }

    final NoteModel note = NoteModel(
      title: title,
      description: description,
      creationDate: creationDate,
      pinned: false,
      color: _selectedColor.toString(),
    );

    DatabaseProvider.dbProvider.insertNote(note).then(
      (storedNote) => Navigator.of(context).pop(),
    );
  }

  // 노트를 삭제하고 복구 가능한 상태로 변경하는 메서드
  void _deleteNote(NoteModel note) {
    setState(() {
      _deletedNotes.add(note); // 삭제된 노트를 저장
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Note deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            _undoDelete(note);
          },
        ),
      ),
    );

    // 삭제된 노트를 2초 후에 실제로 삭제
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _deletedNotes.remove(note);
      });
    });
  }

  // 삭제를 취소하고 노트를 복구하는 메서드
  void _undoDelete(NoteModel note) {
    setState(() {
      _deletedNotes.remove(note); // 삭제된 노트 목록에서 삭제
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Note'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              hintText: 'Title',
              border: InputBorder.none,
            ),
          ),
          const SizedBox(height: 8.0),
          // 태그 선택 드롭다운을 여기에 배치
        
          const SizedBox(height: 8.0),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              hintText: 'Note content here...',
              border: InputBorder.none,
            ),
            maxLines: null,
            keyboardType: TextInputType.multiline,
          ),
            // 태그 및 색상 선택 기능은 여기에 추가...
            // 슬라이드하여 삭제 및 복구 버튼 추가
            ListView.builder(
              shrinkWrap: true,
              itemCount: _deletedNotes.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(_deletedNotes[index].creationDate),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (direction) {
                    _deleteNote(_deletedNotes[index]);
                  },
                  background: Container(
                    color: Colors.red,
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  child: ListTile(
                    title: Text(_deletedNotes[index].title),
                    subtitle: Text(_deletedNotes[index].description),
                    // 복구하기 버튼 추가
                    trailing: IconButton(
                      icon: const Icon(Icons.restore),
                      onPressed: () {
                        _undoDelete(_deletedNotes[index]);
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
