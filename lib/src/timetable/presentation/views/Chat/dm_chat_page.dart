import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uniberry2/src/timetable/presentation/views/Chat/votePage.dart'; // votePage.dart를 import 합니다.
import 'package:uuid/uuid.dart';

class ChatPage extends StatefulWidget {

  const ChatPage({required this.chatRoomId, required this.userName, super.key});
  final String? chatRoomId;
  final String? userName;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<types.Message> _messages = [];
  late final types.User _user;
  final TextEditingController _messageController = TextEditingController();
  bool _showMenu = false; // 메뉴 표시 여부
  final Set<String> _readBy = {}; // 읽은 사람들의 ID를 저장하는 Set
  final Map<String, String> _messageReactions = {}; // 각 메시지의 반응
  types.Message? _replyingTo; // 답장 중인 메시지
  int? _lastDate; // 마지막으로 날짜가 표시된 메시지의 timestamp

  @override
  void initState() {
    super.initState();
    _user = types.User(id: const Uuid().v4(), firstName: 'User');
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      final textMessage = types.TextMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        text: text,
        status: types.Status.sent,
        metadata: _replyingTo != null ? {'replyingTo': _replyingTo!.id} : null,
      );

      setState(() {
        _messages.insert(0, textMessage);
        _messageController.clear();
        _replyingTo = null;
      });
    }
  }

  Future<void> _sendAttachment(String fileType) async {
    final status = await _requestPermission(fileType);
    if (!status) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Permission denied for $fileType'),
      ),);
      return;
    }

    XFile? pickedFile;
    if (fileType == 'image') {
      pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    } else if (fileType == 'file') {
      final result = await FilePicker.platform.pickFiles();
      if (result != null) {
        pickedFile = XFile(result.files.single.path!);
      }
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
      });
    }
  }

  Future<bool> _requestPermission(String fileType) async {
    Permission permission;
    if (fileType == 'image') {
      permission = Permission.photos;
    } else if (fileType == 'file') {
      permission = Permission.storage;
    } else {
      return false;
    }

    final status = await permission.request();
    return status == PermissionStatus.granted;
  }

  void _reactToMessage(types.Message message, String reaction) {
    setState(() {
      if (_messageReactions[message.id] == reaction) {
        _messageReactions.remove(message.id); // 반응 취소
      } else {
        _messageReactions[message.id] = reaction;
      }
    });
  }

  void _replyToMessage(types.Message message) {
    setState(() {
      _replyingTo = message;
    });
  }

  void _copyMessage(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Message copied to clipboard'),
    ),);
  }

  void _shareMessage(String text) {
    Share.share(text);
  }

  void _selectCopyMessage(BuildContext context, String text) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectableTextPage(text: text),
      ),
    );
  }

  void _cancelMessage(types.Message message) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final createdAt = message.createdAt ?? 0;
    final isCancelable = now - createdAt <= 10 * 60 * 1000;

    if (isCancelable) {
      setState(() {
        _messages.remove(message);
        if (_replyingTo?.id == message.id) {
          _replyingTo = null;
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Messages can only be canceled within 10 minutes of sending')),
      );
    }
  }

  String _formatTime(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat.Hm().format(date);
  }

  String _formatDate(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat('yyyy/MM/dd EEEE', 'ko_KR').format(date);
  }

  void _showMessageOptions(types.Message message) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        final isMine = message.author.id == _user.id;

        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(_messageReactions[message.id] == 'like' ? Icons.thumb_up_alt : Icons.thumb_up),
                    onPressed: () {
                      _reactToMessage(message, 'like');
                      Navigator.pop(context);
                    },
                  ),
                  IconButton(
                    icon: Icon(_messageReactions[message.id] == 'love' ? Icons.favorite : Icons.favorite_border),
                    onPressed: () {
                      _reactToMessage(message, 'love');
                      Navigator.pop(context);
                    },
                  ),
                  IconButton(
                    icon: Icon(_messageReactions[message.id] == 'happy' ? Icons.sentiment_satisfied_alt : Icons.sentiment_satisfied),
                    onPressed: () {
                      _reactToMessage(message, 'happy');
                      Navigator.pop(context);
                    },
                  ),
                  IconButton(
                    icon: Icon(_messageReactions[message.id] == 'sad' ? Icons.sentiment_very_dissatisfied : Icons.sentiment_dissatisfied),
                    onPressed: () {
                      _reactToMessage(message, 'sad');
                      Navigator.pop(context);
                    },
                  ),
                  IconButton(
                    icon: Icon(_messageReactions[message.id] == 'confirm' ? Icons.check_circle_outline : Icons.check_circle),
                    onPressed: () {
                      _reactToMessage(message, 'confirm');
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              ListTile(
                leading: const Icon(Icons.reply),
                title: const Text('Reply'),
                onTap: () {
                  _replyToMessage(message);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.copy),
                title: const Text('Copy'),
                onTap: () {
                  if (message is types.TextMessage) {
                    _copyMessage(message.text);
                  } else if (message is types.FileMessage) {
                    _copyMessage(message.name);
                  }
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.select_all),
                title: const Text('Select Copy'),
                onTap: () {
                  if (message is types.TextMessage) {
                    _selectCopyMessage(context, message.text);
                  } else if (message is types.FileMessage) {
                    _selectCopyMessage(context, message.name);
                  }
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Share'),
                onTap: () {
                  if (message is types.TextMessage) {
                    _shareMessage(message.text);
                  } else if (message is types.FileMessage) {
                    _shareMessage(message.name);
                  }
                  Navigator.pop(context);
                },
              ),
              if (isMine)
                ListTile(
                  leading: const Icon(Icons.cancel),
                  title: const Text('Cancel'),
                  onTap: () {
                    _cancelMessage(message);
                    Navigator.pop(context);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReactionsSummary(types.Message message) {
    final reaction = _messageReactions[message.id];
    if (reaction == null) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Row(
        children: [
          Icon(_getReactionIcon(reaction), size: 14),
          const Text(' 1', style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  IconData _getReactionIcon(String reaction) {
    switch (reaction) {
      case 'like':
        return Icons.thumb_up;
      case 'love':
        return Icons.favorite;
      case 'happy':
        return Icons.sentiment_satisfied;
      case 'sad':
        return Icons.sentiment_dissatisfied;
      case 'confirm':
        return Icons.check_circle;
      case 'cancel':
        return Icons.cancel;
      default:
        return Icons.thumb_up;
    }
  }

  Widget _buildMessageItem(types.Message message) {
    final isMine = message.author.id == _user.id;
    final alignment = isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final color = isMine ? Colors.blue[100] : Colors.grey[200];
    final icon = _readBy.contains(message.id) ? Icons.done_all : Icons.done;

    final createdAt = message.createdAt ?? DateTime.now().millisecondsSinceEpoch;
    final createdAtDate = DateTime.fromMillisecondsSinceEpoch(createdAt);

    // 날짜가 바뀔 때마다 중앙에 날짜 표시
    final isNewDay = _lastDate == null || _lastDate != createdAtDate.day;
    if (isNewDay) {
      _lastDate = createdAtDate.day;
    }

    final replyMessage = message.metadata?['replyingTo'] != null
        ? _messages.firstWhere((msg) => msg.id == message.metadata?['replyingTo'], orElse: () => types.TextMessage(
      author: _user,
      createdAt: 0,
      id: '',
      text: '삭제된 메시지입니다.',
      status: types.Status.sent,
    ),)
        : null;

    return Column(
      children: [
        if (isNewDay)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              _formatDate(createdAt),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        GestureDetector(
          onDoubleTap: () => _showMessageOptions(message),
          onLongPress: () {
            if (message is types.TextMessage) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SelectableTextPage(text: message.text),
                ),
              );
            }
          },
          child: Container(
            margin: isMine
                ? const EdgeInsets.only(left: 50, right: 8, top: 5, bottom: 5)
                : const EdgeInsets.only(left: 8, right: 50, top: 5, bottom: 5),
            child: Column(
              crossAxisAlignment: alignment,
              children: [
                if (replyMessage != null)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      replyMessage is types.TextMessage
                          ? (replyMessage.text.length > 20
                          ? '${replyMessage.text.substring(0, 20)}...'
                          : replyMessage.text)
                          : 'Attachment',
                      style: const TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    if (!isMine)
                      const CircleAvatar(
                        backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                        radius: 15,
                      ),
                    if (!isMine)
                      const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            spreadRadius: 2,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: alignment,
                        children: [
                          if (!isMine)
                            Text(
                              message.author.firstName ?? 'User',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          if (!isMine)
                            const SizedBox(height: 5),
                          if (message is types.TextMessage)
                            Text(
                              message.text,
                              style: const TextStyle(fontSize: 16),
                            ),
                          if (message is types.FileMessage)
                            Text(
                              message.name,
                              style: const TextStyle(fontSize: 16),
                            ),
                          if (message is types.CustomMessage) ...[
                            _buildVoteMessage(message.metadata!),
                            const SizedBox(height: 5),
                          ],
                        ],
                      ),
                    ),
                    if (isMine)
                      const SizedBox(width: 10),
                    if (isMine)
                      const CircleAvatar(
                        backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                        radius: 15,
                      ),
                  ],
                ),
                Row(
                  mainAxisAlignment: isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    _buildReactionsSummary(message),
                    Text(
                      _formatTime(createdAt),
                      style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                    ),
                    if (isMine)
                      Icon(
                        icon,
                        size: 12,
                        color: Colors.grey[600],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVoteMessage(Map<String, dynamic> voteData) {
    return Text('Vote: ${voteData['question']}');
  }

  Widget _buildModernChatBar() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          if (_replyingTo != null)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _replyingTo!.author.id == _user.id
                          ? '나에게 답장'
                          : '${_replyingTo!.author.firstName}에게 답장',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      _replyingTo is types.TextMessage
                          ? (_replyingTo! as types.TextMessage).text
                          : 'Attachment',
                      style: const TextStyle(color: Colors.black),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.grey[600]),
                    onPressed: () {
                      setState(() {
                        _replyingTo = null;
                      });
                    },
                  ),
                ],
              ),
            ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.add, color: Colors.blue),
                onPressed: () => setState(() => _showMenu = !_showMenu),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message',
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send, color: Colors.blue),
                onPressed: _sendMessage,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentMenu() {
    return _showMenu
        ? Container(
            color: Colors.white,
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _buildMenuButton(Icons.attach_file, '파일', () {
                  _sendAttachment('file');
                }),
                _buildMenuButton(Icons.image, '사진', () {
                  _sendAttachment('image');
                }),
                _buildMenuButton(Icons.poll, '투표', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VotePage(onVoteCreated: (voteData) {
                        final voteMessage = types.CustomMessage(
                          author: _user,
                          createdAt: DateTime.now().millisecondsSinceEpoch,
                          id: const Uuid().v4(),
                          metadata: voteData,
                          status: types.Status.sent,
                        );

                        setState(() {
                          _messages.insert(0, voteMessage);
                        });
                      },),
                    ),
                  );
                }),
                _buildMenuButton(Icons.event, '일정', () {
                  // 일정 기능 추가 로직
                }),
                _buildMenuButton(Icons.phone, '통화', () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Scaffold(
                              appBar: AppBar(title: const Text('DMCallPage')),),),);
                }),
                _buildMenuButton(Icons.map, '지도', () async {
                  final status = await _requestPermission('map');
                  if (status) {
                    // 지도 기능 추가 로직
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Permission denied for map'),
                    ),);
                  }
                }),
              ],
            ),
          )
        : Container();
  }

  Widget _buildMenuButton(IconData icon, String label, VoidCallback onPressed) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon),
          onPressed: onPressed,
        ),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userName ?? 'Chat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ChatSearchPage(messages: _messages, user: _user),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageItem(message);
              },
            ),
          ),
          _buildAttachmentMenu(),
          _buildModernChatBar(),
        ],
      ),
    );
  }
}

