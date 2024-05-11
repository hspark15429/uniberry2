import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uniberry2/src/timetable/presentation/views/Notes/noteDetailPage.dart';
import 'package:uniberry2/src/timetable/presentation/views/Notes/note_model.dart'; // 날짜 포매팅을 위해 추가

class NoteSearch extends SearchDelegate<NoteModel> {
  final List<NoteModel> notes;

  NoteSearch(this.notes);

  // 날짜 포매팅을 위한 함수
  String formatDateTime(String dateTimeStr) {
    final dateTime = DateTime.parse(dateTimeStr);
    final formatter = DateFormat('yyyy-MM-dd'); // 원하는 포맷으로 수정 가능
    return formatter.format(dateTime);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }
// Example of handling the result
void handleSearchResult(NoteModel result) {
  if (result == NoteModel.noSelection) {
    // Handle the "no selection" or "cancel" case
  } else {
    // Proceed with handling a valid selection
  }
}

  @override
Widget buildLeading(BuildContext context) {
  return IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () {
      // Use the noSelection sentinel value instead of null
      close(context, NoteModel.noSelection);
    },
  );
}


 @override
Widget buildResults(BuildContext context) {
  // 사용자의 쿼리에 맞는 노트를 필터링합니다.
  final results = notes.where((note) =>
      note.title.toLowerCase().contains(query.toLowerCase()) ||
      note.description.toLowerCase().contains(query.toLowerCase())).toList();

  if (results.isEmpty) {
    // 검색 결과가 비어 있을 때의 처리
    return const Center(child: Text('검색 결과가 없습니다.'));
  }

  // 검색 결과를 기반으로 리스트를 보여줍니다.
  return ListView.builder(
    itemCount: results.length,
    itemBuilder: (context, index) {
      final note = results[index];
      final creationDateFormatted = formatDateTime(note.creationDate);
      return ListTile(
        title: Text(note.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('작성일: $creationDateFormatted\n${note.description}', 
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)), // 작성일 볼드체로 수정
        isThreeLine: true,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NoteDetailPage(note: note)),
          );
        },
      );
    },
  );
}
@override
Widget buildSuggestions(BuildContext context) {
  // 사용자가 입력한 쿼리에 기반하여 노트를 필터링합니다.
  final suggestions = query.isEmpty
      ? []
      : notes.where((note) => note.title.toLowerCase().contains(query.toLowerCase()) || 
                              note.description.toLowerCase().contains(query.toLowerCase())).toList();

  if (suggestions.isEmpty) {
    // 필터링된 노트가 없을 때의 처리
    return const Center(child: Text('검색어를 입력해 보세요.'));
  }

  // 필터링된 노트를 기반으로 제안을 보여주는 ListView.builder를 반환합니다.
  return ListView.builder(
    itemCount: suggestions.length,
    itemBuilder: (context, index) {
      final note = suggestions[index];
      final creationDateFormatted = formatDateTime(note.creationDate);
      return ListTile(
        title: Text(note.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('작성일: $creationDateFormatted\n${note.description}', 
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        isThreeLine: true,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NoteDetailPage(note: note)),
          );
        },
      );
    },
  );
}
}
