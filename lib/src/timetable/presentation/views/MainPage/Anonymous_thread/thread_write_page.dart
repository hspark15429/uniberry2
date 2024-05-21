import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uniberry2/src/timetable/presentation/views/MainPage/Anonymous_thread/SurveyWritePage.dart';
import 'package:uniberry2/src/timetable/presentation/views/MainPage/Anonymous_thread/dummy_data.dart';

class ThreadWritePage extends StatefulWidget {
  const ThreadWritePage({Key? key}) : super(key: key);

  @override
  _ThreadWritePageState createState() => _ThreadWritePageState();
}

class _ThreadWritePageState extends State<ThreadWritePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final List<String> _categories = BoardType.values.map((type) => boardTypeToString(type)).toList();

  String? _selectedCategory;
  BoardType? _selectedBoardType;
  XFile? _image;
  List<XFile> _attachments = [];
  Position? _currentPosition;
  String _author = '현재 사용자'; // 작성자 정보 (여기서는 임시로 현재 사용자로 설정)


  Future<void> _pickImage() async {
    final status = await Permission.photos.request();
    if (status.isGranted) {
      final ImagePicker _picker = ImagePicker();
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = image;
      });
    } else {
      _showPermissionDeniedDialog();
    }
  }

  Future<void> _pickAttachments() async {
    final status = await Permission.photos.request();
    if (status.isGranted) {
      final ImagePicker _picker = ImagePicker();
      final List<XFile>? images = await _picker.pickMultiImage();
      if (images != null) {
        setState(() {
          _attachments.addAll(images);
        });
      }
    } else {
      _showPermissionDeniedDialog();
    }
  }

  Future<void> _getCurrentLocation() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      final Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
      });
    } else {
      _showPermissionDeniedDialog();
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('권한 거부됨'),
        content: const Text('이 기능을 사용하려면 권한이 필요합니다. 설정에서 권한을 허용해주세요.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void _showPreview() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('게시글 미리보기'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '#${_selectedBoardType != null ? boardTypeToString(_selectedBoardType!) : '카테고리 없음'}',
                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                _titleController.text,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(_contentController.text),
              const SizedBox(height: 8),
              if (_image != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(File(_image!.path)),
                ),
              if (_attachments.isNotEmpty)
                ..._attachments.map((file) => Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(File(file.path)),
                      ),
                    )).toList(),
              if (_currentPosition != null)
                Text(
                  '위치: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}',
                  style: const TextStyle(fontSize: 16),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('닫기'),
          ),
        ],
      ),
    );
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: DropdownButton<String>(
          value: '게시물 작성',
          dropdownColor: Colors.black,
          items: ['게시물 작성', '설문조사 작성'].map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: const TextStyle(color: Colors.white)),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue == '설문조사 작성') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SurveyWritePage(
                    theme: defaultSurveyTheme,
                    titleController: TextEditingController(),
                    descriptionController: TextEditingController(),
                  ),
                ),
              );
            }
          },
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DropdownButtonFormField<String>(
              value: _selectedBoardType != null ? boardTypeToString(_selectedBoardType!) : null,
              decoration: const InputDecoration(
                hintText: '카테고리 선택',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedBoardType = BoardType.values.firstWhere(
                    (type) => boardTypeToString(type) == newValue,
                  );
                });
              },
              items: _categories.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: '제목',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '제목을 입력해주세요';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _contentController,
              maxLines: 10,
              decoration: const InputDecoration(
                labelText: '내용',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_image != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(File(_image!.path)),
                ),
              ),
            Wrap(
              spacing: 10,
              children: [
                IconButton(
                  icon: const Icon(Icons.image, color: Colors.black),
                  onPressed: _pickImage,
                ),
                IconButton(
                  icon: const Icon(Icons.attach_file, color: Colors.black),
                  onPressed: _pickAttachments,
                ),
                IconButton(
                  icon: const Icon(Icons.location_on, color: Colors.black),
                  onPressed: _getCurrentLocation,
                ),
                IconButton(
                  icon: const Icon(Icons.poll, color: Colors.black),
                  onPressed: () {
                    // TODO: 투표 추가 기능 구현
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: _showPreview,
              child: const Text('미리보기', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              ),
             onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // 새로운 게시글 추가
                  final newPost = Post(
                    id: DateTime.now().toString(), // 임시로 현재 시간을 ID로 사용
                    category: _selectedBoardType != null ? boardTypeToString(_selectedBoardType!) : '自由',
                    title: _titleController.text,
                    content: _contentController.text,
                    imageUrls: _image != null ? [_image!.path] : [],
                    boardType: _selectedBoardType ?? BoardType.free,
                    commentCount: 0,
                    datePosted: DateTime.now().toString(),
                    viewCount: 0,
                    author: _author, // 작성자 정보 포함
                  );
                  setState(() {
                    dummyPosts.add(newPost);
                  });

                  // 페이지 닫기
                  Navigator.pop(context);
                }
              },
              child: const Text('게시물 작성', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
