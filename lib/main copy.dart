import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _currentMap = ''; // 現在のマップ名
  DateTime _currentMapStartTime = DateTime.now(); // 現在のマップの開始時刻
  DateTime _currentMapEndTime = DateTime.now(); // 現在のマップの終了時刻
  String _nextMap = ''; // 次のマップ名
  DateTime _nextMapStartTime = DateTime.now(); // 次のマップの開始時刻
  DateTime _nextMapEndTime = DateTime.now(); // 次のマップの終了時刻
  String _rankMap = ''; // ランクマップ名
  DateTime _rankMapStartTime = DateTime.now(); // ランクマップの開始時刻
  DateTime _rankMapEndTime = DateTime.now(); // ランクマップの終了時刻

  Future<void> _fetchMapRotation() async {
    const apiKey = '290178fca42c162c8d4308dc6649a758';
    const url =
        'https://api.mozambiquehe.re/maprotation?version=2&auth=$apiKey';
    final http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // 現在のマップの情報を取得
      _currentMap = data['battle_royale']['current']['map'];
      _currentMapStartTime =
          _parseDate(data['battle_royale']['current']['readableDate_start'])
              .add(const Duration(hours: 9));
      _currentMapEndTime =
          _parseDate(data['battle_royale']['current']['readableDate_end'])
              .add(const Duration(hours: 9));

      // 次のマップの情報を取得
      _nextMap = data['battle_royale']['next']['map'];
      _nextMapStartTime =
          _parseDate(data['battle_royale']['next']['readableDate_start'])
              .add(const Duration(hours: 9));
      _nextMapEndTime =
          _parseDate(data['battle_royale']['next']['readableDate_end'])
              .add(const Duration(hours: 9));

      // ランクマップの情報を取得
      _rankMap = data['ranked']['current']['map'];
      _rankMapStartTime =
          _parseDate(data['ranked']['current']['readableDate_start'])
              .add(const Duration(hours: 9));
      _rankMapEndTime =
          _parseDate(data['ranked']['current']['readableDate_end'])
              .add(const Duration(hours: 9));

      setState(() {});
    } else {
      throw Exception('Failed to fetch map rotation');
    }
  }

  DateTime _parseDate(String dateString) {
    // APIから返された日付文字列をDateTimeオブジェクトに変換するメソッド
    return DateTime.parse(dateString);
  }

  @override
  void initState() {
    super.initState();
    _fetchMapRotation();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Map Rotation',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('APEX マップローテーション'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _fetchMapRotation();
          },
          tooltip: 'Refresh',
          child: const Icon(Icons.refresh),
        ),
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/background.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.7)),
            ),
            SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      '現在のマップ',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 3,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            _currentMap,
                            style: const TextStyle(
                                fontSize: 32, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildDateInfo(_currentMapStartTime, '開始'),
                              _buildDateInfo(_currentMapEndTime, '終了'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      '次回のマップ',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 3,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            _nextMap,
                            style: const TextStyle(
                                fontSize: 32, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildDateInfo(_nextMapStartTime, '開始'),
                              _buildDateInfo(_nextMapEndTime, '終了'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'ランクマッチ',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 3,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            _rankMap,
                            style: const TextStyle(
                                fontSize: 32, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildDateInfo(_rankMapStartTime, '開始'),
                              _buildDateInfo(_rankMapEndTime, '終了'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateInfo(DateTime date, String label) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          DateFormat('H:mm').format(date),
          style: const TextStyle(fontSize: 24),
        ),
        const SizedBox(height: 8),
        Text(
          DateFormat('M/d').format(date),
          style: const TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ],
    );
  }
}
