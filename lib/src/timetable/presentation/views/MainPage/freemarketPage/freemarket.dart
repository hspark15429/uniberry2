import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uniberry2/src/timetable/presentation/views/MainPage/freemarketPage/freemarkget_itemDetailPage.dart';
import 'package:uniberry2/src/timetable/presentation/views/MainPage/myPage/myPage.dart';

final List<Map<String, dynamic>> products = [
  {
    'name': 'IPad4世代',
    'price': 15000,
    'description': '아이패드 4세대, 거의 새것입니다.',
    'image': 'https://5.imimg.com/data5/PZ/PK/QD/SELLER-16254184/used-apple-ipad-air-2-wifi-only-with-64gb-500x500.jpeg',
    'imageUrls': [
      'https://5.imimg.com/data5/PZ/PK/QD/SELLER-16254184/used-apple-ipad-air-2-wifi-only-with-64gb-500x500.jpeg',
      'https://image.shutterstock.com/image-photo/apple-ipad-4th-generation-on-260nw-1695646073.jpg',
    ],
    'seller': {'nickname': 'JohnDoe', 'campus': 'OIC'},
    'viewCount': 123,
    'createdAt': DateTime.now().subtract(const Duration(minutes: 5)),
    'tags': ['電子機器', 'アップル'],
  },
  {
    'name': 'ソニーカメラ',
    'price': 28000,
    'description': '소니 카메라, 고화질 사진 촬영 가능합니다.',
    'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR8aELcMxsvgqpQFLUmHh0caNuRBLBHFRieog&usqp=CAU',
    'imageUrls': [
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR8aELcMxsvgqpQFLUmHh0caNuRBLBHFRieog&usqp=CAU',
      'https://example.com/sonycamera2.jpg',
    ],
    'seller': {'nickname': 'JaneSmith', 'campus': 'KIC'},
    'viewCount': 89,
    'createdAt': DateTime.now().subtract(const Duration(hours: 1)),
    'tags': ['電子機器'],
  },
  {
    'name': 'POLO',
    'price': 3500,
    'description': 'POLO 티셔츠, 거의 새것입니다.',
    'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSQ4FauYwivfNVQGFAjmMzrr5VzYRQrIjB2mA&usqp=CAU',
    'imageUrls': [
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSQ4FauYwivfNVQGFAjmMzrr5VzYRQrIjB2mA&usqp=CAU',
      'https://example.com/polo2.jpg',
    ],
    'seller': {'nickname': 'TaroYamada', 'campus': 'BKC'},
    'viewCount': 47,
    'createdAt': DateTime.now().subtract(const Duration(days: 1)),
    'tags': ['古着'],
  },
  {
    'name': 'IMac i7 16G',
    'price': 167500,
    'description': 'IMac i7 16G, 매우 좋은 상태입니다.',
    'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRWnRWomUw6niJ7W9ZHC9YSmJ_Qx9i3fI8iHw&usqp=CAU',
    'imageUrls': [
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRWnRWomUw6niJ7W9ZHC9YSmJ_Qx9i3fI8iHw&usqp=CAU',
      'https://example.com/imac2.jpg',
    ],
    'seller': {'nickname': 'MikeJohnson', 'campus': 'OIC'},
    'viewCount': 105,
    'createdAt': DateTime.now().subtract(const Duration(minutes: 30)),
    'tags': ['電子機器', 'アップル'],
  },
  {
    'name': 'デスク',
    'price': 2400,
    'description': '좋은 품질의 상품 5',
    'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSeyT_tG8Fc_DOdXqR5FzXpd2Z1_YL-Jxk9oQ&usqp=CAU',
    'imageUrls': [
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSeyT_tG8Fc_DOdXqR5FzXpd2Z1_YL-Jxk9oQ&usqp=CAU',
      'https://example.com/item5-2.jpg',
    ],
    'seller': {'nickname': 'SakuraTanaka', 'campus': 'KIC'},
    'viewCount': 67,
    'createdAt': DateTime.now().subtract(const Duration(minutes: 15)),
    'tags': ['デスク'],
  },
  {
    'name': 'IPhone SE2',
    'price': 8200,
    'description': 'Phone SE2',
    'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSJfBzwTz_00Qg1hIiaYlJRPQ_zFNB0Npx6nQ&usqp=CAU',
    'imageUrls': [
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSJfBzwTz_00Qg1hIiaYlJRPQ_zFNB0Npx6nQ&usqp=CAU',
      'https://example.com/item6-2.jpg',
    ],
    'seller': {'nickname': 'KenjiMori', 'campus': 'BKC'},
    'viewCount': 89,
    'createdAt': DateTime.now().subtract(const Duration(hours: 2)),
    'tags': ['アップル', '電子機器'],
  },
];

final List<String> tags = ['ALL', '電子機器', 'デスク', '古着', 'アップル'];

class FreeMarketPage extends StatefulWidget {
  const FreeMarketPage({super.key});

  @override
  _FreeMarketPageState createState() => _FreeMarketPageState();
}

class _FreeMarketPageState extends State<FreeMarketPage> {
  String _selectedTag = 'ALL';
  List<Map<String, dynamic>> favoriteProducts = [];

  void _toggleFavorite(Map<String, dynamic> product) {
    setState(() {
      if (favoriteProducts.any((item) => item['name'] == product['name'])) {
        print('Removing favorite: ${product['name']}');
        favoriteProducts.removeWhere((item) => item['name'] == product['name']);
      } else {
        print('Adding favorite: ${product['name']}');
        favoriteProducts.add(product);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = _selectedTag == 'ALL'
        ? products
        : products.where((product) => (product['tags'] as List<String>).contains(_selectedTag)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Freemarket', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              // 알림 페이지 로직
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
builder: (context) => MyPage(favoriteProducts: favoriteProducts),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: '商品名またはタグで検索...',
                  prefixIcon: Icon(Icons.search, color: Colors.black),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
                onChanged: (query) {
                  // 검색어 변경에 따른 로직
                },
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: tags.map((tag) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(tag),
                    selected: _selectedTag == tag,
                    onSelected: (bool selected) {
                      setState(() {
                        _selectedTag = tag;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: filteredProducts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 3 / 4,
              ),
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FreeMarketItemDetailPage(
                          product: product,
                          onFavoriteToggle: _toggleFavorite,
                          isFavorited: favoriteProducts.any((item) => item['name'] == product['name']),
                          favoriteProducts: favoriteProducts,
                          products: products, // 추가
                        ),
                      ),
                    );
                  },
                  child: Container(
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
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              product['image'] as String,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product['name'] as String,
                                style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '¥${product['price'] as int}',
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