class ChatSearchPage extends SearchDelegate<types.Message?> {

  ChatSearchPage({required this.messages, required this.user});
  final List<types.Message> messages;
  final types.User user;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear))];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = messages
        .where((message) => message is types.TextMessage
            ? message
                .text
                .toLowerCase()
                .contains(query.toLowerCase())
            : false,)
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final message = results[index] as types.TextMessage;
        final createdAt = message.createdAt ?? DateTime.now().millisecondsSinceEpoch;
        return ListTile(
          title: Text(message.text),
          subtitle: Text(
            'by ${message.author.firstName}, at ${DateTime.fromMillisecondsSinceEpoch(createdAt).toLocal()}',
            style: const TextStyle(fontSize: 12),
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = messages
        .where((message) => message is types.TextMessage
            ? message
                .text
                .toLowerCase()
                .contains(query.toLowerCase())
            : false,)
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final message = suggestions[index] as types.TextMessage;
        final createdAt = message.createdAt ?? DateTime.now().millisecondsSinceEpoch;
        return ListTile(
          title: Text(message.text),
          subtitle: Text(
            'by ${message.author.firstName}, at ${DateTime.fromMillisecondsSinceEpoch(createdAt).toLocal()}',
            style: const TextStyle(fontSize: 12),
          ),
        );
      },
    );
  }
}

class SelectableTextPage extends StatelessWidget {

  const SelectableTextPage({required this.text, super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selectable Text'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SelectableText(
          text,
          style: const TextStyle(fontSize: 16),
          showCursor: true,
          cursorColor: Colors.blue,
          cursorRadius: const Radius.circular(2),
          toolbarOptions: const ToolbarOptions(
            copy: true,
            selectAll: true,
          ),
        ),
      ),
    );
  }
}
