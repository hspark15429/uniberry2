import 'package:flutter/material.dart';

class DmChatKeyboard extends StatefulWidget {
  const DmChatKeyboard({Key? key}) : super(key: key);

  @override
  _DmChatKeyboardState createState() => _DmChatKeyboardState();
}

class _DmChatKeyboardState extends State<DmChatKeyboard> {
  final TextEditingController _textEditingController = TextEditingController();
  final List<String> _messages = [];

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // 수정: 키보드에 의한 UI 변형을 허용
      appBar: AppBar(
        title: Text('DM Chat Keyboard'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                // 메시지를 뒤집어서 표시
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(_messages[_messages.length - 1 - index]),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      labelText: 'Enter message',
                    ),
                    onSubmitted: (value) { // 추가: 엔터키 입력 시 메시지 전송
                      _sendMessage();
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

void _sendMessage() {
    final text = _textEditingController.text;
    if (text.isNotEmpty) {
      setState(() {
        _messages.add(text); // 메시지 추가
        _textEditingController.clear(); // 입력 필드 초기화
      });
    }
}
}