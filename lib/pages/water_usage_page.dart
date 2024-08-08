import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart'; // 날짜 형식 사용
import '../score_manager.dart';
import 'common_layout.dart';

class WaterUsagePage extends StatefulWidget {
  const WaterUsagePage({Key? key}) : super(key: key);

  @override
  _WaterUsagePageState createState() => _WaterUsagePageState();
}

class _WaterUsagePageState extends State<WaterUsagePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _membersController = TextEditingController();
  final TextEditingController _showerController = TextEditingController();
  final TextEditingController _dishesController = TextEditingController();
  final TextEditingController _cupUsageController = TextEditingController();
  int _members = 1; // 기본값
  double _dailyWaterLimit = 198; // 하루 기준 물 사용량(L)
  String? _lastRecordedDate; // 마지막 기록된 날짜

  @override
  void initState() {
    super.initState();
    _loadMembers();
    _loadLastRecordedDate(); // 마지막 기록된 날짜 로드
  }

  Future<void> _loadMembers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _members = prefs.getInt('members') ?? 1;
      _membersController.text = _members.toString();
    });
  }

  Future<void> _loadLastRecordedDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _lastRecordedDate = prefs.getString('lastRecordedDate');
    });
  }

  Future<void> _saveMembers() async {
    if (_formKey.currentState!.validate()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('members', int.parse(_membersController.text));
      setState(() {
        _members = int.parse(_membersController.text);
      });
    }
  }

  Future<void> _saveWaterUsage() async {
    if (_formKey.currentState!.validate()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

      if (_lastRecordedDate == today) {
        _showDialogWithMessage('오늘은 이미 물 사용량을 기록했습니다.');
        return;
      }

      int showerMinutes = int.parse(_showerController.text);
      int dishesMinutes = int.parse(_dishesController.text);
      bool usedCup = _cupUsageController.text.toLowerCase() == 'o';

      // 물 사용량 계산 로직 (예시)
      double showerUsage = showerMinutes * 12; // 샤워 1분당 12L 사용
      double dishesUsage = dishesMinutes * 10; // 설거지 1분당 10L 사용
      double totalUsage = showerUsage + dishesUsage + (usedCup ? 0 : 2); // 컵 사용 안했을 때 2L 추가

      String message;
      int points;

      if (totalUsage < _dailyWaterLimit) { // 임의의 기준 사용량
        message =
            '와우 당신은 절약왕! 총 물 사용량: ${totalUsage.toStringAsFixed(2)}L, 포인트 +30';
        points = 30;
      } else {
        message =
            '좀 더 노력하세요! 총 물 사용량: ${totalUsage.toStringAsFixed(2)}L, 포인트 +10';
        points = 10;
      }

      await prefs.setString('lastRecordedDate', today);
      Provider.of<ScoreManager>(context, listen: false).addPoints(points);
      _showDialogWithAnimation(message);
    }
  }

  void _showDialogWithAnimation(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 3), () {
          Navigator.of(context).pop(true);
        });

        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/animation_check.json',
                width: 150,
                height: 150,
                fit: BoxFit.fill,
              ),
              SizedBox(height: 20),
              Text(message, textAlign: TextAlign.center),
            ],
          ),
        );
      },
    );
  }

  void _showDialogWithMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message, textAlign: TextAlign.center),
          actions: [
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonLayout(
      selectedIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('물 사용량 기록'),
        ),
        body: SingleChildScrollView( // 추가: 스크롤 가능하게 함
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  '가정 내 인원 수 입력',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _membersController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: '가정 내 인원 수',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '가정 내 인원 수를 입력해주세요';
                    }
                    if (int.tryParse(value) == null || int.parse(value) <= 0) {
                      return '유효한 숫자를 입력해주세요';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveMembers,
                  child: const Text('저장'),
                ),
                const SizedBox(height: 20),
                const Text(
                  '오늘 샤워를 몇 분 하셨나요?',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _showerController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: '샤워 시간 (분)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '샤워 시간을 입력해주세요';
                    }
                    if (int.tryParse(value) == null || int.parse(value) <= 0) {
                      return '유효한 숫자를 입력해주세요';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveWaterUsage,
                  child: const Text('저장'),
                ),
                const Text(
                  '오늘 설거지를 몇 분 하셨나요?',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _dishesController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: '설거지 시간 (분)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '설거지 시간을 입력해주세요';
                    }
                    if (int.tryParse(value) == null || int.parse(value) <= 0) {
                      return '유효한 숫자를 입력해주세요';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveWaterUsage,
                  child: const Text('저장'),
                ),
                const Text(
                  '오늘 양치질 할 때 컵을 사용하셨나요?',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _cupUsageController,
                  decoration: const InputDecoration(
                    labelText: 'O / X',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '컵 사용 여부를 입력해주세요';
                    }
                    if (value.toLowerCase() != 'o' && value.toLowerCase() != 'x') {
                      return '유효한 문자를 입력해주세요 (O 또는 X)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveWaterUsage,
                  child: const Text('저장'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
