import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart' as chat_ui;
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import 'Chat_menu/dm_chat_menu_setting.dart';
import 'dm_call_page.dart';
import 'dm_chat_search_page.dart';

class ChatPage extends StatefulWidget {
  final String? chatRoomId;
  final String? userName;

  const ChatPage({Key? key, required this.chatRoomId, required this.userName}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<types.Message> _messages = [];
  late final types.User _user;
  final TextEditingController _messageController = TextEditingController();
  late final KeyboardVisibilityController _keyboardVisibilityController;
  bool _isTyping = false;
  Set<String> _readBy = {}; // 읽은 사람들의 ID를 저장하는 Set

  @override
  void initState() {
    super.initState();
    _user = types.User(id: const Uuid().v4(), firstName: 'User');
    _keyboardVisibilityController = KeyboardVisibilityController();
    _keyboardVisibilityController.onChange.listen((bool visible) {
      setState(() {
        _isTyping = visible;
      });
    });
  }

  void _sendMessage(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
      status: types.Status.sent,
    );

    setState(() {
      _messages.insert(0, textMessage);
      _readBy.clear();
    });
  }

  void _sendAttachment(String fileType) async {
    final ImagePicker _picker = ImagePicker();
    XFile? pickedFile;

    if (fileType == 'image') {
      pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    } else if (fileType == 'video') {
      pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
    }

    if (pickedFile != null) {
      final fileMessage = types.FileMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        name: pickedFile.name,
        size: await pickedFile.length(),
        uri: pickedFile.path,
        status: types.Status.sent,
      );

      setState(() {
        _messages.insert(0, fileMessage);
        _readBy.clear();
      });
    }
  }

  void _markAsRead(BuildContext context, types.Message message) {
    setState(() {
      _readBy.add(_user.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userName ?? ''),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => DMCallPage()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: ChatSearchPage(messages: _messages));
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ChatMenuSettingPage()));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: chat_ui.Chat(
              messages: _messages,
              onSendPressed: (partialText) {
                _sendMessage(partialText as types.PartialText);
              },
              user: _user,
              showUserAvatars: true,
              showUserNames: true,
              theme: myChatTheme,
              l10n: myChatL10n,
              onMessageTap: _markAsRead,
              customMessageBuilder: (types.CustomMessage message, {required int messageWidth}) {
                final readByCount = _readBy.length;

                return Stack(
                  children: [
                    chat_ui.Message(
                      message: message,
                      messageWidth: messageWidth,
                      emojiEnlargementBehavior: chat_ui.EmojiEnlargementBehavior.single,
                      hideBackgroundOnEmojiMessages: false,
                      roundBorder: true,
                      showAvatar: true,
                      showName: true,
                      showStatus: true,
                      isLeftStatus: true,
                      showUserAvatars: true,
                      usePreviewData: true,
                      textMessageOptions: chat_ui.TextMessageOptions(),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Row(
                        children: [
                          Icon(
                            readByCount > 0 ? Icons.done_all : Icons.done,
                            size: 16,
                            color: readByCount > 0 ? Colors.blue : Colors.grey,
                          ),
                          Text(
                            readByCount.toString(),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          _buildMessageInputBar(),
        ],
      ),
    );
  }

  Widget _buildMessageInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.attach_file),
            onPressed: () {
              _sendAttachment('file');
            },
          ),
          IconButton(
            icon: const Icon(Icons.image),
            onPressed: () {
              _sendAttachment('image');
            },
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: "메시지 입력...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                onSubmitted: (value) => _sendMessage(types.PartialText(text: value)),
                autofocus: true,
                maxLines: null,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              _sendMessage(types.PartialText(text: _messageController.text));
              _messageController.clear();
            },
          ),
        ],
      ),
    );
  }
}

final myChatTheme = chat_ui.DefaultChatTheme(
  backgroundColor: Colors.white,
  inputBackgroundColor: Colors.grey[200]!,
  inputTextColor: Colors.black,
  primaryColor: Colors.blue,
  secondaryColor: Colors.grey[300]!,
);

const myChatL10n = chat_ui.ChatL10nKo(
  and: '및',
  attachmentButtonAccessibilityLabel: '미디어 보내기',
  emptyChatPlaceholder: '주고받은 메시지가 없습니다',
  fileButtonAccessibilityLabel: '파일',
  inputPlaceholder: '메시지',
  isTyping: '님이 입력 중...',
  others: '개',
  sendButtonAccessibilityLabel: '보내기',
  unreadMessagesLabel: '읽지 않은 메시지',
);
