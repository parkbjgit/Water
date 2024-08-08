import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
        color: Colors.grey[200], // 배경색 설정
        child: ListView(
          children: [
            // 상단 알림 배너
            Container(
              color: Colors.brown[100],
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('💡 내 월경 전 PMS 증상은?', style: TextStyle(color: Colors.brown)),
                  Icon(Icons.close, color: Colors.brown),
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
                  Text('6월 25일, 오늘', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: _buildDateCircle('일', '23')),
                      Expanded(child: _buildDateCircle('월', '24')),
                      Expanded(child: _buildDateCircle('화', '25', isSelected: true)),
                      Expanded(child: _buildDateCircle('수', '26')),
                      Expanded(child: _buildDateCircle('목', '27')),
                      Expanded(child: _buildDateCircle('금', '28')),
                      Expanded(child: _buildDateCircle('토', '29')),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            // 체크박스와 텍스트 입력 필드
            _buildCard(
              context,
              '영양제 먹었나요?',
              Icons.check_circle_outline,
              '영양제 먹기',
              true,
              '100코인',
            ),
            _buildCard(
              context,
              '오늘 월경은 어때요?',
              Icons.add_circle_outline,
              '기록 추가하기',
              false,
            ),
            // 아래 섹션은 반복되는 형태로 추가 가능
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.nightlight_round), label: '투데이'),
          BottomNavigationBarItem(icon: Icon(Icons.star_border), label: '고민해결'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: '쇼핑'),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: '블로그'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '마이'),
        ],
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
          backgroundColor: isSelected ? Colors.brown : Colors.grey[300],
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
              Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
              Text(actionText, style: TextStyle(fontSize: 16)),
              Spacer(),
              if (showCheckbox) Checkbox(value: true, onChanged: (value) {}),
            ],
          ),
        ],
      ),
    );
  }
}