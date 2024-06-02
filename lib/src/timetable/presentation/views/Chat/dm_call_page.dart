import 'package:flutter/material.dart';

class DMCallPage extends StatefulWidget {
  @override
  _DMCallPageState createState() => _DMCallPageState();
}

class _DMCallPageState extends State<DMCallPage> {
  String _callStatus = "통화 대기 중...";

  void _startCall() {
    setState(() {
      _callStatus = "통화 시작됨";
      // 여기에 통화 시작 로직을 구현하세요.
    });
  }

  void _endCall() {
    setState(() {
      _callStatus = "통화 종료됨";
      // 여기에 통화 종료 로직을 구현하세요.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('전화'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(_callStatus),
            ElevatedButton(
              onPressed: _startCall,
              child: Text('통화 시작'),
            ),
            ElevatedButton(
              onPressed: _endCall,
              child: Text('통화 종료'),
            ),
          ],
        ),
      ),
    );
  }
}
