import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

import 'votePage.dart'; // votePage.dart를 import 합니다.

class ChatPage extends StatefulWidget {
  final String? chatRoomId;
  final String? userName;

  const ChatPage({Key? key, required this.chatRoomId, required this.userName})
      : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<types.Message> _messages = [];
  late final types.User _user;
  final TextEditingController _messageController = TextEditingController();
  bool _showMenu = false; // 메뉴 표시 여부
  Set<String> _readBy = {}; // 읽은 사람들의 ID를 저장하는 Set
  Set<String> _reactionsVisibleFor = {}; // 반응을 표시하는 메시지 ID
  Map<String, String> _messageReactions = {}; // 각 메시지의 반응
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

  void _sendAttachment(String fileType) async {
    final status = await _requestPermission(fileType);
    if (!status) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Permission denied for $fileType'),
      ));
      return;
    }

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
      });
    }
  }

  Future<bool> _requestPermission(String fileType) async {
    Permission permission;
    if (fileType == 'image' || fileType == 'video') {
      permission = Permission.photos;
    } else if (fileType == 'file') {
      permission = Permission.storage;
    } else if (fileType == 'map') {
      permission = Permission.location;
    } else {
      return false;
    }

    final status = await permission.request();
    return status == PermissionStatus.granted;
  }

  void _toggleMenu() {
    setState(() {
      _showMenu = !_showMenu;
    });
  }

  void _reactToMessage(types.Message message, String reaction) {
    setState(() {
      if (_messageReactions[message.id] == reaction) {
        _messageReactions.remove(message.id);
      } else {
        _messageReactions[message.id] = reaction;
      }
      _toggleReactionsVisibility(message.id);
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
    ));
  }

  void _shareMessage(String text) {
    Share.share(text);
  }

  void _selectCopyMessage(String text) {
    // 선택 복사 기능 로직 추가
    // 원하는 방식으로 선택 복사 기능 구현
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Message selected and copied to clipboard'),
    ));
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
        SnackBar(content: Text('Messages can only be canceled within 10 minutes of sending')),
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
              // 공감 아이콘들
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.thumb_up),
                    onPressed: () {
                      _reactToMessage(message, 'like');
                      Navigator.pop(context);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.favorite),
                    onPressed: () {
                      _reactToMessage(message, 'love');
                      Navigator.pop(context);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.sentiment_satisfied),
                    onPressed: () {
                      _reactToMessage(message, 'happy');
                      Navigator.pop(context);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.sentiment_dissatisfied),
                    onPressed: () {
                      _reactToMessage(message, 'sad');
                      Navigator.pop(context);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.check_circle),
                    onPressed: () {
                      _reactToMessage(message, 'confirm');
                      Navigator.pop(context);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () {
                      _reactToMessage(message, 'cancel');
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              // 기능들
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
                    _selectCopyMessage(message.text);
                  } else if (message is types.FileMessage) {
                    _selectCopyMessage(message.name);
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

  void _toggleReactionsVisibility(String messageId) {
    setState(() {
      if (_reactionsVisibleFor.contains(messageId)) {
        _reactionsVisibleFor.remove(messageId);
      } else {
        _reactionsVisibleFor.add(messageId);
      }
    });
  }

  void _createVote(Map<String, dynamic> voteData) {
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
  }

  Widget _buildReactions(types.Message message) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.thumb_up),
          onPressed: () {
            _reactToMessage(message, 'like');
            _toggleReactionsVisibility(message.id);
          },
        ),
        IconButton(
          icon: const Icon(Icons.favorite),
          onPressed: () {
            _reactToMessage(message, 'love');
            _toggleReactionsVisibility(message.id);
          },
        ),
        IconButton(
          icon: const Icon(Icons.sentiment_satisfied),
          onPressed: () {
            _reactToMessage(message, 'happy');
            _toggleReactionsVisibility(message.id);
          },
        ),
        IconButton(
          icon: const Icon(Icons.sentiment_dissatisfied),
          onPressed: () {
            _reactToMessage(message, 'sad');
            _toggleReactionsVisibility(message.id);
          },
        ),
        IconButton(
          icon: const Icon(Icons.check_circle),
          onPressed: () {
            _reactToMessage(message, 'confirm');
            _toggleReactionsVisibility(message.id);
          },
        ),
        IconButton(
          icon: const Icon(Icons.cancel),
          onPressed: () {
            _reactToMessage(message, 'cancel');
            _toggleReactionsVisibility(message.id);
          },
        ),
      ],
    );
  }

  Widget _buildReactionsSummary(types.Message message) {
    final reactions = _messageReactions.entries.where((entry) => entry.key == message.id).toList();
    if (reactions.isEmpty) {
      return Container();
    }
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Row(
        children: reactions.map((entry) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: Row(
              children: [
                Icon(_getReactionIcon(entry.value), size: 14),
                Text(' 1', style: TextStyle(fontSize: 12)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAttachmentMenu() {
    return _showMenu
        ? Container(
            color: Colors.white,
            padding: const EdgeInsets.all(8.0),
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
                    MaterialPageRoute(builder: (context) => VotePage(onVoteCreated: _createVote)),
                  );
                }),
                _buildMenuButton(Icons.event, '일정', () {
                  // 일정 기능 추가 로직
                }),
                _buildMenuButton(Icons.phone, '통화', () {
                  Navigator.push(
                      context,
                      MaterialPageRoute<Widget>(
                          builder: (context) => Scaffold(
                              appBar: AppBar(title: const Text('DMCallPage')))));
                }),
                _buildMenuButton(Icons.map, '지도', () async {
                  final status = await _requestPermission('map');
                  if (status) {
                    // 지도 기능 추가 로직
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Permission denied for map'),
                    ));
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
      ))
        : null;

    return Column(
      children: [
        if (isNewDay)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              _formatDate(createdAt),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        GestureDetector(
          onTap: () => _toggleReactionsVisibility(message.id),
          onLongPress: () => _showMessageOptions(message),
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
                              ? replyMessage.text.substring(0, 20) + '...'
                              : replyMessage.text)
                          : 'Attachment',
                      style: const TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ),
                const SizedBox(height: 4),
                if (_reactionsVisibleFor.contains(message.id)) _buildReactions(message),
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
                        boxShadow: [
                          const BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4.0,
                            spreadRadius: 2.0,
                            offset: Offset(2.0, 2.0),
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

  Widget _buildVoteMessage(Map<String, dynamic> voteData) {
    return Text('Vote: ${voteData['question']}');
  }

  Widget _buildModernChatBar() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          if (_replyingTo != null)
            Container(
              padding: const EdgeInsets.all(8.0),
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
                          ? (_replyingTo as types.TextMessage).text
                          : 'Attachment',
                      style: TextStyle(color: Colors.black),
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
                icon: Icon(Icons.add, color: Colors.blue),
                onPressed: _toggleMenu,
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send, color: Colors.blue),
                onPressed: _sendMessage,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userName ?? 'Chat'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
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
  final List<types.Message> messages;
  final types.User user;

  ChatSearchPage({required this.messages, required this.user});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [IconButton(onPressed: () => query = '', icon: Icon(Icons.clear))];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null), 
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = messages
        .where((message) => message is types.TextMessage
            ? (message as types.TextMessage)
                .text
                .toLowerCase()
                .contains(query.toLowerCase())
            : false)
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
            style: TextStyle(fontSize: 12),
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = messages
        .where((message) => message is types.TextMessage
            ? (message as types.TextMessage)
                .text
                .toLowerCase()
                .contains(query.toLowerCase())
            : false)
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
            style: TextStyle(fontSize: 12),
          ),
        );
      },
    );
  }
}
