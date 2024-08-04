import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class TimetableSettingsSheet extends StatefulWidget {
  const TimetableSettingsSheet({required this.params, super.key});

  final SelectTermSheetParams params;

  @override
  State<TimetableSettingsSheet> createState() => _TimetableSettingsSheetState();
}

class _TimetableSettingsSheetState extends State<TimetableSettingsSheet> {
  late SelectTermSheetParams _params;

  @override
  void initState() {
    super.initState();
    _params = SelectTermSheetParams(
      term: widget.params.term,
      numOfPeriods: widget.params.numOfPeriods,
      numOfDays: widget.params.numOfDays,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('セメスター選択'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: _buildTermTile('全セメスター', '')),
              const SizedBox(width: 8),
              Expanded(child: _buildTermTile('春セメスター', '春セメスター')),
              const SizedBox(width: 8),
              Expanded(child: _buildTermTile('秋セメスター', '秋セメスター')),
            ],
          ),
          const SizedBox(height: 20),
          _buildSectionTitle('コマ数設定'),
          Slider(
            value: _params.numOfPeriods.toDouble(),
            min: 5,
            max: 12,
            divisions: 7,
            label: '${_params.numOfPeriods} コマ',
            onChanged: (value) {
              setState(() {
                _params.numOfPeriods = value.toInt();
              });
            },
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '土日を含む',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Switch(
                value: _params.numOfDays == 7,
                focusColor: Colors.black,
                activeColor: Colors.black,
                inactiveTrackColor: Colors.grey[400],
                onChanged: (value) {
                  setState(() {
                    _params.numOfDays = value ? 7 : 5;
                  });
                },
              ),
            ],
          ),
          const Spacer(),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: () {
                Navigator.pop(context, _params);
              },
              child: const Text(
                '保存',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildTermTile(String title, String termValue) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _params.term = termValue;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: _params.term == termValue ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: _params.term == termValue ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class SelectTermSheetParams extends Equatable {
  SelectTermSheetParams({
    required this.term,
    required this.numOfPeriods,
    required this.numOfDays,
  });

  String term;
  int numOfPeriods;
  int numOfDays;

  @override
  List<Object> get props => [term, numOfPeriods, numOfDays];
}
