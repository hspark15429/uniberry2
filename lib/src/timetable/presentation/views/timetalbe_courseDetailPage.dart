import 'package:flutter/material.dart';
import 'package:uniberry2/src/timetable/domain/entities/course.dart';
import 'package:url_launcher/url_launcher.dart';

class TimetableCourseDetailPage extends StatelessWidget {
  final Course course;

  TimetableCourseDetailPage({Key? key, required this.course}) : super(key: key);

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course.titles.join(", ")),
      ),
     body: SafeArea(
        child: Column(
          children: [
            ListTile(
              title: Text("강의 정보"),
              subtitle: Text("장소: ${course.campuses.join(", ")}"),
              trailing: ElevatedButton(
                onPressed: () {
                  _launchURL(course.syllabusUrl); // 시라버스 URL을 열기
                },
                child: Text("シラバスを見る"),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    title: Text("수업명"),
                    subtitle: Text(course.titles.join(", ")),
                  ),
                  ListTile(
                    title: Text("교수명"),
                    subtitle: Text(course.professors.join(", ")),
                  ),
                  // 다른 정보 추가
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
