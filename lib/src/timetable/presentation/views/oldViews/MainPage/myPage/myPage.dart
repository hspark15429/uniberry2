import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uniberry2/src/timetable/presentation/views/oldViews/MainPage/freemarketPage/freemarkget_itemDetailPage.dart';
import 'package:uniberry2/src/timetable/presentation/views/oldViews/settiing/setting_page.dart';

class MyPage extends StatefulWidget {
  const MyPage({required this.favoriteProducts, super.key});
  final List<Map<String, dynamic>> favoriteProducts;

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> with SingleTickerProviderStateMixin {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  List<Map<String, dynamic>> favoriteProducts = [];
  String nickname = '익명';
  bool nicknameSet = false;
  int selectedIndex = -1; // 기본값을 -1로 설정
  int selectedListIndex = -1;

  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  final List<String> tabTitles = [
    '내가 작성한 컨텐츠',
    '커뮤니티',
    'Freemarket',
    '업적',
  ];

  final List<Widget> tabs = [
    const ContentTab(),
    const CommunityTab(),
    const FreeMarketTab(),
    const AchievementsTab(),
  ];

  @override
  void initState() {
    super.initState();
    favoriteProducts = widget.favoriteProducts;

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, 0.5),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _pickColor(BuildContext context) async {
    unawaited(
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('색상 선택'),
            content: SingleChildScrollView(
              child: BlockPicker(
                pickerColor: Colors.purple[100],
                onColorChanged: (Color color) {
                  setState(() {
                    _image = null; // 이미지를 제거하는 것이 의도한 동작인지 확인하세요.
                  });
                  Navigator.of(context).pop();
                },
              ),
            ),
          );
        },
      ),
    );
  }

  void _toggleFavorite(Map<String, dynamic> product) {
    setState(() {
      if (favoriteProducts.any((item) => item['name'] == product['name'])) {
        favoriteProducts.removeWhere((item) => item['name'] == product['name']);
      } else {
        favoriteProducts.add(product);
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      if (selectedIndex == index) {
        selectedIndex = -1; // 현재 선택된 탭을 다시 선택하면 초기화
      } else {
        selectedIndex = index;
        _controller.forward(from: 0);
      }
      selectedListIndex = -1; // 리스트 인덱스를 초기화
    });
  }

  void _onListTapped(int index) {
    setState(() {
      selectedListIndex = index;
    });
  }

  void _setNickname(String newNickname) {
    setState(() {
      nickname = newNickname;
      nicknameSet = true;
    });
  }

  void _showNicknameDialog(BuildContext context) {
    final nicknameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('닉네임 설정'),
          content: TextField(
            controller: nicknameController,
            decoration: const InputDecoration(hintText: '닉네임을 입력하세요'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                _setNickname(nicknameController.text);
                Navigator.of(context).pop();
              },
              child: const Text('설정'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Page', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Hello, ',
                        style: TextStyle(fontSize: 20), // 글씨 크기 줄임
                      ),
                      Text(
                        nickname,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold), // 글씨 크기 줄임
                      ),
                      if (!nicknameSet)
                        TextButton(
                          onPressed: () {
                            _showNicknameDialog(context);
                          },
                          child: const Text('닉네임 설정'),
                        ),
                    ],
                  ),
                  const Text(
                    'Have a nice day!',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return SafeArea(
                        child: Wrap(
                          children: <Widget>[
                            ListTile(
                              leading: const Icon(Icons.photo_library),
                              title: const Text('사진 선택'),
                              onTap: () {
                                _pickImage();
                                Navigator.of(context).pop();
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.color_lens),
                              title: const Text('배경색 선택'),
                              onTap: () {
                                _pickColor(context);
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.purple[100],
                  backgroundImage: _image != null ? FileImage(_image!) : null,
                  child: _image == null
                      ? const Icon(Icons.person, size: 40, color: Colors.white)
                      : null,
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'assets/images/start_img.png',
                        width: 40,
                        height: 40,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Text(
                      'Unipay',
                      style: GoogleFonts.roboto(
                        fontSize: 18, // 글씨 크기 줄임
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        '残高: ￥100,000',
                        style: GoogleFonts.roboto(
                          fontSize: 18, // 글씨 크기 줄임
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        // チャージ 버튼 로직
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.add_circle),
                          SizedBox(width: 5),
                          Text('チャージ', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        // 口座振り込み 버튼 로직
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.credit_card),
                          SizedBox(width: 5),
                          Text('口座振り込み', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: selectedIndex == -1
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(tabTitles.length, (index) {
                      return GestureDetector(
                        onTap: () => _onItemTapped(index),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            tabTitles[index],
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold), // 글씨 크기 줄임
                          ),
                        ),
                      );
                    }),
                  )
                : GestureDetector(
                    onTap: () => _onItemTapped(selectedIndex),
                    child: Center(
                      child: Text(
                        tabTitles[selectedIndex],
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold), // 글씨 크기 줄임
                      ),
                    ),
                  ),
          ),
          const Divider(),
          if (selectedIndex != -1)
            SlideTransition(
              position: _offsetAnimation,
              child: tabs[selectedIndex],
            ),
          if (selectedIndex == 2) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.favorite),
                        onPressed: () {
                          _onListTapped(0); // 좋아요 목록 인덱스
                        },
                      ),
                      const Text('좋아요 목록'),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.shopping_cart),
                        onPressed: () {
                          _onListTapped(1); // 구입 리스트 인덱스
                        },
                      ),
                      const Text('구입 리스트'),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.sell),
                        onPressed: () {
                          _onListTapped(2); // 판매 리스트 인덱스
                        },
                      ),
                      const Text('판매 리스트'),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(),
            if (selectedListIndex == 0) ...[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '좋아요 목록',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold), // 글씨 크기 줄임
                  ),
                ),
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: favoriteProducts.length,
                itemBuilder: (context, index) {
                  final product = favoriteProducts[index];
                  return ListTile(
                    leading: Image.network(
                      product['image'] as String,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(product['name'] as String),
                    subtitle: Text('¥${product['price'] as int}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FreeMarketItemDetailPage(
                            product: product,
                            onFavoriteToggle: _toggleFavorite,
                            isFavorited: true,
                            favoriteProducts: favoriteProducts,
                            products: const [],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ] else if (selectedListIndex == 1) ...[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '구입 리스트',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold), // 글씨 크기 줄임
                  ),
                ),
              ),
              // 구입 리스트 화면을 구현하세요.
            ] else if (selectedListIndex == 2) ...[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '판매 리스트',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold), // 글씨 크기 줄임
                  ),
                ),
              ),
              // 판매 리스트 화면을 구현하세요.
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildListTile(BuildContext context, IconData icon, String label) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(label, style: const TextStyle(color: Colors.black)),
      onTap: () {
        // 각 리스트 타일의 로직
      },
    );
  }
}

