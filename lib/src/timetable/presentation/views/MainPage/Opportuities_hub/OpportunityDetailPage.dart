import 'package:flutter/material.dart';
import 'package:uniberry2/src/timetable/presentation/views/MainPage/Opportuities_hub/Op_database.dart'; // 가정: 기회 모델 정의 파일

class OpportunityDetailPage extends StatelessWidget {
  final Opportunity opportunity;

  const OpportunityDetailPage({super.key, required this.opportunity});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      opportunity.incrementViewCount();
    });

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          opportunity.title,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "#${opportunity.category}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      color: Colors.black,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.visibility, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text("${opportunity.viewCount}", style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                opportunity.title,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 16),
              if (opportunity.imageUrls.isNotEmpty)
                SizedBox(
                  height: 200,
                  child: PageView.builder(
                    itemCount: opportunity.imageUrls.length,
                    itemBuilder: (context, index) => ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        opportunity.imageUrls[index],
                        fit: BoxFit.cover,
                        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                          return const Icon(Icons.error);
                        },
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              Text(
                opportunity.description,
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              const SizedBox(height: 16),
              Text(
                opportunity.additionalInfo ?? "추가 정보 없음",
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
