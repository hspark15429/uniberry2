import 'package:flutter/material.dart';
import 'package:uniberry2/src/timetable/presentation/views/Chat/dm_chat_page.dart';
import 'package:uniberry2/src/timetable/presentation/views/Chat/dm_chatgpt_page.dart';
import 'package:uniberry2/src/timetable/presentation/views/Chat/dm_user_search_page.dart';

class ChatUser {

  ChatUser({
    required this.name,
    required this.messageText,
    required this.imageUrl,
    required this.time,
  });
  final String name;
  final String messageText;
  final String imageUrl;
  final String time;
}


class DMListPage extends StatefulWidget {
  const DMListPage({super.key});

   static const String routeName = '/DMListPage';

  @override
  _DMListPageState createState() => _DMListPageState();
}

class _DMListPageState extends State<DMListPage> {
  List<ChatUser> chatUsers = [
    ChatUser(
      name: 'UniberryAI',
      messageText: 'Uniberry AIを試す',
      imageUrl: 'https://img4.yna.co.kr/etc/inner/KR/2023/01/30/AKR20230130074900017_01_i_P4.jpg',
      time: 'Now',
    ),
    ChatUser(
      name: 'UniberryTeam',
      messageText: 'Uniberryにお問合せする！',
      imageUrl: 'https://www.uniberry.site/wp-content/uploads/2024/01/light-3.png',
      time: 'Now',),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('チャットリスト'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const DMUserSearchPage()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('グループトーク作成', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                hintText: '検索',
              ),
            ),
            // 사용자 목록을 표시하는 위젯 추가 예정
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('취소'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('개설하기'),
            onPressed: () {
              // 그룹 채팅방 개설 로직 추가 예정
            },
          ),
        ],
      );
    },
  );
},
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: chatUsers.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(chatUsers[index].imageUrl),
            ),
            title: Text(chatUsers[index].name),
            subtitle: Text(chatUsers[index].messageText),
            trailing: Text(chatUsers[index].time),
            onTap: () {
              // Uniberry 사용자를 탭했을 때 DMChatGPTPage로 이동
              if (chatUsers[index].name == 'UniberryAI') {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const DMChatGPTPage()));
              } else {
                // 다른 사용자를 탭했을 때의 로직
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(
                      chatRoomId: '여기에 적절한 채팅방 ID를 넣거나 다른 식별자 사용',
                      userName: chatUsers[index].name,
                    ),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
