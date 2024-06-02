import 'package:flutter/material.dart';
import 'package:uniberry2/src/timetable/presentation/views/MainPage/freemarketPage/freemarkget_itemDetailPage.dart';


class FavoriteProductsPage extends StatelessWidget {
  final List<Map<String, dynamic>> favoriteProducts;
  final Function(Map<String, dynamic>) onFavoriteToggle;
  final List<Map<String, dynamic>> products; // Adding this parameter

  const FavoriteProductsPage({
    super.key,
    required this.favoriteProducts,
    required this.onFavoriteToggle,
    required this.products, // Adding this parameter
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
            leading: Image.network(product['image'] as String, width: 50, height: 50, fit: BoxFit.cover),
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
                    products: products, // Adding this argument
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
