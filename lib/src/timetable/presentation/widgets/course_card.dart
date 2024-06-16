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
          _buildTitle(course.titles.join(', ')),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.person, course.professors.join(', ')),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.code, course.codes.join(', ')),
          const SizedBox(height: 8),
          _buildInfoRow(
              Icons.language, 'Languages: ${course.languages.join(', ')}'),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.savings, 'Credit: ${course.credit}'),
          const SizedBox(height: 8),
          _buildInfoRow(
              Icons.schedule, 'Periods: ${course.periods.join(', ')}'),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.location_on, "장소: ${course.campuses.join(", ")}"),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onPressed: () => _launchURL(course.syllabusUrl),
            child: const Text(
              '시라버스확인',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          const SizedBox(height: 16),
          if (!alreadyAdded)
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context, course),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                '강의 추가',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ),
      ],
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
