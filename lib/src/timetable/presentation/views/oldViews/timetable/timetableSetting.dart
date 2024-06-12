import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniberry2/src/timetable/presentation/cubit/timetable_cubit.dart';

class TimetableSettingPage extends StatefulWidget {
  const TimetableSettingPage({super.key});

  static const String routeName = '/timetable_setting';

  @override
  State<TimetableSettingPage> createState() => _TimetableSettingPageState();
}

class _TimetableSettingPageState extends State<TimetableSettingPage> {
  int _periods = 5;
  bool _includeSaturday = false;
  bool _includeSunday = false;

  void _saveSettings() {
    context.read<TimetableCubit>().setPeriods(_periods);
    context.read<TimetableCubit>().setIncludeSaturday(_includeSaturday);
    context.read<TimetableCubit>().setIncludeSunday(_includeSunday);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timetable Settings',
            style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Number of Periods',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
            Slider(
              value: _periods.toDouble(),
              min: 5,
              max: 12,
              divisions: 7,
              label: '$_periods periods',
              onChanged: (value) {
                setState(() {
                  _periods = value.toInt();
                });
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Include Saturday', style: TextStyle(fontSize: 16)),
                Switch(
                  value: _includeSaturday,
                  onChanged: (value) {
                    setState(() {
                      _includeSaturday = value;
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Include Sunday', style: TextStyle(fontSize: 16)),
                Switch(
                  value: _includeSunday,
                  onChanged: (value) {
                    setState(() {
                      _includeSunday = value;
                    });
                  },
                ),
              ],
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: _saveSettings,
                child: const Text('Save Settings'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
