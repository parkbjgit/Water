import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('홈'),
        backgroundColor: Color(0xFF1C1B1F), // AppBar 색상을 배경색과 맞춤
      ),
      body: Container(
        color: Color(0xFF1C1B1F), // 배경색을 1C1B1F로 설정
        child: Center(
          child: GridView.count(
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            padding: EdgeInsets.all(10.0),
            shrinkWrap: true,
            children: [
              _buildGridItem(context, Icons.assignment, '미션', '/mission',
                  '일일미션을 수행하고 포인트를 받아가세요'),
              _buildGridItem(context, Icons.quiz, '퀴즈', '/quiz',
                  '퀴즈를 풀고 포인트를 받아가세요'),
              _buildGridItem(context, Icons.local_florist, '가상 정원', '/garden',
                  '나만의 나무를 키우세요'),
              _buildGridItem(context, Icons.store, '상점', '/reward',
                  '포인트를 사용해 나무 키우기 아이템을 구매하세요'),
              _buildGridItem(context, Icons.water_damage, '물 사용량',
                  '/water_usage', '오늘 물을 절약했는지 확인하세요'),
              _buildGridItem(context, Icons.map, '지도', '/map', '물 위험지수를 확인하세요'),
              _buildGridItem(context, Icons.leaderboard, '리더보드',
                  '/leaderboard', '리더보드를 확인하세요'),
              _buildGridItem(context, Icons.login, '로그인', '/login', '로그인하세요'),
              _buildGridItem(context, Icons.person, '프로필', '/profile', '프로필을 확인하세요'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridItem(BuildContext context, IconData icon, String label,
      String route, String description) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(route);
      },
      child: Card(
        color: Colors.grey[850], // 카드 배경색을 어두운 회색으로 설정
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: Colors.white), // 아이콘 색상을 흰색으로 설정
            SizedBox(height: 5),
            Text(label,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)), // 텍스트 색상을 흰색으로 설정
            SizedBox(height: 5),
            Text(description,
                style: TextStyle(fontSize: 10, color: Colors.white70),
                textAlign: TextAlign.center), // 설명 텍스트 색상을 밝은 회색으로 설정
          ],
        ),
      ),
    );
  }
}
