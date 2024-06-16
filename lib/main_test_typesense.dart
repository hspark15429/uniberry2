import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:http/http.dart' as http;
import 'package:uniberry2/core/utils/typedefs.dart';

void main() {
  runApp(const MyApp());
}

// class SearchMetadata {
//   final int nbHits;

//   const SearchMetadata(this.nbHits);

//   factory SearchMetadata.fromResponse(Map<String, dynamic> response) =>
//       SearchMetadata(response['found'] as int);
// }

// class Product {
//   final String title;
//   final String content;
//   final String author;

//   Product(this.title, this.content, this.author);

//   static Product fromJson(Map<String, dynamic> json) {
//     return Product(
//       json['title'] as String,
//       json['content'] as String,
//       json['author'] as String,
//     );
//   }
// }

class Course {
  final String courseId;
  final String term;
  final String syllabusUrl;

  Course(this.courseId, this.term, this.syllabusUrl);

  static Course fromJson(Map<String, dynamic> json) {
    return Course(
      json['courseId'] as String,
      json['term'] as String,
      json['syllabusUrl'] as String,
    );
  }
}

class HitsPage {
  const HitsPage(this.items, this.pageKey, this.nextPageKey);

  final List<Course> items;
  final int pageKey;
  final int? nextPageKey;

  factory HitsPage.fromResponse(DataMap response, int pageKey) {
    final items = (response['hits'] as List)
        .map((hit) => Course.fromJson(hit['document'] as DataMap))
        .toList();
    int nbPages = ((response['found'] as int) / 10).ceil();
    final isLastPage = response['page'] as int >= nbPages;
    final nextPageKey = isLastPage ? null : pageKey + 1;
    return HitsPage(items, pageKey, nextPageKey);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _searchTextController = TextEditingController();
  final String typesenseApiKey = dotenv.env['TYPESENSE_API_KEY']!;
  final String typesenseHost = dotenv.env['TYPESENSE_HOST']!;
  final String typesensePort = dotenv.env['TYPESENSE_PORT']!;
  final String typesenseProtocol = 'https';

  final PagingController<int, Course> _pagingController =
      PagingController(firstPageKey: 0);

  final GlobalKey<ScaffoldState> _mainScaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _searchTextController.addListener(() => _searchProducts(pageKey: 1));

    _pagingController.addPageRequestListener((pageKey) {
      _searchProducts(pageKey: pageKey);
    });
  }

  Future<void> _searchProducts({required int pageKey}) async {
    final query = _searchTextController.text.isNotEmpty
        ? _searchTextController.text
        : '*';

    final response = await http.get(
      Uri.parse(
          '$typesenseProtocol://$typesenseHost:$typesensePort/collections/courses/documents/search?q=$query&query_by=titles&page=$pageKey&per_page=10'),
      headers: {
        'X-TYPESENSE-API-KEY': typesenseApiKey,
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body) as DataMap;
      final page = HitsPage.fromResponse(jsonResponse, pageKey);
      if (page.pageKey == 1) {
        _pagingController.refresh();
      }
      _pagingController.appendPage(page.items, page.nextPageKey);
    } else {
      _pagingController.error = 'Failed to fetch products';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _mainScaffoldKey,
      appBar: AppBar(
        title: const Text('Typesense & Flutter'),
        // actions: [
        //   IconButton(
        //       onPressed: () => _mainScaffoldKey.currentState?.openEndDrawer(),
        //       icon: const Icon(Icons.filter_list_sharp))
        // ],
      ),
      // endDrawer: Drawer(
      //   child: _filters(context),
      // ),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
                height: 44,
                child: TextField(
                  controller: _searchTextController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter a search term',
                    prefixIcon: Icon(Icons.search),
                  ),
                )),
            // StreamBuilder<int>(
            //   stream:
            //       Stream<int>.value(_pagingController.itemList?.length ?? 0),
            //   builder: (context, snapshot) {
            //     if (!snapshot.hasData) {
            //       return const SizedBox.shrink();
            //     }
            //     return Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: Text('${snapshot.data} hits'),
            //     );
            //   },
            // ),
            Expanded(
              child: _hits(context),
            )
          ],
        ),
      ),
    );
  }

  Widget _hits(BuildContext context) => PagedListView<int, Course>(
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<Course>(
          noItemsFoundIndicatorBuilder: (_) => const Center(
                child: Text('No results found'),
              ),
          itemBuilder: (_, item, __) => Container(
                color: Colors.white,
                height: 80,
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    SizedBox(width: 50, child: Text(item.courseId)),
                    const SizedBox(width: 20),
                    SizedBox(width: 30, child: Text(item.syllabusUrl)),
                    const SizedBox(width: 20),
                    Expanded(child: Text(item.term))
                  ],
                ),
              )));

  // Widget _filters(BuildContext context) => Scaffold(
  //       appBar: AppBar(
  //         title: const Text('Filters'),
  //       ),
  //       body: Center(
  //         child: const Text(
  //             'Filters go here'), // Placeholder for filter implementation
  //       ),
  //     );

  @override
  void dispose() {
    _searchTextController.dispose();
    _pagingController.dispose();
    super.dispose();
  }
}
