import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // 추가
import 'package:lottie/lottie.dart'; // 추가
import 'package:provider/provider.dart';
import '../score_manager.dart';
import 'common_layout.dart';

class MissionPage extends StatefulWidget {
  @override
  _MissionPageState createState() => _MissionPageState();
}

class _MissionPageState extends State<MissionPage> {
  final List<Map<String, String>> dailyMissions = [
    {'title': '짧은 샤워하기', 'description': '샤워 시간을 5분 이하로 줄이세요.'},
    {'title': '양치질 시 물컵 사용하기', 'description': '양치질을 할 때 컵에 물을 받아서 사용하세요.'},
    {'title': '빨래 모아서 한 번에 하기', 'description': '세탁할 때 세탁물을 모아서 한 번에 세탁하세요.'},
    {
      'title': '설거지 물 받아서 사용하기',
      'description': '설거지를 할 때 물을 틀어 놓지 말고, 물을 받아서 사용하세요.'
    },
    {'title': '수도꼭지 점검하기', 'description': '누수 여부를 점검하고, 누수가 있다면 즉시 수리하세요.'},
    {'title': '샤워 필터 사용하기', 'description': '물 절약형 샤워 필터를 사용하여 물 사용량을 줄이세요.'},
  ];

  final List<Map<String, String>> monthlyMissions = [
    {'title': '변기에 물병 넣기', 'description': '변기 물탱크에 물병을 넣어 물 사용량을 줄이세요.'},
  ];

  Map<String, bool> missionStatus = {
    '짧은 샤워하기': false,
    '양치질 시 물컵 사용하기': false,
    '빨래 모아서 한 번에 하기': false,
    '설거지 물 받아서 사용하기': false,
    '수도꼭지 점검하기': false,
    '샤워 필터 사용하기': false,
    '변기에 물병 넣기': false,
  };

  bool showConfetti = false;
  int confettiPoints = 20;

  @override
  void initState() {
    super.initState();
    _loadMissionStatus();
  }

  Future<void> _loadMissionStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().split('T')[0];
    final currentMonth = DateTime.now().month;
    setState(() {
      missionStatus = {
        '짧은 샤워하기': prefs.getString('짧은 샤워하기') == today,
        '양치질 시 물컵 사용하기': prefs.getString('양치질 시 물컵 사용하기') == today,
        '빨래 모아서 한 번에 하기': prefs.getString('빨래 모아서 한 번에 하기') == today,
        '설거지 물 받아서 사용하기': prefs.getString('설거지 물 받아서 사용하기') == today,
        '수도꼭지 점검하기': prefs.getString('수도꼭지 점검하기') == today,
        '샤워 필터 사용하기': prefs.getString('샤워 필터 사용하기') == today,
        '변기에 물병 넣기': prefs.getInt('변기에 물병 넣기') == currentMonth,
      };
    });
  }

  Future<void> _setMissionStatus(String mission, bool isMonthly) async {
    final prefs = await SharedPreferences.getInstance();
    if (isMonthly) {
      final currentMonth = DateTime.now().month;
      await prefs.setInt(mission, currentMonth);
    } else {
      final today = DateTime.now().toIso8601String().split('T')[0];
      await prefs.setString(mission, today);
    }
    setState(() {
      missionStatus[mission] = true;
      confettiPoints = isMonthly ? 200 : 20;
    });
    await Provider.of<ScoreManager>(context, listen: false)
        .addPoints(confettiPoints);
  }

  void _showConfetti() {
    setState(() {
      showConfetti = true;
    });
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        showConfetti = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CommonLayout(
      child: Scaffold(
        appBar: AppBar(
          title: Text('물 절약 미션'),
        ),
        body: Stack(
          children: [
            ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('일일 미션',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                ...dailyMissions.map((mission) {
                  String missionTitle = mission['title']!;
                  return CheckboxListTile(
                    title: Text(missionTitle),
                    subtitle: Text(mission['description']!),
                    value: missionStatus[missionTitle],
                    onChanged: missionStatus[missionTitle] == true
                        ? null
                        : (bool? value) {
                            if (value == true) {
                              _setMissionStatus(missionTitle, false);
                              _showConfetti();
                            }
                          },
                    controlAffinity: ListTileControlAffinity.leading,
                  );
                }).toList(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('월간 미션',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                ...monthlyMissions.map((mission) {
                  String missionTitle = mission['title']!;
                  return CheckboxListTile(
                    title: Text(missionTitle),
                    subtitle: Text(mission['description']!),
                    value: missionStatus[missionTitle],
                    onChanged: missionStatus[missionTitle] == true
                        ? null
                        : (bool? value) {
                            if (value == true) {
                              _setMissionStatus(missionTitle, true);
                              _showConfetti();
                            }
                          },
                    controlAffinity: ListTileControlAffinity.leading,
                  );
                }).toList(),
              ],
            ),
            if (showConfetti)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      'assets/animation_check.json',
                      width: MediaQuery.of(context).size.width / 2,
                      height: MediaQuery.of(context).size.height / 2,
                      repeat: false,
                    ),
                    SizedBox(height: 10),
                    Text(
                      '+$confettiPoints 포인트!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