class ContentTab extends StatelessWidget {
  const ContentTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildContentSection(context, '내가 작성한 게시물', const PostsTab()),
        const Divider(),
        _buildContentSection(context, '내가 작성한 댓글', const CommentsTab()),
      ],
    );
  }

  Widget _buildContentSection(
      BuildContext context, String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            title,
            style: GoogleFonts.roboto(
              fontSize: 18, // 글씨 크기 줄임
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: content,
        ),
      ],
    );
  }
}

class CommunityTab extends StatelessWidget {
  const CommunityTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Align(),
          ),
        ],
      ),
    );
  }
}

class AchievementsTab extends StatelessWidget {
  const AchievementsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '업적',
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold), // 글씨 크기 줄임
              ),
            ),
          ),
          // 업적 화면을 구현하세요.
        ],
      ),
    );
  }
}

class FreeMarketTab extends StatelessWidget {
  const FreeMarketTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Align(),
          ),
        ],
      ),
    );
  }
}

class PostsTab extends StatelessWidget {
  const PostsTab({super.key});

  @override
  Widget build(BuildContext context) {
    var hasPosts = false;
    return Center(
      child: hasPosts ? Text('내가 작성한 게시물이 있습니다.') : Text('작성한 게시물이 없습니다.'),
    );
  }
}

class CommentsTab extends StatelessWidget {
  const CommentsTab({super.key});

  @override
  Widget build(BuildContext context) {
    const hasComments = false;
    return const Center(
      child: hasComments ? Text('내가 작성한 댓글이 있습니다.') : Text('작성한 댓글이 없습니다.'),
    );
  }
}

class FavoriteProductsPage extends StatelessWidget {
  const FavoriteProductsPage({
    required this.favoriteProducts,
    required this.onFavoriteToggle,
    required this.products,
    super.key,
  });
  final List<Map<String, dynamic>> favoriteProducts;
  final Function(Map<String, dynamic>) onFavoriteToggle;
  final List<Map<String, dynamic>> products;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('좋아요 목록', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: ListView.builder(
        itemCount: favoriteProducts.length,
        itemBuilder: (context, index) {
          final product = favoriteProducts[index];
          return ListTile(
            leading: Image.network(product['image'] as String,
                width: 50, height: 50, fit: BoxFit.cover),
            title: Text(product['name'] as String),
            subtitle: Text('¥${product['price'] as int}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FreeMarketItemDetailPage(
                    product: product,
                    onFavoriteToggle: onFavoriteToggle,
                    isFavorited: true,
                    favoriteProducts: favoriteProducts,
                    products: products,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
