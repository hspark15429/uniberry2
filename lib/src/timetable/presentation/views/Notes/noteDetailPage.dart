import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uniberry2/src/timetable/presentation/views/Notes/database.dart';
import 'package:uniberry2/src/timetable/presentation/views/Notes/note_model.dart';


class NoteDetailPage extends StatefulWidget {
  final NoteModel note;

  const NoteDetailPage({Key? key, required this.note}) : super(key: key);

  @override
  _NoteDetailPageState createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _descriptionController = TextEditingController(text: widget.note.description);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveNoteChanges() async {
    widget.note.title = _titleController.text;
    widget.note.description = _descriptionController.text;
    await DatabaseProvider.dbProvider.updateNote(widget.note);
  }

  void _shareNote() { // 이 메서드를 _NoteDetailPageState 클래스 안으로 이동
    final String noteContent = '${_titleController.text}\n${_descriptionController.text}';
    Share.share(noteContent);
  }

  void _confirmDelete(BuildContext context, NoteModel note) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Note'),
          content: const Text('Are you sure you want to delete this note?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                await DatabaseProvider.dbProvider.deleteNote(note.id!); // Delete note from database
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Close note detail page
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _titleController,
          decoration: const InputDecoration(
            hintText: "Enter title",
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold),
          ),
          style: const TextStyle(color: Colors.brown, fontSize: 20, fontWeight: FontWeight.bold),
          onChanged: (value) => _saveNoteChanges(),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareNote, // 수정됨: _shareNote를 여기서 직접 참조
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _confirmDelete(context, widget.note),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                hintText: "Enter description",
                border: InputBorder.none,
              ),
              maxLines: null, // Allow unlimited lines
              onChanged: (value) => _saveNoteChanges(),
            ),
          ],
        ),
      ),
    );
  }
}
