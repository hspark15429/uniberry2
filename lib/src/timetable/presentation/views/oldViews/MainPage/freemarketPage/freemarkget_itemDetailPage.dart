import 'package:flutter/material.dart';

class FreeMarketItemDetailPage extends StatelessWidget {

  const FreeMarketItemDetailPage({
    required this.product, required this.onFavoriteToggle, required this.isFavorited, required this.favoriteProducts, required this.products, super.key,
  });
  final Map<String, dynamic> product;
  final Function(Map<String, dynamic>) onFavoriteToggle;
  final bool isFavorited;
  final List<Map<String, dynamic>> favoriteProducts;
  final List<Map<String, dynamic>> products;

  @override
  Widget build(BuildContext context) {
    final productTags = product['tags'] as List<dynamic>? ?? [];

    final similarItems = products
        .where((item) {
          final itemTags = item['tags'] as List<dynamic>? ?? [];
          return itemTags.any(productTags.contains) && item['name'] != product['name'];
        })
        .toList();

    final createdAt = product['createdAt'] as DateTime;
    final formattedDate = '${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}';

    return Scaffold(
      appBar: AppBar(
        title: Text(product['name'] as String, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.report),
            onPressed: () {
              // 신고하기 로직
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 300,
              child: PageView.builder(
                itemCount: (product['imageUrls'] as List<dynamic>).length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // 전체보기 로직
                    },
                    child: Image.network((product['imageUrls'] as List<dynamic>)[index] as String, fit: BoxFit.cover),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'] as String,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '¥${product['price'] as int}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.person, size: 20),
                      const SizedBox(width: 4),
                      Text(product['seller']['nickname'] as String),
                      const SizedBox(width: 8),
                      Text('(${product['seller']['campus'] as String})'),
                    ],
                  ),
                  const Divider(),
                  Text(
                    product['description'] as String,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '작성일: $formattedDate',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  Text(
                    '조회수: ${product['viewCount'] as int}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: Icon(
                            isFavorited ? Icons.favorite : Icons.favorite_border,
                            color: Colors.red,
                          ),
                          label: const Text('찜하기'),
                          onPressed: () {
                            onFavoriteToggle(product);
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: const Icon(Icons.message),
                          label: const Text('문의하기'),
                          onPressed: () {
                            // 문의하기 로직
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text('유사한 상품', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: similarItems.length,
                itemBuilder: (context, index) {
                  final item = similarItems[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FreeMarketItemDetailPage(
                              product: item,
                              onFavoriteToggle: onFavoriteToggle,
                              isFavorited: favoriteProducts.any((favoriteItem) => favoriteItem['name'] == item['name']),
                              favoriteProducts: favoriteProducts,
                              products: products,
                            ),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network((item['imageUrls'] as List<dynamic>)[0] as String, width: 150, height: 150, fit: BoxFit.cover),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item['name'] as String,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '¥${item['price'] as int}',
                            style: const TextStyle(color: Colors.red),
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
      ),
    );
  }
}
