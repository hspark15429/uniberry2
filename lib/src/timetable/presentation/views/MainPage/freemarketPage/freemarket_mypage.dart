import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uniberry2/src/timetable/presentation/views/MainPage/freemarketPage/freemarket_FavoriteProductsPage.dart';

import 'freemarket_usersetting.dart';
import 'freemarkget_productDetailPage.dart';

class FreeMarketMyPage extends StatefulWidget {
  final List<Map<String, dynamic>> favoriteProducts;

  const FreeMarketMyPage({super.key, required this.favoriteProducts});

  @override
  _FreeMarketMyPageState createState() => _FreeMarketMyPageState();
}

class _FreeMarketMyPageState extends State<FreeMarketMyPage> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  List<Map<String, dynamic>> favoriteProducts = [];

  @override
  void initState() {
    super.initState();
    favoriteProducts = widget.favoriteProducts;
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('색상 선택'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: Colors.purple[100]!,
              onColorChanged: (Color color) {
                setState(() {
                  _image = null;
                });
                Navigator.of(context).pop();
              },
            ),
          ),
        );
      },
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
                builder: (context) => UserSettingPage(),
              ),
            );
          },
        ),
      ],
    ),
    body: SingleChildScrollView(
      child: Container(
        // Remove the DecorationImage part
        decoration: const BoxDecoration(
          // You can add a color if needed
          // color: Colors.white, // Uncomment and set color if you want
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
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
                    const SizedBox(width: 20),
                    const Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Jay',
                          border: UnderlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(16.0),
                padding: const EdgeInsets.all(16.0),
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
                            'assets/start_img.png',
                            width: 40,
                            height: 40,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Text(
                          'Unipay',
                          style: GoogleFonts.roboto(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Text(
                            '残高: ￥100,000',
                            style: GoogleFonts.roboto(
                              fontSize: 20,
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildBoxButton(
                      context,
                      Icons.favorite,
                      'いいね一覧',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FavoriteProductsPage(
                              favoriteProducts: favoriteProducts,
                              onFavoriteToggle: _toggleFavorite,
                            ),
                          ),
                        );
                      },
                    ),
                    _buildBoxButton(context, Icons.bookmark, '保存一覧', onPressed: () {}),
                    _buildBoxButton(context, Icons.shopping_cart, '購入リスト', onPressed: () {}),
                    _buildBoxButton(context, Icons.outbox, '販売リスト', onPressed: () {}),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('좋아요 목록', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: favoriteProducts.length,
                itemBuilder: (context, index) {
                  final product = favoriteProducts[index];
                  return ListTile(
                    leading: Image.network(product['image'], width: 50, height: 50, fit: BoxFit.cover),
                    title: Text(product['name']),
                    subtitle: Text('¥${product['price']}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FreeMarketItemDetailPage(
                            product: product,
                            onFavoriteToggle: _toggleFavorite,
                            isFavorited: true,
                            favoriteProducts: favoriteProducts,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              ListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  _buildListTile(context, Icons.mic, 'お知らせ'),
                  _buildListTile(context, Icons.event, 'イベント一覧'),
                  _buildListTile(context, Icons.location_city, '私の町登録'),
                  _buildListTile(context, Icons.group, '町の情報'),
                  _buildListTile(context, Icons.policy, '個人情報処理方針'),
                  _buildListTile(context, Icons.question_answer, 'FAQ'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBoxButton(BuildContext context, IconData icon, String label, {required VoidCallback onPressed}) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(icon, color: Colors.black),
            onPressed: onPressed,
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.black)),
      ],
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
