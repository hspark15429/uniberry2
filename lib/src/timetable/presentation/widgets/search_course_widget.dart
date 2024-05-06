import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uniberry2/core/services/injection_container.dart';
import 'package:uniberry2/core/utils/typedefs.dart';

class SearchCourseWidget extends StatefulWidget {
  const SearchCourseWidget({super.key});

  @override
  _SearchCourseWidgetState createState() => _SearchCourseWidgetState();
}

class _SearchCourseWidgetState extends State<SearchCourseWidget> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Courses'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Search by course name',
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: (searchQuery == "")
                  ? sl<FirebaseFirestore>().collection('courses').snapshots()
                  : sl<FirebaseFirestore>()
                      .collection('courses')
                      .where('term', isGreaterThanOrEqualTo: searchQuery)
                      .where('term', isLessThanOrEqualTo: '$searchQuery\uf8ff')
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Center(child: CircularProgressIndicator());
                  default:
                    return ListView(
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        DataMap data = document.data()! as DataMap;
                        return ListTile(
                          // title: Text(data['course']['titles'].toString()),
                          subtitle: Text(data['professors'].toString()),
                        );
                      }).toList(),
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
