

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'note_model.dart';

class DatabaseProvider {

   Future<void> deleteNote(int id) async {
    final db = await database;
    await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  
  static final DatabaseProvider dbProvider = DatabaseProvider();
  Widget buildNoteItem(NoteModel note) {
  return ListTile(
    title: Text(note.title),
    subtitle: Text(note.description),
    trailing: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text('Date: ${note.creationDate}'), // 생성 날짜 표시
      ],
    ),
   
  );
}

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await openDb();
    return _database!;
  }

  Future<void> updateNote(NoteModel note) async {
  final db = await database;
  await db.update(
    'notes',
    note.toMap(),
    where: 'id = ?',
    whereArgs: [note.id],
  );
}

  Future<Database> openDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'notesapp.db');

    return await openDatabase(path, version: 1, onCreate: (Database db, int version) async {
      await db.execute('''
        CREATE TABLE notes(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          description TEXT,
          creationDate TEXT,
          pinned INTEGER,
          color TEXT
        )
      ''');
    });
  }

  Future<int> insertNote(NoteModel note) async {
    final db = await database;
    return await db.insert('notes', note.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<NoteModel>> getNotes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('notes');

    return List.generate(maps.length, (i) {
      return NoteModel.fromMap(maps[i]);
    });
  }

void _deleteNote(BuildContext context, NoteModel note) async {
  final dbProvider = DatabaseProvider.dbProvider;
  final db = await dbProvider.database;


  await db.delete(
    'notes',
    where: 'id = ?',
    whereArgs: [note.id],
  );


  Navigator.of(context).pop(); // 다이얼로그 닫기
  Navigator.of(context).pop(); // 노트 상세 페이지 닫기
}

  
}
