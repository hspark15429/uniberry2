import 'package:flutter/material.dart';
import 'package:uniberry2/src/timetable/presentation/views/MainPage/freemarketPage/freemarkget_productDetailPage.dart';

class FavoriteProductsPage extends StatelessWidget {
  final List<Map<String, dynamic>> favoriteProducts;
  final Function(Map<String, dynamic>) onFavoriteToggle;

  const FavoriteProductsPage({
    super.key,
    required this.favoriteProducts,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('いいね一覧', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: ListView.builder(
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
                    onFavoriteToggle: onFavoriteToggle,
                    isFavorited: true, favoriteProducts: [],
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
