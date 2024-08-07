import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final itemHeight = (size.height - kToolbarHeight - 24) / 3;
    final itemWidth = (size.width -40) / 3;
    
    return Scaffold(
      appBar: AppBar(
        // title: const Text('홈', style: TextStyle(color: Colors.white)), // 타이틀 텍스트 색상을 흰색으로 설정
        title: const Text('홈'), 
        centerTitle: true, // 타이틀을 가운데 정렬
        // 타이틀 텍스트의 색 변경
        // backgroundColor: const Color(0xFF1C1B1F), // AppBar 색상을 배경색과 맞춤

      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
        // color: const Color(0xFF1C1B1F), // 배경색을 1C1B1F로 설정
        child: Center(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: itemWidth / itemHeight,
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemCount: 9,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return _buildGridItem(
                context, 
                _gridItems[index]['icon'], 
                _gridItems[index]['label'], 
                _gridItems[index]['route'], 
                _gridItems[index]['description'],
              );
            },
          ),
        ),
      ),
    );
  }

  final List<Map<String, dynamic>> _gridItems = [
    {'icon': Icons.assignment, 'label': '미션', 'route': '/mission', 'description': '일일미션을 수행하고 포인트를 받아가세요'},
    {'icon': Icons.quiz, 'label': '퀴즈', 'route': '/quiz', 'description': '퀴즈를 풀고 포인트를 받아가세요'},
    {'icon': Icons.local_florist, 'label': '가상 정원', 'route': '/garden', 'description': '나만의 나무를 키우세요'},
    {'icon': Icons.store, 'label': '상점', 'route': '/reward', 'description': '포인트를 사용해 나무 키우기 아이템을 구매하세요'},
    {'icon': Icons.water_damage, 'label': '물 사용량', 'route': '/water_usage', 'description': '오늘 물을 절약했는지 확인하세요'},
    {'icon': Icons.map, 'label': '지도', 'route': '/map', 'description': '물 위험지수를 확인하세요'},
    {'icon': Icons.leaderboard, 'label': '리더보드', 'route': '/leaderboard', 'description': '리더보드를 확인하세요'},
    {'icon': Icons.login, 'label': '로그인', 'route': '/login', 'description': '로그인하세요'},
    {'icon': Icons.person, 'label': '프로필', 'route': '/profile', 'description': '프로필을 확인하세요'},
  ];

  Widget _buildGridItem(BuildContext context, IconData icon, String label,
      String route, String description) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(route);
      },
      child: Card(
        // color: Colors.grey[850], // 카드 배경색을 어두운 회색으로 설정
        color: const Color.fromARGB(255, 255, 255, 255),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon(icon, size: 30, color: Colors.white), // 아이콘 색상을 흰색으로 설정
            Icon(icon, size: 30),
            const SizedBox(height: 5),
            Text(label,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    // color: Colors.white)), // 텍스트 색상을 흰색으로 설정
                )),
            const SizedBox(height: 5),
            Text(description,
                style: const TextStyle(fontSize: 10, color: Colors.white70),
                textAlign: TextAlign.center), // 설명 텍스트 색상을 밝은 회색으로 설정
          ],
        ),
      ),
    );
  }
}
