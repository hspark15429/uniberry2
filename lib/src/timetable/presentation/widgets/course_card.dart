import 'package:flutter/material.dart';
import 'package:uniberry2/src/timetable/domain/entities/course.dart';
import 'package:url_launcher/url_launcher.dart';

class CourseCard extends StatelessWidget {
  const CourseCard({
    required this.course,
    this.alreadyAdded = false,
    super.key,
  });

  final Course course;
  final bool alreadyAdded;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            course.titles.join(', '),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            course.professors.join(', '),
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            course.codes.join(', '),
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          SizedBox(
            height: 30,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
              ),
              onPressed: () => _launchURL(course.syllabusUrl),
              child: const Text(
                '시라버스확인',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "장소: ${course.campuses.join(", ")}",
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          if (!alreadyAdded)
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context, course),
              label: const Text('강의 추가'),
            )
        ],
      ),
    );
  }
}

Future<void> _launchURL(String urlString) async {
  final url = Uri.parse(urlString);
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
}
