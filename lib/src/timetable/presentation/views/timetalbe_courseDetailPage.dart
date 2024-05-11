import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniberry2/src/timetable/domain/entities/course.dart';
import 'package:uniberry2/src/timetable/presentation/cubit/timetable_cubit.dart';
import 'package:uniberry2/src/timetable/presentation/views/timetable_screen.dart'; // 시간표 페이지 import
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
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              context.read<TimetableCubit>().addCourseToTimetable(course);
              // 시간표 페이지로 이동
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => TimetableScreen()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
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
                  // 추가 정보 표시
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
