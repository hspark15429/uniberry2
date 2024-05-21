import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import  'Chat_menu/dm_chat_keyboard_page.dart' ;
import 'Chat_menu/dm_chat_menu_setting.dart';
import 'dm_call_page.dart';
import 'dm_chat_search_page.dart';




class DmChatPage extends StatelessWidget {
  const DmChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DM Chat'),
      ),
      body: DmChatKeyboard(), // DmChatKeyboard 위젯을 직접 호출
    );
  }
}


enum FileType {
  image,
  video,
  any,
}

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

@override
  void initState() {
    super.initState();
    _user = types.User(id: Uuid().v4());
    _keyboardVisibilityController = KeyboardVisibilityController();
    _keyboardVisibilityController.onChange.listen((bool visible) {
      // 여기에 키보드 가시성 변화에 따른 로직 추가
    });
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text(widget.userName ?? ''),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CupertinoButton(
              child: Icon(CupertinoIcons.phone),
              onPressed: _handleCallPressed,
              padding: EdgeInsets.zero,
            ),
            CupertinoButton(
              child: Icon(CupertinoIcons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: ChatSearchPage(messages: _messages),
                );
              },
              padding: EdgeInsets.zero,
            ),
            CupertinoButton(
              child: Icon(CupertinoIcons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatMenuSettingPage()),
                );
              },
              padding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                if (message is types.ImageMessage) {
                  return Image.network(message.uri);
                } else if (message is types.VideoMessage) {
                  return Container(child: Text("비디오 메시지입니다. 비디오 플레이어 구현 필요."));
                } else if (message is types.FileMessage) {
                  return ListTile(
                    leading: Icon(Icons.attach_file),
                    title: Text(message.name),
                    onTap: () {
                      // 파일 열기 또는 다운로드 로직 구현
                    },
                  );
                }
                return SizedBox.shrink();
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
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.attach_file),
            onPressed: _handleAttachmentPressed,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(hintText: "메시지 입력..."),
                onSubmitted: (value) => _sendMessage(),
                autofocus: true,
                maxLines: null,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      _handleSendPressed(types.PartialText(text: _messageController.text));
      _messageController.clear();
    }
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: Uuid().v4(),
      text: message.text,
    );

    setState(() {
      _messages.insert(0, textMessage);
    });
  }

  void _handleCallPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DMCallPage()),
    );
  }

  void _handleAttachmentPressed() async {
    final ImagePicker _picker = ImagePicker();
    final pickedFileType = await showModalBottomSheet<FileType>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Photo'),
                onTap: () => Navigator.of(context).pop(FileType.image),
              ),
              ListTile(
                leading: Icon(Icons.videocam),
                title: Text('Video'),
                onTap: () => Navigator.of(context).pop(FileType.video),
              ),
              ListTile(
                leading: Icon(Icons.insert_drive_file),
                title: Text('File'),
                onTap: () => Navigator.of(context).pop(FileType.any),
              ),
            ],
          ),
        );
      },
    );


    

    switch (pickedFileType) {
      case FileType.image:
        final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
        if (image != null) {
          _addImageMessage(image);
        }
        break;
      case FileType.video:
        final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
        if (video != null) {
          _addVideoMessage(video);
        }
        break;
      case FileType.any:
        _handleFileSelection();
        break;
      default:
        break;
    }
  }

  void _addImageMessage(XFile image) async {
    final types.ImageMessage imageMessage = types.ImageMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: Uuid().v4(),
      name: image.name,
      size: await image.length(),
      uri: image.path,
    );

    setState(() {
      _messages.insert(0, imageMessage);
    });
  }

  void _addVideoMessage(XFile video) async {
    final types.VideoMessage videoMessage = types.VideoMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: Uuid().v4(),
      name: video.name ?? '',
      size: await video.length(),
      uri: video.path,
    );

    setState(() {
      _messages.insert(0, videoMessage);
    });
  }

  void _handleFileSelection() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      final file = result.files.first;
      // 예: 파일 메시지 추가 로직 구현
      // 파일 메시지 타입이 정의되어 있다고 가정
      final types.FileMessage fileMessage = types.FileMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: Uuid().v4(),
        name: file.name ?? '',
        size: file.size,
        uri: file.path ?? '',
      );

      setState(() {
        _messages.insert(0, fileMessage);
      });
    } else {
      // 사용자가 파일 선택을 취소한 경우
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("파일 선택이 취소되었습니다.")),
      );
    }
  }
}
