import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SelectTermSheet extends StatefulWidget {
  const SelectTermSheet({required this.params, super.key});

  final SelectTermSheetParams params;

  @override
  State<SelectTermSheet> createState() => _SelectTermSheetState();
}

class _SelectTermSheetState extends State<SelectTermSheet> {
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          ListTile(
            title: const Text('All Year'),
            tileColor: _params.term == '' ? Colors.blue[300] : null,
            onTap: () {
              if (_params.term != '') {
                setState(() {
                  _params.term = '';
                });
              }
            },
          ),
          ListTile(
            title: const Text('Spring'),
            tileColor: _params.term == '春セメスター' ? Colors.blue[300] : null,
            onTap: () {
              if (_params.term != '春セメスター') {
                setState(() {
                  _params.term = '春セメスター';
                });
              }
            },
          ),
          ListTile(
            title: const Text('Fall'),
            tileColor: _params.term == '秋セメスター' ? Colors.blue[300] : null,
            onTap: () {
              if (_params.term != '秋セメスター') {
                setState(() {
                  _params.term = '秋セメスター';
                });
              }
            },
          ),
          const Text(
            'Select Number of Periods',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Slider(
            value: _params.numOfPeriods.toDouble(),
            min: 5,
            max: 12,
            divisions: 7,
            label: '${_params.numOfPeriods} periods',
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
              const Text('Include Weekends', style: TextStyle(fontSize: 16)),
              Switch(
                value: _params.numOfDays == 7,
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
              onPressed: () {
                Navigator.pop(context, _params);
              },
              child: const Text('Save Settings'),
            ),
          ),
        ],
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
