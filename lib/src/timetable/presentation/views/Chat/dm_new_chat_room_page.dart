import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class NewChatRoomPage extends StatefulWidget {
  const NewChatRoomPage({Key? key}) : super(key: key);

  @override
  _NewChatRoomPageState createState() => _NewChatRoomPageState();
}

class _NewChatRoomPageState extends State<NewChatRoomPage> {
  final TextEditingController _chatRoomNameController = TextEditingController();
  final List<types.User> _selectedUsers = [];
  final List<types.User> _users = []; // 이 리스트는 실제 앱 사용 시 사용자 목록으로 채워져야 합니다.

  @override
  void initState() {
    super.initState();
    // 여기서 사용자 목록을 초기화하거나 가져옵니다. 예를 들어, 서버에서 사용자 목록을 가져오는 로직 등
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('새 채팅방 만들기'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _chatRoomNameController,
              decoration: InputDecoration(
                labelText: '채팅방 이름',
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final user = _users[index];
                final isSelected = _selectedUsers.contains(user);
                return ListTile(
                  title: Text(user.firstName ?? '알 수 없는 사용자'), // 예제에서는 firstName을 사용합니다. 실제로는 적절한 필드를 사용하세요.
                  trailing: isSelected
                      ? Icon(Icons.check_circle, color: Colors.green)
                      : Icon(Icons.check_circle_outline),
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedUsers.remove(user);
                      } else {
                        _selectedUsers.add(user);
                      }
                    });
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton(
              onPressed: _createNewChatRoom,
              child: Text('채팅방 만들기'),
            ),
          ),
        ],
      ),
    );
  }

  void _createNewChatRoom() {
    // 채팅방 이름과 선택된 사용자 정보를 사용하여 새 채팅방을 생성하는 로직을 구현합니다.
    // 예: 서버에 채팅방 정보를 보내고, 성공적으로 생성된 경우 채팅방 페이지로 이동합니다.
    final String chatRoomName = _chatRoomNameController.text;
    if (chatRoomName.isNotEmpty && _selectedUsers.isNotEmpty) {
      // 서버에 채팅방 생성 요청 로직 추가
      print('채팅방 이름: $chatRoomName, 선택된 사용자 수: ${_selectedUsers.length}');
      // 여기서 채팅방 생성 후 해당 채팅방으로 이동하는 로직을 구현할 수 있습니다.
    } else {
      // 오류 메시지 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("채팅방 이름과 사용자를 선택해주세요.")),
      );
    }
  }
}
