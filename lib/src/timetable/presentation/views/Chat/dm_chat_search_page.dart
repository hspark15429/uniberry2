
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ChatSearchPage extends SearchDelegate<String> {
  final List<types.Message> messages;

  ChatSearchPage({required this.messages});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }


Widget buildLeading(BuildContext context) {
  return IconButton(
    icon: Icon(Icons.arrow_back),
    onPressed: () {
      // null 대신 빈 문자열을 반환
      close(context, '');
    },
  );
}

  @override
  Widget buildResults(BuildContext context) {
    final results = messages.where((msg) {
      if (msg is types.TextMessage) {
        return msg.text.toLowerCase().contains(query.toLowerCase());
      }
      return false;
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final msg = results[index];
        if (msg is types.TextMessage) {
          return ListTile(
            title: Text(msg.text),
            // 여기서 추가적인 UI 구성 요소를 제공할 수 있습니다.
          );
        }
        return Container(); // 비 텍스트 메시지 처리
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // 사용자가 타이핑을 시작하면 호출됩니다. 여기서 제안을 표시할 수 있습니다.
    return Container();
  }
}
