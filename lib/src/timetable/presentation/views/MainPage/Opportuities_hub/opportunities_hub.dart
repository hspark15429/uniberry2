import 'package:flutter/material.dart';
import 'package:uniberry2/src/timetable/presentation/views/MainPage/Opportuities_hub/Op_database.dart';
import 'package:uniberry2/src/timetable/presentation/views/MainPage/Opportuities_hub/OpportunityDetailPage.dart';

// Opportunities Hub 페이지 정의
class OpportunitiesHubPage extends StatefulWidget {
  const OpportunitiesHubPage({super.key});

  @override
  _OpportunitiesHubPageState createState() => _OpportunitiesHubPageState();
}

class _OpportunitiesHubPageState extends State<OpportunitiesHubPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Opportunities Hub', style: TextStyle(color: Colors.white)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: dummyOpportunities.length,
        itemBuilder: (context, index) {
          final opportunity = dummyOpportunities[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                ),
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16.0),
              leading: opportunity.imageUrls.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        opportunity.imageUrls.first,
                        width: 50.0,
                        height: 50.0,
                        fit: BoxFit.cover,
                        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                          return const Icon(Icons.error); // 이미지 로드 실패 시 에러 아이콘 표시
                        },
                      ),
                    )
                  : const SizedBox(
                      width: 50.0,
                      height: 50.0,
                      child: Icon(Icons.image, color: Colors.grey), // 이미지가 없을 경우 아이콘 표시
                    ),
              title: Text(
                opportunity.title,
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                opportunity.description,
                style: const TextStyle(color: Colors.grey),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                opportunity.incrementViewCount();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OpportunityDetailPage(opportunity: opportunity),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
