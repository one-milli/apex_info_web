import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Web App',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _currentMap = '';

  @override
  void initState() {
    super.initState();
    _getCurrentMap();
    _scheduleUpdates(); // 毎時0分と30分に更新処理をスケジュールする
  }

  Future<void> _getCurrentMap() async {
    final apiKey = '290178fca42c162c8d4308dc6649a758'; // APIキーを設定
    final apiUrl = 'https://api.mozambiquehe.re/maprotation'; // APIのエンドポイントを設定
    final response =
        await http.get(Uri.parse('$apiUrl?version=2&auth=$apiKey'));
    final data = jsonDecode(response.body);
    setState(() {
      _currentMap = data['battle']['current']['map'];
    });
  }

  void _scheduleUpdates() {
    final now = DateTime.now();
    final delay = Duration(
      minutes: 30 - (now.minute % 30), // 次の30分までの残り時間
      seconds: 60 - now.second, // 次の分の開始までの残り時間
    );
    final nextUpdate = now.add(delay);
    final updateInterval = Duration(minutes: 30); // 30分ごとに更新する
    Timer(nextUpdate.difference(now), () {
      _getCurrentMap(); // 最初の更新
      Timer.periodic(updateInterval, (timer) => _getCurrentMap());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Web App'),
      ),
      body: Center(
        child: Text(
          'Current Map: $_currentMap',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
