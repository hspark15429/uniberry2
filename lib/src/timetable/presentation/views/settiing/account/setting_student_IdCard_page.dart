import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'student_ID_card_back_page.dart';
import 'student_ID_card_front_page.dart';

class SettingStudentIdCardPage extends StatefulWidget {
  @override
  _SettingStudentIdCardPageState createState() => _SettingStudentIdCardPageState();
}

class _SettingStudentIdCardPageState extends State<SettingStudentIdCardPage> {
  bool isFront = true;
  String nfcData = '';
  String enrollmentDate = '2020'; // 예시로 2020년 입학을 설정

  void toggleCardSide() {
    setState(() {
      isFront = !isFront;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('モバイル学生証'),
        actions: <Widget>[
          IconButton(
            icon: Icon(isFront ? Icons.flip_to_back : Icons.flip_to_front),
            onPressed: toggleCardSide,
          ),
          IconButton(
            icon: const Icon(Icons.nfc),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (Widget child, Animation<double> animation) {
            const angle = math.pi;
            var tilt = animation.value * angle;

            if (animation.value < 0.5) {
              return Transform(
                transform: Matrix4.rotationY(tilt) as Matrix4,
                alignment: Alignment.center,
                child: child,
              );
            } else {
              return Transform(
                transform: (Matrix4.rotationY(tilt) * Matrix4.rotationY(angle)) as Matrix4,
                alignment: Alignment.center,
                child: child,
              );
            }
          },
          child: isFront
              ? const StudentIDCardFrontPage()
              : StudentIDCardBackPage(enrollmentDate: enrollmentDate), // enrollmentDate 전달
        ),
      ),
    );
  }
}

