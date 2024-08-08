import 'package:Water/pages/garden_page.dart';
import 'package:Water/pages/map_page.dart';
import 'package:Water/pages/mission_page.dart';
import 'package:Water/pages/profile_page.dart';
import 'package:Water/pages/quiz_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime selectedDate = DateTime.now();
  final dayLabels = ['월', '화', '수', '목', '금', '토', '일'];

  int _selectedIndex = 0;

  List<DateTime> _getWeekDates(DateTime now) {
    List<DateTime> weekDates = [];
    for (int i = 0; i < 7; i++) {
      weekDates.add(now.subtract(Duration(days: now.weekday - 1 - i)));
    }
    return weekDates;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
    } else if (index == 1) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => QuizPage()));
    } else if (index == 2) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => GardenPage()));
    } else if (index == 3) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => MapPage()));
    } else if (index == 4) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateFormat = DateFormat('M월 d일');
    final todayDate = dateFormat.format(selectedDate);

    List<DateTime> weekDates = _getWeekDates(now);

    return Scaffold(
      backgroundColor: Colors.blue.shade50, // 배경색을 여기에 설정
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          '홈',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Container(
        // color: Colors.grey[200], // 배경색 설정
        child: ListView(
          children: [
            // 상단 알림 배너
            Container(
              // color: Colors.brown[100],
              color: Colors.blue[50],
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      '💡 나의 물 사용량은?',
                      style: TextStyle(color: Colors.blue),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(Icons.close, color: Colors.amber),
                ],
              ),
            ),
            // 날짜 선택기와 캘린더
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$todayDate', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Row(
                    children: List.generate(7, (index) {
                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedDate = weekDates[index];
                            });
                          },
                          child: _buildDateCircle(
                            dayLabels[index],
                            weekDates[index].day.toString(),
                            isSelected: selectedDate.day == weekDates[index].day,
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            // 체크박스와 텍스트 입력 필드
            _buildCard(
              context,
              '샤워 시간을 5분 이하로 줄이세요.',
              Icons.check_circle_outline,
              '짧은 샤워하기',
              true,
              '100코인',
            ),
            _buildCard(
              context,
              '양치질을 할 때 컵에 물을 받아서 사용하세요.',
              Icons.add_circle_outline,
              '양치질 시 물컵 사용하기',
              false,
            ),
            _buildCard(
              context,
              '세탁할 때 세탁물을 모아서 한 번에 세탁하세요.',
              Icons.check_circle_outline,
              '빨래 모아서 한 번에 하기',
              true,
              '100코인',
            ),
            _buildCard(
              context,
              '설거지를 할 때 물을 틀어 놓지 말고, 물을 받아서 사용하세요.',
              Icons.check_circle_outline,
              '설거지 물 받아서 사용하기',
              true,
              '100코인',
            ),
            _buildCard(
              context,
              '누수 여부를 점검하고, 누수가 있다면 즉시 수리하세요.',
              Icons.check_circle_outline,
              '수도꼭지 점검하기',
              true,
              '100코인',
            ),
            _buildCard(
              context,
              '물 절약형 샤워 필터를 사용하여 물 사용량을 줄이세요.',
              Icons.check_circle_outline,
              '샤워 필터 사용하기',
              true,
              '100코인',
            ),
            // 아래 섹션은 반복되는 형태로 추가 가능
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: '미션'),
          BottomNavigationBarItem(icon: Icon(Icons.quiz), label: '퀴즈'),
          BottomNavigationBarItem(icon: Icon(Icons.local_florist), label: '가상 정원'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: '지도'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '프로필'),
        ],
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
    );
  }

  Widget _buildDateCircle(String day, String date, {bool isSelected = false}) {
    return Column(
      children: [
        Text(day),
        SizedBox(height: 4),
        CircleAvatar(
          radius: 20,
          backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
          child: Text(
            date,
            style: TextStyle(color: isSelected ? Colors.white : Colors.black),
          ),
        ),
      ],
    );
  }

  Widget _buildCard(BuildContext context, String title, IconData icon, String actionText, bool showCheckbox, [String? badge]) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
              ),
              if (badge != null) ...[
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(badge, style: TextStyle(color: Colors.white)),
                ),
              ],
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(icon, size: 40, color: Colors.amber),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  actionText,
                  style: TextStyle(fontSize: 16),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
              ),
              if (showCheckbox) Checkbox(value: true, onChanged: (value) {}),
            ],
          ),
        ],
      ),
    );
  }
}