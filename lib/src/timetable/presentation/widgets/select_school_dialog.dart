import 'package:flutter/material.dart';
import 'package:uniberry2/core/utils/constants.dart';

class SelectSchoolSheet extends StatelessWidget {
  const SelectSchoolSheet({required this.currentSchool, super.key});

  final String currentSchool;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: kSchools.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(kSchools[index]),
            tileColor:
                kSchools[index] == currentSchool ? Colors.blue[300] : null,
            onTap: () {
              Navigator.pop(context, kSchools[index]);
            },
          );
        },
      ),
    );
  }
}
